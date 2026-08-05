#!/usr/bin/env bash
# lib/optimize-no-lto.sh
#
# exports to optimize builds with run
export CC="gcc"
export CXX="g++"
export CFLAGS="-O3 -march=native -DNDEBUG -s"
export CXXFLAGS="-O3 -march=native -DNDEBUG -s"
export RUSTFLAGS="-C target-cpu=native -C opt-level=3 -C debuginfo=0 -C strip=symbols"

