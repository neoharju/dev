# dev

personal dev stuff, no guarantees/warranties/liabilities/responsibilities

### Test
```sh
export DEV_ENV=$(pwd)
./run --dry
./dev-env-og --dry
```

### Test run scripts with Docker
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
```

### Install packages; e.g. git, base-devel...
```sh
# for a specific install e.g.
./run dev
# all
./run
```

### Install keybinds/configs/profiles/neovim lsps...
```sh
# for a specific install e.g.
./dev-env-og neovim
# all
./dev-env-og
```

### Ref
[0] https://github.com/ThePrimeagen/dev/
