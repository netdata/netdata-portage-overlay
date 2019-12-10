# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )

inherit autotools fcaps linux-info python-r1 systemd user

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/netdata/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/netdata/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Linux real time system monitoring, done right!"
HOMEPAGE="https://github.com/netdata/netdata https://my-netdata.io/"
LICENSE="GPL-3+ MIT BSD"
SLOT="0"

IUSE="caps +compression cpu_flags_x86_sse2 cups dbengine ipmi mysql nfacct nodejs postgres +python ssl sudo tor xen"

COLLECTORS="
	adaptec_raid
	am2320
	apache
	beanstalk
	bind
	boinc
	ceph
	chrony
	couchdb
	cups
	dnsdist
	dns_query_time
	dockerd
	dovecot
	elasticsearch
	energid
	exim
	fail2ban
	freeradius
	fronius
	gearman
	go_expvar
	haproxy
	hddtemp
	hpssa
	httpcheck
	icecast
	ipfs
	ipmi
	isc_dhcpd
	litespeed
	logind
	megacli
	memcached
	mongodb
	monit
	mysql
	nfacct
	nginx
	nginx_plus
	nsd
	ntpd
	nvidia_smi
	openldap
	oracledb
	ovpn_status_log
	phpfpm
	portcheck
	postfix
	postgres
	powerdns
	proxysql
	puppet
	rabbitmq
	redis
	rethinkdbs
	retroshare
	riakkv
	samba
	sensors
	smartd_log
	sma_webbox
	snmp
	spigotmc
	springboot
	squid
	stiebeleltron
	tomcat
	tor
	traefik
	unbound
	uwsgi
	varnish
	w1sensor
	web_log
	xen
"

for collector in ${COLLECTORS} ; do
	IUSE="${IUSE} collectors-${collector}"
done

REQUIRED_USE="
	cups? ( collectors-cups )
	ipmi? ( collectors-ipmi )
	mysql? ( collectors-mysql )
	nfacct? ( collectors-nfacct )
	postgres? ( collectors-postgres )
	tor? ( collectors-tor )
	xen? ( collectors-xen )
	collectors-adaptec_raid? (
		python
		sudo
	)
	collectors-am2320? ( python )
	collectors-apache? ( python )
	collectors-beanstalk? ( python )
	collectors-bind? (
		|| (
			python
			nodejs
		)
	)
	collectors-boinc? ( python )
	collectors-ceph? ( python )
	collectors-chrony? ( python )
	collectors-couchdb? ( python )
	collectors-dnsdist? ( python )
	collectors-dns_query_time? ( python )
	collectors-dockerd? ( python )
	collectors-dovecot? ( python )
	collectors-elasticsearch? ( python )
	collectors-energid? ( python )
	collectors-exim? ( python )
	collectors-fail2ban? ( python )
	collectors-freeradius? ( python )
	collectors-fronius? ( nodejs )
	collectors-gearman? ( python )
	collectors-go_expvar? ( python )
	collectors-haproxy? ( python )
	collectors-hddtemp? ( python )
	collectors-hpssa? (
		python
		sudo
	)
	collectors-httpcheck? ( python )
	collectors-icecast? ( python )
	collectors-ipfs? ( python )
	collectors-isc_dhcpd? ( python )
	collectors-litespeed? ( python )
	collectors-logind? ( python )
	collectors-megacli? (
		python
		sudo
	)
	collectors-memcached? ( python )
	collectors-mongodb? ( python )
	collectors-monit? ( python )
	collectors-mysql? ( python )
	collectors-nginx? ( python )
	collectors-nginx_plus? ( python )
	collectors-nsd? ( python )
	collectors-ntpd? ( python )
	collectors-nvidia_smi? ( python )
	collectors-openldap? ( python )
	collectors-oracledb? ( python )
	collectors-ovpn_status_log? ( python )
	collectors-phpfpm? ( python )
	collectors-portcheck? ( python )
	collectors-postfix? ( python )
	collectors-postgres? ( python )
	collectors-powerdns? ( python )
	collectors-proxysql? ( python )
	collectors-puppet? ( python )
	collectors-rabbitmq? ( python )
	collectors-redis? ( python )
	collectors-rethinkdbs? ( python )
	collectors-retroshare? ( python )
	collectors-riakkv? ( python )
	collectors-samba? (
		python
		sudo
	)
	collectors-sensors? ( python )
	collectors-sma_webbox? ( nodejs )
	collectors-smartd_log? ( python )
	collectors-snmp? ( nodejs )
	collectors-spigotmc? ( python )
	collectors-springboot? ( python )
	collectors-squid? ( python )
	collectors-stiebeleltron? ( nodejs )
	collectors-tomcat? ( python )
	collectors-tor? ( python )
	collectors-traefik? ( python )
	collectors-unbound? ( python )
	collectors-uwsgi? ( python )
	collectors-varnish? ( python )
	collectors-w1sensor? ( python )
	collectors-web_log? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	dbengine? ( ssl )"

# most unconditional dependencies are for plugins.d/charts.d.plugin:
RDEPEND="
	acct-user/netdata
	acct-group/netdata
	app-misc/jq
	dev-libs/libuv
	>=app-shells/bash-4:0
	|| (
		net-analyzer/openbsd-netcat
		net-analyzer/netcat
	)
	net-misc/curl
	net-misc/wget
	sys-apps/util-linux
	virtual/awk
	caps? ( sys-libs/libcap )
	collectors-cups? ( net-print/cups )
	dbengine? (
		app-arch/lz4
		dev-libs/judy
	)
	compression? ( sys-libs/zlib )
	collectors-ipmi? ( sys-libs/freeipmi )
	collectors-nfacct? (
		net-firewall/nfacct
		net-libs/libmnl
	)
	nodejs? ( net-libs/nodejs )
	python? (
		${PYTHON_DEPS}
		dev-python/pyyaml[${PYTHON_USEDEP}]
		collectors-adaptec_raid? ( sys-block/arcconf )
		collectors-beanstalk? ( dev-python/beanstalkc[${PYTHON_USEDEP}] )
		collectors-dns_query_time? ( dev-python/dnspython[${PYTHON_USEDEP}] )
		collectors-hpssa? ( sys-block/hpssacli )
		collectors-isc_dhcpd? ( virtual/python-ipaddress[${PYTHON_USEDEP}] )
		collectors-megacli? ( sys-block/megacli )
		collectors-mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
		collectors-mysql? (
			|| (
				dev-python/mysqlclient[${PYTHON_USEDEP}]
				dev-python/mysql-python[${PYTHON_USEDEP}]
			)
		)
		collectors-openldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
		collectors-postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		collectors-tor? ( net-libs/stem[${PYTHON_USEDEP}] )
	)
	ssl? (
		dev-libs/openssl:=
	)
	sudo? (
		app-admin/sudo
	)
	collectors-xen? (
		app-emulation/xen-tools
		dev-libs/yajl
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

: ${NETDATA_USER:=netdata}
: ${NETDATA_GROUP:=netdata}

FILECAPS=(
	'cap_dac_read_search,cap_sys_ptrace+ep' 'usr/libexec/netdata/plugins.d/apps.plugin'
)

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--with-user=${NETDATA_USER} \
		--disable-jsonc \
		$(use_enable dbengine) \
		$(use_enable ssl https) \
		$(use_enable collectors-cups plugin-cups) \
		$(use_enable collectors-nfacct plugin-nfacct) \
		$(use_enable collectors-ipmi plugin-freeipmi) \
		$(use_enable collectors-xen plugin-xenstat) \
		$(use_enable cpu_flags_x86_sse2 x86-sse) \
		$(use_with compression zlib)
}

src_install() {
	default

	rm -rf "${D}/var/cache" || die

	# Remove unneeded .keep files
	find "${ED}" -name ".keep" -delete || die

	fowners -Rc ${NETDATA_USER}:${NETDATA_GROUP} /var/log/netdata
	keepdir /var/log/netdata
	fowners -Rc ${NETDATA_USER}:${NETDATA_GROUP} /var/lib/netdata
	keepdir /var/lib/netdata
	keepdir /var/lib/netdata/registry

	fowners -Rc root:${NETDATA_GROUP} /usr/share/${PN}

	newinitd system/netdata-openrc ${PN}
	systemd_dounit system/netdata.service
	insinto /etc/netdata
	doins system/netdata.conf

	echo "CONFIG_PROTECT=\"${EPREFIX}/usr/$(get_libdir)/netdata/conf.d\"" > 99netdata
	doenvd 99netdata
}
