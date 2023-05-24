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


set(ED25519-DONNA_SOURCES
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/curve25519-donna-32bit.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/curve25519-donna-helpers.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/curve25519-donna-scalarmult-base.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/ed25519.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/ed25519-donna-32bit-tables.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/ed25519-donna-basepoint-table.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/ed25519-donna-impl-base.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/ed25519-donna-memzero.c
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party/ed25519-donna/modm-donna-32bit.c
		)

set(PROTOBUF_SOURCE_FILES
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-commitment-cpp/src/crypto-commitment/proto_gen/commitment.pb.switch.cc
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/src/crypto-curve/proto_gen/curve_point.pb.switch.cc
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-mta-cpp/src/crypto-mta/proto_gen/mta.pb.switch.cc
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-paillier-cpp/src/crypto-paillier/proto_gen/paillier.pb.switch.cc
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-zkp-cpp/src/crypto-zkp/proto_gen/zkp.pb.switch.cc
		)

set(SUITES_SOURCE
		${BN_SOURCE} ${EXCEPTION_SOURCE}
		${HASH_SOURCE} ${COMPAT_SOURCE}
		${ENCODE_SOURCE}
		${CURVE_SOURCE}
		${COMMITMENT_SOURCE}
		${PAILLIER_SOURCE}
		${SSS_SOURCE}
		${ZKP_SOURCE}
		${MTA_SOURCE}
		${BIP32_SOURCE}
		${ECIES_SOURCE}
		${ED25519-DONNA_SOURCES}
		${PROTOBUF_SOURCE_FILES}
		)

# Build libSGX-CryptoSuites.a
add_library(${CMAKE_PROJECT_NAME} STATIC ${SUITES_SOURCE})

# Additional include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
		${SGX_SSL_INCLUDE_DIR}
		${SGX_SDK_INCLUDE_DIR}
		${SGX_C_INCLUDE_DIR}
		${SGX_CXX_INCLUDE_DIR}
		${SGX_PROTOBUF_INCLUDE_DIR}
		)


set(ENABLE_ASSEMBLE ON)

include("cmake/setup_installation.cmake")
