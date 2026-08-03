# https://github.com/ycm-core/YouCompleteMe#full-installation-guide
# apt install build-essential cmake vim-nox python3-dev
# apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
git clone --recurse-submodules https://github.com/ycm-core/YouCompleteMe.git ~/.config/vim/pack/YouCompleteMe/opt/YouCompleteMe

pushd ~/.config/vim/pack/YouCompleteMe/opt/YouCompleteMe
export CXXFLAGS="-O3 -march=native" ./install.py --all
popd


