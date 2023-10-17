if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  sed -i "/INTERFACE_INCLUDE_DIRECTORIES/c\  INTERFACE_INCLUDE_DIRECTORIES \"$PREFIX/include/rdkit;$PREFIX/include\"" "$PREFIX/lib/cmake/rdkit/rdkit-targets.cmake"
  sed -i 's/ -Werror//' "$SRC_DIR/CMakeLists.txt"
fi

# workaround for old macOS sdk
# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
if [[ "$target_platform" == osx-64 ]]; then
    export CXXFLAGS="$CXXFLAGS -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake ${CMAKE_ARGS} \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D CMAKE_INSTALL_LIBDIR=lib \
    -D CMAKE_BUILD_TYPE=Release \
    $SRC_DIR

make

LD_LIBRARY_PATH=$PWD/src ctest --output-on-failure

make install
