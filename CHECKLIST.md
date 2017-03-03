# Release Checklist

## Planning

* [x] Issues selected for release.
* [x] Plan changes to installation script, if necessary.
* [x] Start branch.

## In Progress

* [x] Update changelog contents.
* [x] Run shellcheck.
* [-] Write tests for new features.

## Features Ready

* [-] Run regression tests.
* [-] Update version in plugins, iff successfully tested.
* [x] Remove any testing or debugging code.
* [-] Document any interface changes (for major versions).
* [-] Write migration code (as needed, for major versions).
* [x] Mark new, deprecated, and other feature types in changelog.
* [x] Review inline configuration documentation.
* [x] Review README.

## Repository Management

* [x] Update or close relevant issues.
* [ ] Create new package tarball.
* [ ] Update version in main script.
* [ ] Update version in install script.
* [ ] Update version in README.
* [ ] Update changelog version.
* [ ] Merge branch.
* [ ] Tag the release commit.
* [ ] Reset the checklist!
