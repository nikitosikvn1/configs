The configuration files are managed with [GNU Stow].
Each top-level directory represents a "group" of configs, and you can
"install" (by symlinking) the configs of a group using:

```console
$ stow --verbose --stow <group> --target=$HOME
```

You can use `--no` to just show what it _would_ install.

[GNU Stow]: https://www.gnu.org/software/stow/