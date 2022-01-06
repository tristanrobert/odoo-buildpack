#!/usr/bin/env python3
import argparse
from passlib.context import CryptContext
import psycopg2
import sys


if __name__ == '__main__':

    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--admin_pwd', required=True)
    arg_parser.add_argument('--db_host', required=True)
    arg_parser.add_argument('--db_port', required=True)
    arg_parser.add_argument('--db_user', required=True)
    arg_parser.add_argument('--db_password', required=True)
    arg_parser.add_argument('--database', required=True)
    args = arg_parser.parse_args()
    setpw = CryptContext(schemes=['pbkdf2_sha512'])
    encrypted_pwd = setpw.hash(args.admin_pwd)
    try:
        conn = psycopg2.connect(user=args.db_user, host=args.db_host, port=args.db_port, password=args.db_password, dbname=args.database)
        error = ''
        cur = conn.cursor()
        cur.execute("UPDATE res_users SET password=%s WHERE id=2;", (encrypted_pwd,))
        conn.commit()
        print("Admin password successfully updated")
    except psycopg2.OperationalError as e:
        error = e
    else:
        cur.close()
        conn.close()

if error:
    print("Admin password update failure: %s" % error, file=sys.stderr)
    sys.exit(1)