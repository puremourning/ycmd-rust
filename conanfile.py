from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout
from conan.tools import files
from conans import tools

class YcmdConan(ConanFile):
  name = "ycmd"
  version = "2.0.0"

  # Optional metadata
  license = "Apache 2.0"
  author = "Ben Jackson puremourning+ycmd@gmail.com"
  url = "https://github.com/ycm-core/ycmd"
  description = "A code comprehension server"

  # Binary configuration
  settings = "os", "compiler", "build_type", "arch"

  # Sources are located in the same place as this recipe, copy them to the
  # recipe
  exports_sources = "CMakeLists.txt", "src/*"

  # Requirements
  requires = (
    "ConanCargoWrapper/0.1@puremourning/testing",
    "abseil/20220623.0",
  )

  generators = ( 'ConanCargoWrapper' )

  def validate(self):
    tools.check_min_cppstd(self, "20")

  def layout(self):
    cmake_layout(self)

  def generate(self):
    CMakeToolchain(self).generate()
    CMakeDeps(self).generate()

  def build(self):
    import os

    # Move the generated cargo build paths where we need them.
    src = os.path.join(self.folders.source_folder,
                       'conan_cargo_build.rs')
    dst = os.path.join(self.folders.source_folder,
                       'ycmd',
                       'conan_cargo_build.rs')
    try:
      os.remove(dst)
    except FileNotFoundError:
      pass

    files.rename(self, src, dst)

    cmake = CMake(self)
    cmake.configure()
    cmake.build()
