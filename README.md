# MsPac

MsPac is a package manager written in ruby which tries to mirror
Arch's pacman. It's meant for installing opensource tools from source.
It only supports `git` or `hg` repos at this time. I hope to add `bzr`
and `svn` later. It only supports `apt-get` and `pacman` for
installing dependencies at this time. I hope to add support for
`brew`, `yum`, and `zipper` later.

MsPac installs tools by reading pellet files. The pellets are
contained in a separate repo located
[here](https://gitlab.com/mjwhitta/pellets). It is not safe to assume
that the pellets are stable. Any changes to build instructions, of the
tools themselves, could break MsPac. While I personally wouldn't put
malicous code into a pellet file, it's also not safe to assume I
properly audited any community contributions. I mean, I would hope so,
because I use this myself, but I'm not perfect. Use at your own risk.

## How to install

```bash
$ gem install mspac
$ mspac -Sy
```

## Usage

```
Usage: mspac <operation> [OPTIONS] [pellets]

OPERATIONS
    -h, --help            Display this help message
        --list-cached     List cached pellets
        --list-installed  List installed pellets
        --list-pellets    List available pellets
    -L, --lock            Lock a pellet at it's current version
    -R, --remove          Remove pellets
    -S, --sync            Synchronize pellets
    -U, --unlock          Unlock a pellet

SYNC OPTIONS
    -c, --clean           Remove pellets that are no longer installed
                          from the cache
    -f, --force           Force a reinstall of the pellet
    -s, --search=regex    Search each pellet for names matching the
                          provided regex and display them
    -u, --sysupgrade      Upgrade all pellets
    -y, --refresh         Refresh available pellets

REMOVE OPTIONS
    -n, --nosave          Completely remove pellet
```

## Links

- [Homepage](http://mjwhitta.github.io/mspac)
- [Source](https://gitlab.com/mjwhitta/mspac)
- [Mirror](https://github.com/mjwhitta/mspac)
- [RubyGems](https://rubygems.org/gems/mspac)

## TODO

- Better README
- RDoc
