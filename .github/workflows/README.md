# GitHub Actions for `packer-builder-arm`

This repository has several GitHub Action workflows attached to make both managing and testing the project simple. The scripts and their purposes are outlined below.

## Development Management Workflows

### `manage_pr.yml` - Manage Pull Request

#### Summary

This workflow prevents a pull request from being merged unless it conforms to the best practice guidelines of this project. It performs several distinct actions.

1. This action uses the [*Conform* GitHub Action](https://github.com/talos-systems/conform) tool to ensure that the pull request meets the definition defined in the repository's `.confirm.yaml` file. These checks include commit message lengths, whether to developer has signed off on the commit, whether the commit conforms to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), etc.

2. The [*Required Labels* GitHub Action](https://github.com/mheap/github-action-required-labels) ensures that the PR has exactly one of the following labels: `semver:breaking`, `semver:feature`, `semver:patch`, `chore`, and `ci`. This ensures that the semantic version number is properly incremented, unless the PR doesn't affect the project's code itself.

3. The [*Required Labels* GitHub Action](https://github.com/mheap/github-action-required-labels) ensures that the PR has at least one of the following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) labels: `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, and `test`.

4. The [*Required Labels* GitHub Action](https://github.com/mheap/github-action-required-labels) ensures that the PR doesn't contain any labels that should prevent it from being merged into the master branch. These include the `WIP` label, as well as the `wontmerge`, `wontfix`, and `duplicate` labels.

#### Triggers

* When pull requests are opened, labeled, unlabeled, or synchronized

## Release Management Workflows

### `tag_release.yml` - Manage Pull Request

#### Summary

This workflow uses the [*Semver Release* Github Action](https://github.com/K-Phoen/semver-release-action) to automatically determine the next Semantic Verion number.

#### Triggers

* When pull requests are synchronized, closed, opened, or edited.

## Project Management Actions

### `manage_labels.yml` - Manage Repository Labels

#### Summary

This action uses the [*Label Syncer* GitHub Action](https://github.com/micnncim/action-label-syncer) to manage the labels on this repository in a declarative way. The configuration file found at `.github/labels.yml` is used to define the labels that are available on the project, the description of each label, and the color of each label.

This workflow ensures that the only labels present in this repository are those defined in the configuration file.

#### Triggers

* On `push` to `master`
* When labels are created, edited, or deleted
* When pull requests are opened
* When issues are opened
