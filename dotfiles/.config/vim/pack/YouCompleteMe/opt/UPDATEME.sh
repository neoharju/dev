pushd ~/.config/vim/pack/YouCompleteMe/opt/YouCompleteMe
git pull
git submodule update --init --recursive
export CXXFLAGS="-O3 -march=native" ./install.py --all
popd
