FROM debian:9
ENV DEBEMAIL="tdemachi@gmail.com" DEBFULLNAME="Tatsushi Demachi"
ARG PKGVER
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bison \
        build-essential \
        cmake \
        curl \
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
        liburi-perl \
        libuv1-dev \
        netcat \
        pkg-config \
        ruby \
        ruby-dev \
        starlet \
        sudo \
        zlib1g-dev
RUN useradd -ms /bin/bash builder \
    && echo "builder ALL=NOPASSWD: ALL" > /etc/sudoers.d/builder \
    && chmod 440 /etc/sudoers.d/builder
ENV HOME=/home/builder
USER builder
COPY src/v${PKGVER}.tar.gz $HOME/
RUN mkdir -p $HOME/h2o/h2o-${PKGVER} \
    && cd $HOME/h2o/h2o-${PKGVER} \
    && tar xzf $HOME/v${PKGVER}.tar.gz --strip-components=1 \
    && tar cJf ../h2o_${PKGVER}.orig.tar.xz .
ADD src/debian/ $HOME/h2o/h2o-${PKGVER}/debian/
RUN cd $HOME/h2o/h2o-${PKGVER} \
    && sudo chown -R builder:builder debian \
    && mv -f debian/changelog.debian9 debian/changelog \
    && rm -f debian/changelog.*
RUN cd $HOME/h2o/h2o-${PKGVER} \
    && dpkg-buildpackage -us -uc \
    && tar -czf /tmp/h2o.tar.gz -C $HOME/h2o --exclude=./h2o-${PKGVER} .
CMD ["/bin/true"]
