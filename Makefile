PKGVER := 2.0.3
SOURCE_ARCHIVE := v$(PKGVER).tar.gz
TARGZ_FILE := h2o.tar.gz
IMAGE_NAME := h2o-package
debian8: IMAGE_NAME := $(IMAGE_NAME)-deb8
ubuntu1404: IMAGE_NAME := $(IMAGE_NAME)-ub1404
ubuntu1604: IMAGE_NAME := $(IMAGE_NAME)-ub1604

LIBUV_NAME := libuv1_1.9.1
LIBUV_RELEASE := 1
LIBUV_DSC := $(LIBUV_NAME)-$(LIBUV_RELEASE).dsc
LIBUV_ORIG := $(LIBUV_NAME).orig.tar.gz
LIBUV_DEBIAN := $(LIBUV_NAME)-$(LIBUV_RELEASE).debian.tar.xz

.PHONY: all clean debian8 ubuntu1404 ubuntu1604

all: debian8 ubuntu1404 ubuntu1604
debian8: debian8.build
ubuntu1404: ubuntu1404.build
ubuntu1604: ubuntu1604.build

src/$(SOURCE_ARCHIVE):
	curl -SL https://github.com/h2o/h2o/archive/$(SOURCE_ARCHIVE) -o src/$(SOURCE_ARCHIVE)

deps/$(LIBUV_DSC):
	[ -d deps ] || mkdir deps
	cd deps && curl -SLO http://http.debian.net/debian/pool/main/libu/libuv1/$(LIBUV_DSC)

deps/$(LIBUV_ORIG):
	[ -d deps ] || mkdir deps
	cd deps && curl -SLO http://http.debian.net/debian/pool/main/libu/libuv1/$(LIBUV_ORIG)

deps/$(LIBUV_DEBIAN):
	[ -d deps ] || mkdir deps
	cd deps && curl -SLO http://http.debian.net/debian/pool/main/libu/libuv1/$(LIBUV_DEBIAN)

%.build: src/debian/* src/$(SOURCE_ARCHIVE) deps/$(LIBUV_DSC) deps/$(LIBUV_ORIG) deps/$(LIBUV_DEBIAN)
	[ -d $@.bak ] && rm -rf $@.bak || :
	[ -d $@ ] && mv $@ $@.bak || :
	cp Dockerfile.$* Dockerfile
	tar -czf - Dockerfile src deps | docker build -t $(IMAGE_NAME) --build-arg PKGVER=$(PKGVER) -
	docker run --name $(IMAGE_NAME)-tmp $(IMAGE_NAME)
	mkdir -p tmp
	docker wait $(IMAGE_NAME)-tmp
	docker cp $(IMAGE_NAME)-tmp:/tmp/$(TARGZ_FILE) tmp
	docker rm $(IMAGE_NAME)-tmp
	mkdir $@
	tar -xzf tmp/$(TARGZ_FILE) -C $@
	rm -rf tmp Dockerfile
	docker images | grep -q $(IMAGE_NAME) && docker rmi $(IMAGE_NAME) || true

bintray:
	./scripts/build_bintray_json.bash \
		h2o \
		h2o-doc \
		h2o-dbg \
		libh2o0 \
		libh2o-evloop0 \
		libh2o-dev-common \
		libh2o-dev \
		libh2o-evloop-dev

work: src/$(SOURCE_ARCHIVE)
	mkdir -p work
	tar -xzf src/$(SOURCE_ARCHIVE) -C work --strip-components=1
	cp -pr src/debian work/debian
	cd work && QUILT_PATCHES="debian/patches" quilt setup debian/patches/series

clean:
	rm -rf *.build.bak *.build deps tmp bintray work Dockerfile
	docker images | grep -q $(IMAGE_NAME)-deb8 && docker rmi $(IMAGE_NAME)-deb8 || true
	docker images | grep -q $(IMAGE_NAME)-ub1404 && docker rmi $(IMAGE_NAME)-ub1404 || true
	docker images | grep -q $(IMAGE_NAME)-ub1604 && docker rmi $(IMAGE_NAME)-ub1604 || true
