DEPS=.build-deps
TARGET=Debug

.PHONY: all clean distclean test

PROFILE=default

all: ${TARGET}
	${DEPS}/bin/cmake --build build/${TARGET} --parallel
	${DEPS}/bin/compdb -p build/${TARGET} list > compile_commands.json
	cargo build

${TARGET}: ${DEPS} conanfile.txt
	${DEPS}/bin/conan install --profile=${PROFILE} -s compiler.cppstd=20 -s build_type=Debug . --build missing
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

