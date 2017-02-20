# [Doily](https://github.com/relsqui/doily)
(c) 2017 Finn Ellis

Doily quietly manages the logistics of doing a little writing every day,
whether you're journaling, noveling, or thesising. It stores files organized by
date, maintains permission settings that you choose, and can keep your daily
writings in git for you.

You're free to copy, modify, and distribute Doily, with attribution, under the
terms of the MIT license. A copy is included in LICENSE.txt.


## Installation

Doily's only absolute prerequisites are `bash` and other utilities that come
standard on normal linux systems (like `date`). Optional features may have
other requirements (notably `git`).

First, grab the code from this repository.

```bash
git clone https://github.com/relsqui/doily.git
```

The simplest way to proceed from here is just to cd into the repository and
run the script directly.

```bash
cd doily
./doily
```

If you want to be able to run `doily` from anywhere, you need to link it
into somewhere that's in your `$PATH`. For example, you can create a `~/bin`
directory for yourself and put it there.

```bash
mkdir ~/bin
ln -s ./doily ~/bin/doily
```

Then add this line to your `.bashrc` if it's not already there:

```
export PATH="$PATH:~/bin"
```

After you log out and log back in (or just `source .bashrc`), you should be
able to type `doily` from any directory to run Doily.


## Configuration

The first time you run `doily`, it will create a configuration file and echo
its path.  You can edit that file to change your settings, such as who can
view your dailies and whether you want to customize your git commit messages.

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


## Status, Feedback, and Contribution

Doily is currently in alpha, prior to its
[first numbered version release](https://github.com/relsqui/doily/milestone/1),
which will respect [semantic versioning](http://semver.org). Consequently,
*the interface may change suddenly* while new features are added and tested.
I strongly encourage you to play with Doily and report back, but if you're
writing things that are important to you, please back them up somewhere safe!
(One way to do this would be to enable `use_git` and periodically `git pull`
the resulting repository to another directory.)

For the same reason, it's a little early to be adding large amounts of new
feature code, and a great time for suggestions and comments about architecture
and features.

* Have a bug report, idea, or request? Please add them to the
  [issue tracker](https://github.com/relsqui/doily/issues).
* Want to contribute? Yay! Please comment on or create an issue first so we can
  discuss what you want to do before you make a
  [pull request](https://www.thinkful.com/learn/github-pull-request-tutorial/).
* When in doubt, feel free to just [email me](mailto:relsqui@chiliahedron.com).

## Why "Doily"?

Because "daily" is ungoogleable.
