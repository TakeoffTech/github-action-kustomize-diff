# GitHub Action for kustomize-diff

This [action](https://help.github.com/en/actions) can be used in any repository that uses [kustomize](https://kustomize.io/).

# Summary

The steps the action takes are as follows:

- Store the output of `kustomize build` (for each environment) on the current branch.
- Store the output of `kustomize build` (for each environment) on the master branch.
- Based on the two outputs above it performs a git diff and stores the output in a variable called `escaped_output`.

This action can be combined with [unsplash/comment-on-pr](https://github.com/unsplash/comment-on-pr) to comment the output to the PR. 

# Example configuration

The below example will run `kustomize-diff` against your branch and commit the changes due to be applied back to your Pull Request.

```
name: kustomize-diff
on:
  pull_request:
    paths:
      - 'kustomize/**'

jobs:
  kustomize-diff:
    runs-on: ubuntu-latest
    steps:
      - id: checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - id: kustomize-diff
        uses: eeveebank/github-action-kustomize-diff@master
      - id: comment
        uses: unsplash/comment-on-pr@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          msg: ${{ steps.kustomize-diff.outputs.diff }}
          check_for_duplicate_msg: false
```