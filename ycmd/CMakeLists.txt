if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CARGO_CMD cargo build)
    set(TARGET_DIR "debug")
else ()
    set(CARGO_CMD cargo build --release)
    set(TARGET_DIR "release")
endif ()

add_custom_target( ycmd-rust ALL
  DEPENDS YcmCore
  COMMAND CARGO_TARGET_DIR=${CMAKE_BINARY_DIR}/target RUSTFLAGS="${RUST_FLAGS}" ${CARGO_CMD}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
