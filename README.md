# odoo-buildpack

Odoo buildpack

## Usage

Simply deploy by cliking on this button:

[![Deploy to Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/MTES-MCT/odoo-buildpack#main)

Or create an app. You must have an add-on database `postgresql`.
[Add this buildpack environment variable][1] to your Scalingo application to install the Nocodb server:

```shell
BUILDPACK_URL=https://github.com/MTES-MCT/odoo-buildpack#main
```

And other environment variables are set by example in a `.env.sample` file.

`PORT` and `SCALINGO_POSTGRESQL_URL` are provided by Scalingo.

By default the buildpack install the latest release.

All other environment variables are specific to odoo-bin, see [documentation](https://www.odoo.com/documentation/15.0/developer/misc/other/cmdline.html).

In order to reset admin password randomly generated at db init, you can execute this command:

```shell
/app/bin/init-admin-pwd.py --database odoo --db_host postgres --db_port 5432 --db_user odoo --db_password <database password> --admin_pwd <new admin password>
```

## Hacking

You set environment variables in `.env`:

```shell
cp .env.sample .env
```

Run an interactive docker scalingo stack:

```shell
docker run --name odoo -it -p 8080:8080 -v "$(pwd)"/.env:/env/.env -v "$(pwd)":/buildpack scalingo/scalingo-20:latest bash
```

And test in it:

```shell
bash buildpack/bin/detect
bash buildpack/bin/env.sh /env/.env /env
bash buildpack/bin/compile /build /cache /env
bash buildpack/bin/release
```

Run Odoo server:

```shell
export PATH=/build/bin:$PATH
/build/bin/run
```

Check [http://localhost:8080](http://localhost:8080).

You can also use docker-compose in order to test with a complete stack (db):

```shell
docker-compose up --build -d
docker-compos down -v
```

`.env.sample` is configured to work with this stack.

[1]: https://doc.scalingo.com/platform/deployment/buildpacks/custom

