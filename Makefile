DEPS=.build-deps
TARGET=Debug

CARGO_FLAGS_Debug=
CARGO_FLAGS_Release=--release

.PHONY: all clean distclean test

PROFILE=default

all: build/${TARGET}
	${DEPS}/bin/cmake --build build/${TARGET} --parallel
	${DEPS}/bin/compdb -p build/${TARGET} list > compile_commands.json
	cargo build ${CARGO_FLAGS_${TARGET}}

build/${TARGET}: ${DEPS} conanfile.py
	${DEPS}/bin/conan install --profile=${PROFILE} -s compiler.cppstd=20 -s build_type=${TARGET} . --build missing
	${DEPS}/bin/conan build .

${DEPS}: dev_requirements.txt
	python3 -m venv ${DEPS}
	${DEPS}/bin/pip3 install -r dev_requirements.txt

distclean:
	rm -rf ${DEPS}
	rm -rf build
	rm -rf target
	rm -f Cargo.lock \
              conan.lock \
	      conan_cargo_build.rs \
	      conaninfo.txt \
	      graph_info.json \
	      compile_commands.json \
	      CmakeUserPresets.json

clean:
	${MAKE} -C build/${TARGET} clean
	cargo clean

test: all
	${MAKE} -C build/${TARGET} test

