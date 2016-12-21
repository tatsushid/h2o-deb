H2O Unofficial Debian package builder
=====================================

[![Build Status](https://travis-ci.org/tatsushid/h2o-deb.svg?branch=master)](https://travis-ci.org/tatsushid/h2o-deb)

This provides [H2O](https://h2o.examp1e.net/) `debian` directory and required
files e.g. SysVinit, systemd service etc. to build Debian package for Debian
and Ubuntu.

If you search RPM package, please see [h2o-rpm](https://github.com/tatsushid/h2o-rpm)

## How to use prebuilt Debian package

This has [Bintray Debian package repository](https://bintray.com/tatsushid/h2o-deb)
so if you'd like to just install such a prebuilt package, please do following.

```bash
# Add GPG key
curl -SL 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | sudo apt-key add -

# If your system is Debian jessie (8.x)
echo "deb http://dl.bintray.com/tatsushid/h2o-deb jessie-backports main" | sudo tee /etc/apt/sources.list.d/bintray-tatsushid-h2o.list

# If your system is Ubuntu trusty (14.04)
echo "deb http://dl.bintray.com/tatsushid/h2o-deb trusty-backports main" | sudo tee /etc/apt/sources.list.d/bintray-tatsushid-h2o.list

# If your system is Ubuntu xenial (16.04)
echo "deb http://dl.bintray.com/tatsushid/h2o-deb xenial-backports main" | sudo tee /etc/apt/sources.list.d/bintray-tatsushid-h2o.list
```

Once it has done, you can install packages in the repository by

```bash
sudo apt-get update
sudo apt-get install h2o
```

## How to build Debian package

If you have a docker environment, you can build Debian packages by just running

```bash
make
```

If you'd like to build Debian package for specific distribution, please run a
command like following

```bash
make debian8
```

Now this understands

- debian8
- ubuntu1404
- ubuntu1604

build options.

To build Debian package in your server without docker, please copy files under
[`src/debian`](https://github.com/tatsushid/h2o-deb/blob/master/src/debian) to
your build system

## Installing Debian package

After building, please copy Debian package under `*.build` directory to your
system and run

```bash
dpkg -i h2o_2.0.5-1_amd64.deb
```

Once the installation finishes successfully, you can see a configuration file
at `/etc/h2o/h2o.conf`.

To start h2o, please run

```bash
systemctl enable h2o.service
systemctl start h2o.service
```

## License

This is under MIT License. Please see the
[LICENSE](https://github.com/tatsushid/h2o-rpm/blob/master/LICENSE) file for
details.
