use std::env;
mod conan_cargo_build;

fn main() -> miette::Result<()> {
  let mut include_paths = vec![ "../core" ];
  include_paths.extend( conan_cargo_build::INCLUDE_PATHS );

  autocxx_build::Builder::new( "src/main.rs", include_paths )
    .extra_clang_args( &[ "-DYCM_EXPORT=", "-std=c++20" ] )
    .build()?
    .flag_if_supported( "-std=c++20" )
    .compile("ycmd-core"); // arbitrary library name, pick anything

  println!("cargo:rerun-if-changed=src/main.rs");

  // Add instructions to link to any C++ libraries you need.
  println!("cargo:rustc-link-search={}/../core", env::var("CARGO_TARGET_DIR").unwrap_or(String::from("")));
  println!("cargo:rustc-link-lib=static=YcmCore");
  conan_cargo_build::main();

  Ok(())
}

