FROM ubuntu:14.04
ENV DEBEMAIL="tdemachi@gmail.com" DEBFULLNAME="Tatsushi Demachi"
ARG PKGVER
ENV PATH_TINY_PERL=libpath-tiny-perl_0.100-1_all.deb
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        automake \
        bison \
        build-essential \
        cmake \
        curl \
        dh-autoreconf \
        dh-exec \
        dh-make \
        dh-systemd \
        fakeroot \
        git \
        libio-socket-ssl-perl \
        libjson-perl \
        libpath-tiny-perl \
        libplack-perl \
        libscope-guard-perl \
        libssl-dev \
        libtest-exception-perl \
        libtest-tcp-perl \
        libtool \
        liburi-perl \
        netcat \
        pkg-config \
        ruby \
        ruby-dev \
        starlet \
        sudo \
    && : install newer Path::Tiny Perl module to avoid a test error \
    && cd /tmp \
    && curl -SLO "http://archive.ubuntu.com/ubuntu/pool/main/libp/libpath-tiny-perl/$PATH_TINY_PERL" \
    && dpkg -i "$PATH_TINY_PERL"
RUN useradd -ms /bin/bash builder \
    && echo "builder ALL=NOPASSWD: ALL" > /etc/sudoers.d/builder \
    && chmod 440 /etc/sudoers.d/builder
ENV HOME=/home/builder
USER builder
ADD ./deps $HOME/deps
RUN sudo chown -R builder:builder $HOME/deps \
    && cd $HOME/deps \
    && LIBUV_VERSION="$(ls libuv1_*.orig.tar.gz | sed -e 's/libuv1_\(.*\)\.orig\.tar\.gz/\1/' | sort -r | head -n1)" \
    && dpkg-source -x libuv1_${LIBUV_VERSION}*.dsc \
    && cd libuv1-${LIBUV_VERSION} \
    && dpkg-buildpackage -us -uc \
    && sudo dpkg -i ../libuv1-dev_${LIBUV_VERSION}*.deb ../libuv1_${LIBUV_VERSION}*.deb
COPY src/v${PKGVER}.tar.gz $HOME/
RUN mkdir -p $HOME/h2o/h2o-${PKGVER} \
    && cd $HOME/h2o/h2o-${PKGVER} \
    && tar xzf $HOME/v${PKGVER}.tar.gz --strip-components=1 \
    && tar cJf ../h2o_${PKGVER}.orig.tar.xz .
ADD src/debian/ $HOME/h2o/h2o-${PKGVER}/debian/
RUN cd $HOME/h2o/h2o-${PKGVER} \
    && sudo chown -R builder:builder debian \
    && mv -f debian/changelog.ubuntu1404 debian/changelog \
    && rm -f debian/changelog.*
RUN cd $HOME/h2o/h2o-${PKGVER} \
    && sed -i -e '/h2o_ssl_register_alpn_protocols/d' debian/libh2o0.symbols \
    && sed -i -e '/h2o_ssl_register_alpn_protocols/d' debian/libh2o-evloop0.symbols
RUN cd $HOME/h2o/h2o-${PKGVER} \
    && dpkg-buildpackage -us -uc \
    && tar -czf /tmp/h2o.tar.gz -C $HOME/h2o --exclude=./h2o-${PKGVER} .
CMD ["/bin/true"]
