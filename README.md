# dev
Personal linux dev-machine bootstrap: install packages, then
dotfiles/configs. No guarantees/warranties/liabilities/responsibilities.

TODO: check-versions script, default git conf, templates(?), debian version

## Flags

Every entrypoint (`run`, `dev-env`, and each `packages.d/*` script)
understands:

- `--dry` -- print what would happen, touch nothing.
- `-h` / `--help` -- usage (on `run` and `dev-env`).

## Test

```sh
export DEV_ENV=$(pwd)
./run --dry
./dev-env --dry
```

## Install packages (HyDE, cpp-tools, tmux, vim, neovim, ...)

```sh
export DEV_ENV=$(pwd)

# one target
./run dev

# everything under packages.d/
./run
```

## Install dotfiles/configs

```sh
export DEV_ENV=$(pwd)

# copy (default)
./dev-env

# symlink instead, so edits under $HOME follow the repo
./dev-env --link
```

## Test run scripts with Docker
```sh
docker build -t archenjoyer .
docker run --rm -it --tmpfs /tmp archenjoyer sh
```
While inside the container 
```sh
git clone https://github.com/neoharju/dev.git
cd dev
export DEV_ENV=$(pwd)
./run
./dev-env
```

### Check bash scripts for basic functioning
```bsh
bash shellchecker
```

### Ref
[0] https://github.com/ThePrimeagen/dev/
