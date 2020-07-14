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

# Generate the changelog
github_changelog_generator \
    --user $INPUT_USER \
    --project $INPUT_PROJECT \
    --token $TOKEN \
    --date-format "%Y-%m-%d" \
    --output "CHANGELOG.md" \
    --pull-requests \
    --author \
    --header-label "# Changelog" \
    --unreleased-label "$NEXT_TAG (UNRELEASED)" \
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
                \"build\",
                \"chore\",
                \"ci\",
                \"style\"
            ]
        }
    }"

# Remove the "automatically generated" message from the end of the changelog
sed -i '/This Changelog was automatically generated/d' CHANGELOG.md

# Export the contents of the CHANGELOG.md file as a GitHub Action
# output variable named `changelog`
echo ::set-output name=changelog::"$(cat "CHANGELOG.md")"
