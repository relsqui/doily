# Release Checklist for [0.2.0](https://github.com/relsqui/doily/milestone/2)

## Planning

* [x] Select issues for the release.
* [x] Create milestone.
* [ ] Create branch for the new version.
* [x] Update version number and milestone URL on checklist.
* [x] Plan changes to installation script, if necessary.

## In Progress

* [ ] Update changelog contents.
* [x] Write tests for new features.
* [ ] Write tests for new plugins.
* [ ] Write migration code (as needed, for major versions).
* [ ] Write migration tests (if there's migration code).

## Features Ready

* [ ] Run shellcheck.
* [x] Run regression tests.
* [ ] Update plugins as needed.
* [ ] Update version in plugins, iff successfully tested.
* [ ] Remove (or incorporate) any debugging-only code.

## Update Documentation

* [ ] Document any interface changes (for major versions).
* [ ] Check commit history for anything missed in changelog.
* [ ] Review inline configuration documentation.
* [ ] Review README.
* [ ] Review --help text in main script.

## Repository Management

* [ ] Update or close relevant issues.
* [ ] Update version in main script.
* [ ] Update version in install script.
* [ ] Update version in default config file.
* [ ] Update changelog version.
* [ ] Create new package tarball.
* [ ] Tag the release commit with `-m 'M.m.p'` and push with `--tags`.
* [ ] Reset the checklist.
