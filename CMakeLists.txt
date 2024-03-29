cmake_minimum_required(VERSION 3.20)

project("SafeheronCryptoSuitesSgx" VERSION 1.0.1)

add_definitions(-DPB_ENABLE_SGX)
add_definitions(-DSAFEHERON_SGX_SDK)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_BUILD_TYPE "Release")

# Set all flags
set(SGX_COMMON_C_FLAGS "-m64 -O2")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nostdinc -fmacro-prefix-map=${CMAKE_SOURCE_DIR}=/safeheron")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS} -nostdinc++ -fmacro-prefix-map=${CMAKE_SOURCE_DIR}=/safeheron")

cmake_policy(SET CMP0076 NEW)
cmake_policy(SET CMP0077 NEW)
cmake_policy(SET CMP0079 NEW)

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

# Set the source file path
set(CRYPTO_SUITES_SOURCE_PATH src/safeheron-crypto-suites-cpp/src)

# Build libSafeheronCryptoSuitesSgx.a
add_library(${CMAKE_PROJECT_NAME} STATIC "")

# Additional include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-bn-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-hash-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-encode-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-commitment-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-paillier-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-sss-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-zkp-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip32-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-ecies-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip39-cpp/src
		${SGX_SSL_INCLUDE_DIR}
		${SGX_SDK_INCLUDE_DIR}
		${SGX_C_INCLUDE_DIR}
		${SGX_CXX_INCLUDE_DIR}
		${SGX_PROTOBUF_INCLUDE_DIR}
		)

set(ENABLE_ASSEMBLE ON)
add_definitions(-DENABLE_ASSEMBLE)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-bn-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-hash-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-encode-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-commitment-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-paillier-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-sss-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-zkp-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip32-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-ecies-cpp/src)
add_subdirectory(${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip39-cpp/src)

include("cmake/setup_installation.cmake")
