### Doily
(c) 2017 Finn Ellis

https://github.com/relsqui/doily

Doily quietly manages the logistics of doing a little writing every day,
whether you're journaling, noveling, or thesising. It stores files organized by
date, maintains permission settings that you choose, and can keep your daily
writings in git for you.

For the actual writing part, you're on your own.

## License

You're free to copy, modify, and distribute Doily, with attribution, under the
terms of the MIT license. A copy is included in LICENSE.txt.

## Setup

The first time you run `doily`, it will create a configuration file in your home
directory called `.doilyrc`.  You can edit it to change your settings, such as
who can view your dailies and whether you want to customize your commit
messages.

If you want to check out those settings and the explanation before downloading
or running Doily, it's all in a heredoc in the script itself. :)

## Usage

After creating your configuration (see above), simply run `doily` again. It
will drop you into a text editor where you can write whatever you want.

When you're done, save and quit the text editor like normal. If you're using
git and have elected to write your own commit messages, you'll be prompted to
write a message for the new commit.

If you run `doily` again on the same day (before midnight, according to the
clock of the computer you're writing on), you'll be editing the same file for
that day. If the day rolls over while you're writing, whatever file you're
currently in will still be saved as the previous day.

## Feedback and Contribution

* Have a bug report or request? Please add them to the
  [issue tracker](https://github.com/relsqui/doily/issues).
* Want to contribute? Make a
  [pull request](https://www.thinkful.com/learn/github-pull-request-tutorial/).
  If you're not addressing an existing issue, please open one (or email) first
  to get feedback on your idea.
* When in doubt? Feel free to [email me](mailto:relsqui@chiliahedron.com)!
