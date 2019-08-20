# Copyright 2019 Netdata Inc
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=201
ACCT_USER_HOME=/var/lib/netdata
ACCT_USER_HOME_OWNER=netdata:netdata
ACCT_USER_HOME_PERMS=00750
ACCT_USER_GROUPS=( netdata )

acct-user_add_deps
