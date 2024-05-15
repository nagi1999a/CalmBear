# CalmBear
(Almost) Static build script for [Bear](https://github.com/rizsotto/Bear) - ʕ·ᴥ·ʔ Build EAR with both 32-bit and 64-bit support

## About
Bear is an excellent tool for collecting compiler flags and information and producing helpful information for IDE to provide suggestions.
I faced a problem when cross-compiling programs on other platforms using a 32-bit compiler, which will need a 32-bit version of the shared library in Bear, thus creating the script to generate it.

## Limitation
The build is not static linking glibc, and they still need basic glibc library >=2.31 to work.
According to [Repology](https://repology.org/project/glibc/versions), common & possibly working distributions are:
1. Ubuntu 20.04+
2. Debian 11+
3. Fedora 32+
4. OpenSUSE 15.3+

## Build
Pre-built binaries are on the Release page, and the version maps to the Bear version.
1. Clone the repo
2. Build the docker image with `Dockerfile`: `sudo docker build -t nagi1999a/calmbear .`
3. Start the container: `sudo docker run -it -v ./:/docker`
4. Inside the container, run the build script: `bash build.sh`
5. After building, built files will be in `output` folder, and you can close the container now: `exit`
6. Install 32-bit `libc` and `libstdc++` and copy all files in `output` folder to the desired path.
   1. For Debian-based distribution, just run `bash debian-install.sh`.
   2. For other distributions, manually put the libraries and executables will be needed.
