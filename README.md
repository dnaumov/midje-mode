# Overview

Midje-mode is an Emacs minor mode for
[Midje](https://github.com/marick/Midje) - test framework for Clojure,
which provides a migration path from clojure.test to a more flexible,
readable, abstract, and gracious style of testing.

See also wiki pages
[about midje-mode](https://github.com/marick/Midje/wiki/Midje-mode)
and [clojure-jump-to-file](https://github.com/marick/Midje/wiki/Clojure-jump-to-file).

# Install

Midje-mode can be installed through el-get: just add `midje-mode` to
your `el-get-sources`.

In addition, Midje-mode is on [marmalade-repo.org](http://marmalade-repo.org). Follow the
instructions on marmalade-repo.org to use the maramalde repo, then
install the midje-mode package.

Finally, you can download files manually
and place it somewhere on `load-path`, then add following lines to
your .emacs file:

    (require 'midje-mode)
    (require 'clojure-jump-to-file)

# Configure

When a command that only checks a single fact succeeds, midje-mode's
default behavior is to insert random praise in a comment before the
fact. You can customize the collection of praise by changing the
variable `midje-praise-quotes`. If you set it to `nil`, no praise will
be inserted as a comment; instead, you will see a slightly less
inspiring message in the minibuffer when your checks pass.

# Contributors

* Chris Bilson
* Ye He
* Andreas Liljeqvist
* Dave Kincaid
* Brian Marick
* Dmitri Naumov
* Steve Purcell
* Jani Rahkola
* "fmezas"
