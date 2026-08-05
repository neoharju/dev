#!/usr/bin/env bash
# lib/optimize.sh
#
# exports to optimize builds with run
export CC="gcc"
export CXX="g++"
export CFLAGS="-O3 -march=native -flto=auto -DNDEBUG -s"
export CXXFLAGS="-O3 -march=native -flto=auto -DNDEBUG -s"
export RUSTFLAGS="-C opt-level=3 -C target-cpu=native -C lto=fat -C debuginfo=0 -C strip=symbols"

