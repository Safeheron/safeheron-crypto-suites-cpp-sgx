cmake_minimum_required(VERSION 3.20)

project("SGXSafeheronCryptoSuites" VERSION 1.0.1)

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
set(PROTOBUF_INCLUDE_DIR "${SGX_SDK_INCLUDE_DIR}/tprotobuf")

# Set the sgxssl path
set(SGX_SSL_PATH "/opt/intel/sgxssl")
set(SGX_SSL_INCLUDE_DIR "${SGX_SSL_PATH}/include")
set(SGX_SSL_LIBRARIES_DIR "${SGX_SSL_PATH}/lib64")
set(TRUST_SGX_SSL_LIBRARY "${SGX_SSL_LIBRARIES_DIR}/libsgx_tsgxssl.a")
set(TRUST_SGX_SSL_CRYPTO_LIBRARY "${SGX_SSL_LIBRARIES_DIR}/libsgx_tsgxssl_crypto.a")
set(UNTRUST_SGX_SSL_LIBRARY "${SGX_SSL_LIBRARIES_DIR}/libsgx_usgxssl.a")

# Set the source file path
set(CRYPTO_SUITES_SOURCE_PATH src/safeheron-crypto-suites-cpp/src)

# Gather source files
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-bn-cpp/src/crypto-bn  BN_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-bn-cpp/src/exception  EXCEPTION_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-hash-cpp/src/crypto-hash  HASH_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-hash-cpp/src/compat  COMPAT_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-encode-cpp/src/crypto-encode  ENCODE_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/src/crypto-curve  CURVE_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-commitment-cpp/src/crypto-commitment  COMMITMENT_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-paillier-cpp/src/crypto-paillier  PAILLIER_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-sss-cpp/src/crypto-sss  SSS_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-zkp-cpp/src/crypto-zkp  ZKP_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-mta-cpp/src/crypto-mta  MTA_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip32-cpp/src/crypto-bip32  BIP32_SOURCE)
AUX_SOURCE_DIRECTORY(${CRYPTO_SUITES_SOURCE_PATH}/crypto-ecies-cpp/src/crypto-ecies  ECIES_SOURCE)

file(GLOB ED25519-DONNA_SOURCES
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
		)

# Build libSGX-CryptoSuites.a
add_library(${CMAKE_PROJECT_NAME} STATIC ${SUITES_SOURCE})

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
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-mta-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip32-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-ecies-cpp/src
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/third_party
		${SGX_SSL_INCLUDE_DIR}
        ${PROTOBUF_INCLUDE_DIR}
        ${SGX_SDK_INCLUDE_DIR}
        ${SGX_C_INCLUDE_DIR}
        ${SGX_CXX_INCLUDE_DIR}
	)

# Link flags
target_link_libraries(${CMAKE_PROJECT_NAME} "${SGX_COMMON_C_FLAGS} \
        -Wl,--no-undefined -nostdlib -nodefaultlibs -nostartfiles -L${SGX_SDK_LIBRARIES_DIR} \
        -Wl,--whole-archive –lsgx_trts ${TRUST_SGX_SSL_LIBRARY} -Wl,--no-whole-archive \
        -Wl,--start-group ${TRUST_SGX_SSL_CRYPTO_LIBRARY} -lsgx_pthread -lsgx_protobuf -lsgx_tstdc -lsgx_tcxx -lsgx_tcrypto -lsgx_tprotected_fs -l${SGX_TSVC_LIB} -Wl,--end-group \
        -Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined \
        -Wl,-pie,-eenclave_entry -Wl,--export-dynamic \
        -Wl,--defsym,__ImageBase=0"
		)

set(ENABLE_ASSEMBLE ON)

include("cmake/setup_installation.cmake")
