#!/bin/bash
export SOURCE_DIR="$(pwd)"
export GIT_SSL_NO_VERIFY=1

COLOR_INFO() {
    echo -e "\033[43m\033[30m [INFO] $1 \033[0m"
}

COLOR_INFO "Cloning gRPC repo.."
git clone -b v1.49.2 https://github.com/grpc/grpc --depth 1 --recurse-submodules --shallow-submodules

COLOR_INFO "Cloning Bear repo and apply static patch..."
git clone -b 3.1.3 https://github.com/rizsotto/Bear.git --depth 1
cd Bear
git apply "$SOURCE_DIR/bear.patch"

COLOR_INFO "Creating patch for pkg-config..."
cd "$SOURCE_DIR"
echo -e '#!/bin/bash \n pkg-config --static $@' > /usr/bin/pkg-config1 && chmod +x /usr/bin/pkg-config1
mkdir -p output/i386
mkdir -p output/x86_64

# Build 32bit gRPC
COLOR_INFO "Bulding 32bit gRPC..."
export PKG_CONFIG_PATH=/usr/local/lib/i386-linux-gnu/pkgconfig:/usr/lib/i386-linux-gnu/pkgconfig
mkdir -p grpc/cmake/build32
cd grpc/cmake/build32
cmake ../.. -DgRPC_INSTALL=ON                 \
              -DCMAKE_BUILD_TYPE=Release      \
              -DgRPC_ABSL_PROVIDER=module     \
              -DgRPC_CARES_PROVIDER=module    \
              -DgRPC_PROTOBUF_PROVIDER=module \
              -DgRPC_RE2_PROVIDER=package     \
              -DgRPC_SSL_PROVIDER=package     \
              -DgRPC_ZLIB_PROVIDER=package    \
              -DCMAKE_C_FLAGS="-m32"          \
              -DCMAKE_CXX_FLAGS="-m32"        \
              -DCMAKE_INSTALL_LIBDIR=lib/i386-linux-gnu
make -j8
make install
cd "$SOURCE_DIR"

COLOR_INFO "Bulding 32bit Bear..."
# Build 32bit Bear
mkdir -p Bear/cmake-build32
cd Bear/cmake-build32
cmake .. -DPKG_CONFIG_EXECUTABLE="/usr/bin/pkg-config1" \
         -DENABLE_FUNC_TESTS=OFF                        \
         -DENABLE_UNIT_TESTS=OFF                        \
         -DENABLE_MULTILIB=ON                           \
         -DCMAKE_C_FLAGS="-m32"                         \
         -DCMAKE_CXX_FLAGS="-m32"                       \
         -DCMAKE_INSTALL_LIBDIR=lib/i386-linux-gnu
make -j8
cd "$SOURCE_DIR"
cp -r Bear/cmake-build32/stage/* output/i386/

# Build 64bit gRPC
COLOR_INFO "Bulding 64bit gRPC..."
export PKG_CONFIG_PATH=/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig
mkdir -p grpc/cmake/build64
cd grpc/cmake/build64
cmake ../.. -DgRPC_INSTALL=ON                 \
              -DCMAKE_BUILD_TYPE=Release      \
              -DgRPC_ABSL_PROVIDER=module     \
              -DgRPC_CARES_PROVIDER=module    \
              -DgRPC_PROTOBUF_PROVIDER=module \
              -DgRPC_RE2_PROVIDER=package     \
              -DgRPC_SSL_PROVIDER=package     \
              -DgRPC_ZLIB_PROVIDER=package    \
              -DCMAKE_C_FLAGS="-m64"          \
              -DCMAKE_CXX_FLAGS="-m64"        \
              -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu
make -j8
make install
cd "$SOURCE_DIR"

# Build 64bit Bear
COLOR_INFO "Bulding 64bit Bear..."
mkdir -p Bear/cmake-build64
cd Bear/cmake-build64
cmake .. -DPKG_CONFIG_EXECUTABLE="/usr/bin/pkg-config1" \
         -DENABLE_FUNC_TESTS=OFF                        \
         -DENABLE_UNIT_TESTS=OFF                        \
         -DENABLE_MULTILIB=ON                           \
         -DCMAKE_C_FLAGS="-m64"                         \
         -DCMAKE_CXX_FLAGS="-m64"                       \
         -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu
make -j8
cd "$SOURCE_DIR"
cp -r Bear/cmake-build64/stage/* output/x86_64/

COLOR_INFO "Finished!"










