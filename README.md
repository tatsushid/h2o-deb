H2O Unofficial Debian package builder
=====================================

This provides [H2O](https://h2o.examp1e.net/) `debian` directory and required
files e.g. SysVinit, systemd service etc. to build Debian package for Debian
and Ubuntu.

If you search RPM package, please see [h2o-rpm](https://github.com/tatsushid/h2o-rpm)

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
dpkg -i h2o_2.0.1-1_amd64.deb
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
