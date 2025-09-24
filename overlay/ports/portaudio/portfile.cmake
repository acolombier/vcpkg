vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO acolombier/portaudio
    REF cd0fe4d33143044b4fbd1d455fb32beef2c909a3
    SHA512 88b7aad089bc29ebd4aecf0cdcc5ba57f456d799f435a0f779285a1ec79bde23d213989b3c21200f70d6fede6c4670f5fcb4cdcdc9bf6999aa493e18e8107449
    # PATCHES
    #     "0001-Add-basic-support-for-iOS-to-portaudio.patch"
    #     "0002-Update-CMakeLists-with-iOS-implementation.patch"
    #     "0003-Fix-renamed-memory-allocation-functions.patch"
)

string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} dynamic PA_BUILD_SHARED)
string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} static PA_BUILD_STATIC)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    asio PA_USE_ASIO
    jack PA_USE_JACK
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DPA_USE_DS=ON
        -DPA_USE_WASAPI=ON
        -DPA_USE_WDMKS=ON
        -DPA_USE_WMME=ON
        -DPA_LIBNAME_ADD_SUFFIX=OFF
        -DPA_BUILD_SHARED=${PA_BUILD_SHARED}
        -DPA_BUILD_STATIC=${PA_BUILD_STATIC}
        -DPA_DLL_LINK_WITH_STATIC_RUNTIME=OFF
    OPTIONS_DEBUG
        -DPA_ENABLE_DEBUG_OUTPUT:BOOL=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/${PORT}")
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")
