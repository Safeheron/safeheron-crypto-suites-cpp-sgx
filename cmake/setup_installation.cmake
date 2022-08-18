include(CMakePackageConfigHelpers)

set(exported_targets_name "${PROJECT_NAME}Targets")
set(exported_targets_filename "${exported_targets_name}.cmake")
set(export_dirpath "share/cmake/${PROJECT_NAME}")
set(config_basename "${PROJECT_NAME}Config")
set(config_filename "${config_basename}.cmake")
set(version_filename "${config_basename}Version.cmake")
set(CRYPTO_SUITES_SOURCE_PATH "src/safeheron-crypto-suites-cpp/src")

write_basic_package_version_file(
        ${version_filename}
        COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
	"cmake/${config_filename}.in" "${config_filename}"
        INSTALL_DESTINATION "${export_dirpath}"
)

install(
        TARGETS ${PROJECT_NAME}
        EXPORT ${exported_targets_name}
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include/safeheron-sgx
)

install(
        EXPORT ${exported_targets_name}
        FILE ${exported_targets_filename}
        DESTINATION ${export_dirpath}
)

install(
        FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${config_filename}"
            "${CMAKE_CURRENT_BINARY_DIR}/${version_filename}"
        DESTINATION
            ${export_dirpath}
)

## Install head files
install(
        DIRECTORY
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-bn-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-hash-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-encode-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-curve-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-commitment-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-paillier-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-sss-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-zkp-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-mta-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-bip32-cpp/src/
		${CRYPTO_SUITES_SOURCE_PATH}/crypto-ecies-cpp/src/

		DESTINATION include/safeheron-sgx
        FILES_MATCHING PATTERN "*.h"

        # crypto-bip32-cpp
        PATTERN "ed25519_ex.h" EXCLUDE
        PATTERN "openssl_curve_wrapper.h" EXCLUDE
        PATTERN "util.h" EXCLUDE
        PATTERN "memzero.h" EXCLUDE
        PATTERN "bip32_ed25519.h" EXCLUDE
        PATTERN "bip32_ecdsa.h" EXCLUDE

        # crypto-curve-cpp
        PATTERN "ed25519_ex.h" EXCLUDE
        PATTERN "openssl_curve_wrapper.h" EXCLUDE

        # crypto-encode-cpp
        PATTERN "base64_imp.h" EXCLUDE
        PATTERN "hex_imp.h" EXCLUDE
        PATTERN "base58_imp.h" EXCLUDE

        # crypto-hash-cpp
        PATTERN "compat" EXCLUDE
)
