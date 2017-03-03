# Release Checklist

## Planning

* [ ] Select issues for the release.
* [ ] Create milestone.
* [ ] Update version number and milestone URL on checklist.
* [ ] Plan changes to installation script, if necessary.
* [ ] Start branch.

## In Progress

* [ ] Update changelog contents.
* [ ] Run shellcheck and revise as needed.
* [ ] Write tests for new features.

## Features Ready

* [ ] Run regression tests.
* [ ] Update version in plugins, iff successfully tested.
* [ ] Remove any testing or debugging code.
* [ ] Document any interface changes (for major versions).
* [ ] Write migration code (as needed, for major versions).
* [ ] Mark new, deprecated, and other feature types in changelog.
* [ ] Review inline configuration documentation.
* [ ] Review README.

## Repository Management

* [ ] Update or close relevant issues.
* [ ] Create new package tarball.
* [ ] Update version in main script.
* [ ] Update version in install script.
* [ ] Update version in default config file.
* [ ] Update changelog version.
* [ ] Merge branch.
* [ ] Tag the release commit and push with `--tags`.
* [ ] Reset the checklist.
