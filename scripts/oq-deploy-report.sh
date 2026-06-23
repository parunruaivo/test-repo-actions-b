#!/usr/bin/env bash
set -euo pipefail

GITHUB_OWNER="${GITHUB_OWNER:-parunruaivo}"
DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"
TRIGGER_REPO="${TRIGGER_REPO:-unknown}"
CI_PROVIDER="${CI_PROVIDER:-unknown}"
SOURCE="${SOURCE:-}"

REPOS=(
  "test-repo-circleci-a"
  "test-repo-circleci-b"
  "test-repo-actions-a"
  "test-repo-actions-b"
)

WORK_DIR="${WORK_DIR:-/tmp/oq-deploy-report}"
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"

clone_repo() {
  local slug="$1"
  local dest="${WORK_DIR}/${slug}"
  local url="https://github.com/${GITHUB_OWNER}/${slug}.git"

  if git ls-remote --heads "${url}" "${DEPLOY_BRANCH}" 2>/dev/null | grep -q "${DEPLOY_BRANCH}"; then
    git clone --depth 1 --branch "${DEPLOY_BRANCH}" "${url}" "${dest}" 2>/dev/null
  else
    git clone --depth 1 --branch main "${url}" "${dest}" 2>/dev/null
  fi
}

readme_line() {
  local path="$1"
  if [[ -f "${path}" ]]; then
    head -n 1 "${path}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
  else
    echo "(no README)"
  fi
}

echo "=== Octo Queue deploy report ==="
echo "trigger: ${GITHUB_OWNER}/${TRIGGER_REPO} @ ${DEPLOY_BRANCH}"
echo "ci: ${CI_PROVIDER}  source: ${SOURCE:-n/a}"
echo ""
printf "%-28s %-16s %-10s %s\n" "repo" "branch" "commit" "readme"
printf "%-28s %-16s %-10s %s\n" "----" "------" "------" "------"

for slug in "${REPOS[@]}"; do
  clone_repo "${slug}"
  dest="${WORK_DIR}/${slug}"
  if [[ -d "${dest}/.git" ]]; then
    branch="$(git -C "${dest}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")"
    commit="$(git -C "${dest}" rev-parse --short HEAD 2>/dev/null || echo "?")"
    readme="$(readme_line "${dest}/README.md")"
  else
    branch="clone-failed"
    commit="-"
    readme="(unavailable)"
  fi
  printf "%-28s %-16s %-10s %s\n" "${slug}" "${branch}" "${commit}" "${readme}"
done

echo ""
echo "=== deploy ok ==="
