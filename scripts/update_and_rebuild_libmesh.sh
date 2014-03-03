#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export LIBMESH_DIR=$SCRIPT_DIR/../libmesh/installed
export METHODS=${METHODS:="opt oprof dbg"}
export JOBS=${JOBS:=1}

cd $SCRIPT_DIR/..

# Test for git repository
git_dir=`git rev-parse --show-cdup 2>/dev/null`
if [[ $? == 0 && "x$git_dir" == "x" ]]; then
  echo "here"
  git submodule init
  git submodule update
fi

cd $SCRIPT_DIR/../libmesh

rm -rf build installed
mkdir build
cd build

../configure --with-methods="${METHODS}" \
             --prefix=$LIBMESH_DIR \
             --enable-default-comm-world \
             --enable-silent-rules \
             --enable-unique-id \
             --disable-warnings \
             --enable-openmp $*

make -j $JOBS
make install