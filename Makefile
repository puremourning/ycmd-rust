DEPS=.build-deps
TARGET=Debug

CARGO_FLAGS_Debug=
CARGO_FLAGS_Release=--release

.PHONY: all clean distclean test

PROFILE=default

all: build/${TARGET}
	${DEPS}/bin/cmake --build build/${TARGET} --parallel
	${DEPS}/bin/compdb -p build/${TARGET} list > compile_commands.json

build/${TARGET}: ${DEPS} generator conanfile.py
	${DEPS}/bin/conan install --profile=${PROFILE} -s compiler.cppstd=20 -s build_type=${TARGET} . --build missing
	${DEPS}/bin/conan build .

generator: vendor/conan-cargo-wrapper-generator/conanfile.py
	cd vendor/conan-cargo-wrapper-generator && conan export . puremourning/testing

${DEPS}: dev_requirements.txt
	python3 -m venv ${DEPS}
	${DEPS}/bin/pip3 install -r dev_requirements.txt

distclean:
	rm -rf ${DEPS}
	rm -rf build
	rm -rf target
	rm -f Cargo.lock \
              conan.lock \
	      ycmd/conan_cargo_build.rs \
	      conaninfo.txt \
	      conanbuildinfo.txt \
	      graph_info.json \
	      compile_commands.json \
	      CmakeUserPresets.json

clean:
	${MAKE} -C build/${TARGET} clean

test: all
	${MAKE} -C build/${TARGET} test

