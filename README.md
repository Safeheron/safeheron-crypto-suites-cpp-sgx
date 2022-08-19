# sgx-crypto-suites-cpp

![image](doc/logo.png)

SGX-supported version of [safeheron-crypto-suites-cpp](https://github.com/Safeheron/safeheron-crypto-suites-cpp.git) library implemented by Safeheron.

# Prerequisites

- [SGX Components](https://01.org/intel-software-guard-extensions/downloads)
    - SGX Driver. See [SGX-Driver-Installation](doc/SGX-Driver-Installation.md).
    - SGX SDK (SGX SDK 2.16 or later is required). See [SGX-SDK-Installation](doc/SGX-SDK-Installation.md).
- [Intel SGX-SSL](https://github.com/intel/intel-sgx-ssl.git). See [SGX-SSL-Installation](doc/SGX-SSL-Installation.md).

# Build & Install
    
It only supports Linux now.
```shell
$ git clone --recurse-submodules https://github.com/Safeheron/sgx-safeheron-crypto-suites-cpp.git
$ cd sgx-safeheron-crypto-suites-cpp 
$ mkdir build && cd build
$ cmake ..
$ make
$ sudo make install
```

# To start using sgx-safeheron-crypto-suites-cpp

## CMake

CMake is your best option, the canonical way to discover dependencies in CMake is the find_package command.

You can see the example below:
```cmake
project(XXXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_BUILD_TYPE "Release")

# Set all flags
set(SGX_COMMON_C_FLAGS "-m64 -O2")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nostdinc -fmacro-prefix-map=${CMAKE_SOURCE_DIR}=/safeheron")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS} -nostdinc++ -fmacro-prefix-map=${CMAKE_SOURCE_DIR}=/safeheron")

find_package(SGXSafeheronCryptoSuites REQUIRED)

# Set the sgxsdk path
set(SGX_SDK_PATH "/opt/intel/sgxsdk")
set(SGX_SDK_INCLUDE_DIR "${SGX_SDK_PATH}/include")
set(SGX_SDK_LIBRARIES_DIR "${SGX_SDK_PATH}/lib64")
set(SGX_C_INCLUDE_DIR "${SGX_SDK_INCLUDE_DIR}/tlibc")
set(SGX_CXX_INCLUDE_DIR "${SGX_SDK_INCLUDE_DIR}/libcxx")
set(SGX_PROTOBUF_INCLUDE_DIR "${SGX_SDK_INCLUDE_DIR}/tprotobuf")

# Set the sgxssl path
set(SGX_SSL_PATH "/opt/intel/sgxssl")
set(SGX_SSL_INCLUDE_DIR "${SGX_SSL_PATH}/include")
set(SGX_SSL_LIBRARIES_DIR "${SGX_SSL_PATH}/lib64")
set(TRUST_SGX_SSL_LIBRARY "${SGX_SSL_LIBRARIES_DIR}/libsgx_tsgxssl.a")
set(TRUST_SGX_SSL_CRYPTO_LIBRARY "${SGX_SSL_LIBRARIES_DIR}/libsgx_tsgxssl_crypto.a")
set(UNTRUST_SGX_SSL_LIBRARY "${SGX_SSL_LIBRARIES_DIR}/libsgx_usgxssl.a")

add_library(${PROJECT_NAME} STATIC XXXX.cpp)

# Additional include paths
target_include_directories(${PROJECT_NAME} PUBLIC
        ${SGXSafeheronCryptoSuites_INCLUDE_DIRS}
        ${SGX_SSL_INCLUDE_DIR}
        ${SGX_SDK_INCLUDE_DIR}
        ${SGX_C_INCLUDE_DIR}
        ${SGX_CXX_INCLUDE_DIR}
        ${SGX_PROTOBUF_INCLUDE_DIR}
        )

# Link flags
target_link_libraries(${CMAKE_PROJECT_NAME} "${SGX_COMMON_C_FLAGS} \
        -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L${SGX_SDK_LIBRARIES_DIR} \
        -Wl,--whole-archive –lsgx_trts ${TRUST_SGX_SSL_LIBRARY} -Wl,--no-whole-archive \
        -Wl,--start-group ${TRUST_SGX_SSL_CRYPTO_LIBRARY} ${SGXSafeheronCryptoSuites_LIBRARY} -lsgx_pthread -lsgx_protobuf -lsgx_tstdc -lsgx_tcxx -lsgx_tcrypto -lsgx_tprotected_fs -l${SGX_TSVC_LIB} -Wl,--end-group \
        -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined \
        -Wl,-pie,-eenclave_entry -Wl,--export-dynamic \
        -Wl,--defsym,__ImageBase=0"
        )
```

For more details and examples, please refer to [safeheron-crypto-suites-cpp](https://github.com/Safeheron/safeheron-crypto-suites-cpp.git).

# Development Process & Contact

This library is maintained by Safeheron. Contributions are highly welcomed! Besides GitHub issues and PRs, feel free to reach out by mail.
