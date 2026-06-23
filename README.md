# test-repo-actions-b

Octo Queue **test suite** repo (GitHub Actions). Part of the four-repo interdependent deploy demo under [`parunruaivo`](https://github.com/parunruaivo).

## CI

- **Provider:** GitHub Actions (`.github/workflows/deploy.yml`)
- **Trigger:** `workflow_dispatch` (Octo Queue dispatches on deployment branches)
- **Deploy job:** clones all four test repos and prints a deploy report (`scripts/oq-deploy-report.sh`)

## Octo Queue

Assign to a queue with **CI provider = GITHUB_ACTIONS** together with `test-repo-actions-a`. Set CI project workflow file to `.github/workflows/deploy.yml`.

See the [oq-test-repos README](../README.md) for full setup and E2E test flow.
