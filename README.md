[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/relsqui/doily.svg?branch=master)](https://travis-ci.org/relsqui/doily)

# [Doily](https://github.com/relsqui/doily)
(c) 2017 Finn Ellis

Doily quietly manages the logistics of doing a little writing every day,
whether you're journaling, noveling, or thesising. It stores files organized by
date, maintains permission settings that you choose, and can keep your daily
writings in git for you.

You're free to copy, modify, and distribute Doily, with attribution, under the
terms of the MIT license. A copy is included in [LICENSE.txt](LICENSE.txt).

To see what's new, read the [changelog](CHANGELOG.md).


## Installation

Doily's only absolute prerequisites are `bash` and other utilities that come
standard on normal Linux systems (like `date`). Optional features may have
other requirements (notably `git`). The install script uses `curl`. All of
these should be available in your distribution's package manager (using
`apt install curl` or similar).

First, get the install script.

```bash
curl https://raw.githubusercontent.com/relsqui/doily/master/install.sh -o install.sh
```

To install Doily systemwide for anyone to use, run it with no arguments.

```bash
bash install.sh
```

If you're installing for just yourself, run it with the `--user` flag.

```bash
bash install.sh --user
```

If your `~/bin` directory isn't already in your `$PATH`, the script will print
some helpful advice for fixing that. Follow it if you need to.

You can now safely remove the install script, if you wish. (You can also use
it to uninstall doily later.)

```bash
rm install.sh
```


## Configuration

The default configuration keeps all your dailies private, doesn't use git, and
uses your existing default editor and pager and a sensible storage location.
You can change these things by running `doily config`. If you want to read all
the settings and an explanation of them before downloading or running Doily, you
can look at [the default configuration](default.conf).

In a systemwide installation, the default configuration file which is given to
new Doily users lives in `/usr/local/etc/doily/default.conf`.


## Usage

When you run `doily`, it will drop you directly into a text editor. (You can
configure which one in your configuration file, or by setting your `$EDITOR`
environment variable.) Write whatever you came here to write, then save and
quit the editor like normal. The file will be saved and dated.

If you're using git and have elected to write your own commit messages, you'll
be prompted to write a message for the new commit. If you're using automatic
messages, it will just update the repository for you.

Each day that you run `doily`, a new file will be created. If you run it again
on the same day (before midnight, according to the clock of the computer
you're writing on), you'll be editing the same file for that day. If the
day rolls over while you're writing, whatever file you're currently in will
still be saved under the previous day.

### Commands

In addition to the default `write` action, Doily comes with a number of other
commands, which you can add right after the command (like `doily config`).

* `config` opens your configuration file to view or change settings.
* `read [date]` views your past writing in a pager.
* `search [pattern] [date]` searches a past writing for a regex.
* `version` prints your Doily version.
* And, of course, `help` shows you the list of commands and descriptions.

## Tests

Doily is tested with [Bats](https://github.com/sstephenson/bats), the Bash
Automated Testing System. Your distribution's packaging system may provide
it; if not, follow the install directions in its repository.

Once you have Bats, you can run the tests with:

```
bats tests
```

### Bats Bugs

If you get this error:

```
line 20: let: count+=: syntax error: operand expected (error token is "+=")
```

Run this helper script to fix it:

```
bash tests/fix_bats.sh
```

The helper script corrects a
[known bug](https://github.com/sstephenson/bats/issues/140) in Bats.

## Uninstalling

Doily is self-removing with its install script. If you don't still have it,
download it again:

```bash
curl https://raw.githubusercontent.com/relsqui/doily/master/install.sh -o install.sh
```

To remove a systemwide install:

```bash
bash install.sh --remove
```

For a single-user install:

```bash
bash install.sh --user --remove
```

In both cases, users' personal configuration files and daily writings will
not be removed. Running the single-user remove command will print instructions
for also removing your own personal files.


## Status, Feedback, and Contribution

* Have a bug report, idea, or request? Please add them to the
  [issue tracker](https://github.com/relsqui/doily/issues).
* Want to contribute? Yay! Please comment on or create an issue first so we
  can discuss what you want to do before you make a
  [pull request](https://www.thinkful.com/learn/github-pull-request-tutorial/).
* You can view progress towards the next build on the
  [release checklist](CHECKLIST.md).
* When in doubt, feel free to [email me](mailto:relsqui@chiliahedron.com).

## Why "Doily"?

Because "daily" is ungoogleable, especially in a software context.
