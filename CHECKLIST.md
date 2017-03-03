# Release Checklist for [0.2.0](https://github.com/relsqui/doily/milestone/2)

## Planning

* [x] Select issues for the release.
* [x] Create milestone.
* [x] Update version number and milestone URL on checklist.
* [x] Plan changes to installation script, if necessary.

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
* [ ] Tag the release commit and push with `--tags`.
* [ ] Reset the checklist.
