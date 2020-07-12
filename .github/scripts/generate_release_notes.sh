#!/bin/bash

# Contents heavily borrowed from
# https://github.com/heinrichreimer/action-github-changelog-generator/blob/master/entrypoint.sh

# Go to GitHub workspace.
if [ -n "$GITHUB_WORKSPACE" ]; then
  cd "$GITHUB_WORKSPACE" || exit
fi

# Set repository from GitHub, if not set.
if [ -z "$INPUT_REPO" ]; then INPUT_REPO="$GITHUB_REPOSITORY"; fi
# Set user input from repository, if not set.
if [ -z "$INPUT_USER" ]; then INPUT_USER=$(echo "$INPUT_REPO" | cut -d / -f 1 ); fi
# Set project input from repository, if not set.
if [ -z "$INPUT_PROJECT" ]; then INPUT_PROJECT=$(echo "$INPUT_REPO" | cut -d / -f 2- ); fi

mkdir .tmp
github_changelog_generator \
    --user $INPUT_USER \
    --project $INPUT_PROJECT \
    --token $TOKEN \
    --date-format "%Y-%m-%d" \
    --output ".tmp/CHANGELOG.md" \
    --pull-requests \
    --author \
    --header-label "## Changes in this release" \
    --unreleased-label "REMOVE_THIS_LINE" \
    --no-compare-link \
    --usernames-as-github-logins \
    --breaking-label "### Breaking Changes:" \
    --breaking-labels "semver:breaking" \
    --enhancement-label "### Implemented enhancements" \
    --enhancement-labels "semver:feature,feat,test,refactor,perf" \
    --bugs-label "### Fixed bugs" \
    --bug-labels "semver:patch,fix,revert" \
    --add-sections \
    "{
        \"documentation\": {
            \"prefix\": \"### Docs Updates\",
            \"labels\": [
                \"docs\"
            ]
        }, 
        \"misc\": {
            \"prefix\": \"### Misc. Improvements\",
            \"labels\": [
                \"chore\",
                \"ci\",
                \"style\"
            ]
        }
    }"

sed -i '/This Changelog was automatically generated/d' .tmp/CHANGELOG.md
sed -i '/REMOVE_THIS_LINE/{N;d}' .tmp/CHANGELOG.md
sed -n '/## \[v/q;p' .tmp/CHANGELOG.md > .tmp/RELEASE_NOTES.md

echo ::set-output name=release_notes::"$(cat ".tmp/RELEASE_NOTES.md")"

# if [ -z "NEXT_TAG" ]; then NEXT_TAG="Unreleased"; fi

# github_changelog_generator \
#     --user $INPUT_USER \
#     --project $INPUT_PROJECT \
#     --date-format "%Y-%m-%d" \
#     --output "" \
#     --pull-requests \
#     --author \
#     --unreleased-label "${NEXT_TAG}"
