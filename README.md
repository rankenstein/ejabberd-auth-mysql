Description
===========

This is an external authentication script for [ejabberd](https://www.ejabberd.im/). It supports defining a custom database layout, custom password hashing methods, and all methods such as registering, unregistering and changing password.

Usage
=====

Make sure that you have Python 2 installed and that `/usr/bin/python` points to it (check by running `/usr/bin/python --version`, make sure that it says `Python 2.x.x` instead of `Python 3.x.x`).

Configure ejabberd to use `auth_mysql.py` from this repository as an external authentication provider, as described in the [ejabberd docs](http://docs.ejabberd.im/admin/guide/configuration/#external-script):

```yaml
auth_method: external
extauth_program: "/path/to/auth_mysql.py"

# Alternative: Configuration for an individual host
host_config:
    "example.org":
        auth_method: [external]
        extauth_program: "/path/to/auth_mysql.py"
```

Set the environment variables described in the following section or edit them directly within the script.

Environment variables
---------------------

- **AUTH_MYSQL_HOST**: The MySQL host
- **AUTH_MYSQL_USER**: Username to connect to the MySQL host
- **AUTH_MYSQL_PASSWORD**: Password to connect to the MySQL host
- **AUTH_MYSQL_DATABASE**: Database name where to find the user information
- **AUTH_MYSQL_HASHALG**: Format of the password in the database. Default is cleartext. Options are `crypt`, `md5`, `sha1`, `sha224`, `sha256`, `sha384`, `sha512`. `crypt` is recommended, as it is salted. When setting the password, `crypt` uses SHA-512 (prefix `$6$`).
- **AUTH_MYSQL_QUERY_GETPASS**: Get the password for a user. Use the placeholders `%(user)s`, `%(host)s`. Example: `SELECT password FROM users WHERE username = CONCAT(%(user)s, '@', %(host)s)`
- **AUTH_MYSQL_QUERY_SETPASS**: Update the password for a user. Leave empty to disable. Placeholder `%(password)s` contains the hashed password. Example: `UPDATE users SET password = %(password)s WHERE username = CONCAT(%(user)s, '@', %(host)s)`
- **AUTH_MYSQL_QUERY_REGISTER**: Register a new user. Leave empty to disable. Example: `INSERT INTO users ( username, password ) VALUES ( CONCAT(%(user)s, '@', %(host)s), %(password)s )`
- **AUTH_MYSQL_QUERY_UNREGISTER**: Removes a user. Leave empty to disable. Example: `DELETE FROM users WHERE username = CONCAT(%(user)s, '@', %(host)s)`

Debugging
=========

`auth_mysql.py` creates a debug log in `/var/log/ejabberd/extauth_err.log`.

The format of the input and output that the script accepts is described in the [ejabberd developer docs](https://www.ejabberd.im/files/doc/dev.html#htoc9). As it uses binary numbers, it can be difficult to test the script by hand. Use the `test.sh` script instead:

```bash
user@linux ~ $ AUTH_MYSQL_HOST=localhost AUTH_MYSQL_USER=jabber AUTH_...=... ./test.sh
is:test:example.com
1
auth:test:example.com:password
0
```