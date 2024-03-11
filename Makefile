default: submodules install-pkgs

install-pkgs:

rebuild-cmake:
	rm -rf build
	mkdir -p build
	cd build && cmake ..

submodules:
	git submodule update --init --recursive

generate:
	./tools/make-pngs.sh

test:
