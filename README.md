# MsPac

<a href="https://www.buymeacoffee.com/mjwhitta">🍪 Buy me a cookie</a>

## What is this?

MsPac is a package manager written in ruby which tries to mirror
Arch's pacman. It's meant for installing opensource tools from source.
It only supports `git` or `hg` repos at this time. I hope to add `bzr`
and `svn` later. It only supports `apt-get` and `pacman` for
installing dependencies at this time. I hope to add support for
`brew`, `yum`, and `zipper` later.

MsPac installs tools by reading pellet files. The pellets are
contained in a separate repo located
[here](https://github.com/mjwhitta/pellets). It is not safe to assume
that the pellets are stable. Any changes to build instructions, of the
tools themselves, could break MsPac. While I personally wouldn't put
malicous code into a pellet file, it's also not safe to assume I
properly audited any community contributions. I mean, I would hope so,
because I use this myself, but I'm not perfect. Use at your own risk.

## How to install

```
$ gem install mspac
$ mspac -Sy
```

## Usage

```
$ mspac -h
Usage: mspac <operation> [OPTIONS] [pellets]

OPERATIONS
    -h, --help            Display this help message
    -L, --lock            Lock a pellet at it's current version
    -R, --remove          Remove pellets
    -S, --sync            Synchronize pellets
    -U, --unlock          Unlock a pellet

SYNC_OPTIONS
    -c, --clean           Remove pellets that are no longer installed
                          from the cache
    -f, --force           Force a reinstall/recompilation of the pellet
    -s, --search          Search each pellet for names matching the
                          provided regex and display them
    -u, --sysupgrade      Upgrade all pellets
    -y, --refresh         Refresh available pellets

REMOVE_OPTIONS
    -n, --nosave          Completely remove pellet

MISC_OPTIONS
        --list-cached     List cached pellets
        --list-installed  List installed pellets
        --list-pellets    List available pellets
        --nocolor         Disable colorized output
    -v, --verbose         Show backtrace when error occurs
```

## Links

- [Source](https://github.com/mjwhitta/mspac)
- [RubyGems](https://rubygems.org/gems/mspac)

## TODO

- Better README
- RDoc
