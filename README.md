# [Doily](https://github.com/relsqui/doily)
(c) 2017 Finn Ellis

Doily quietly manages the logistics of doing a little writing every day,
whether you're journaling, noveling, or thesising. It stores files organized by
date, maintains permission settings that you choose, and can keep your daily
writings in git for you.

You're free to copy, modify, and distribute Doily, with attribution, under the
terms of the MIT license. A copy is included in LICENSE.txt.

## Setup

The first time you run `doily`, it will create a configuration file and tell
you where.  You can edit that file to change your settings, such as who can
view your dailies and whether you want to customize your commit messages.

If you want to read all the settings and an explanation of them before
downloading or running Doily, you can look at
[the default configuration](default.cfg).

## Usage

After creating your configuration, simply run `doily` again. It will drop
you into a text editor where you can write whatever you want.

When you're done, save and quit the text editor like normal. If you're using
git and have elected to write your own commit messages, you'll be prompted to
write a message for the new commit.

Each day that you run `doily`, a new file will be created. If you run it again
on the same day (before midnight, according to the clock of the computer
you're writing on), you'll be editing the same file for that day. If the
day rolls over while you're writing, whatever file you're currently in will
still be saved under the previous day.

## Feedback and Contribution

* Have a bug report or request? Please add them to the
  [issue tracker](https://github.com/relsqui/doily/issues).
* Want to contribute? Make a
  [pull request](https://www.thinkful.com/learn/github-pull-request-tutorial/).
  If you're not addressing an existing issue, please open one (or email) first
  to get feedback on your idea.
* When in doubt? Feel free to [email me](mailto:relsqui@chiliahedron.com)!

## Why "Doily"?

Because "daily" is ungoogleable.
