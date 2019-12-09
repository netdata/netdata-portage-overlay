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
	bind_rndc
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
	example
	exim
	fail2ban
	freeradius
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
	spigotmc
	springboot
	squid
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
	IUSE="${IUSE} netdata_collectors_${collector}"
done

REQUIRED_USE="
	cups? ( netdata_collectors_cups )
	ipmi? ( netdata_collectors_ipmi )
	mysql? ( netdata_collectors_mysql )
	nfacct? ( netdata_collectors_nfacct )
	postgres? ( netdata_collectors_postgres )
	tor? ( netdata_collectors_tor )
	xen? ( netdata_collectors_xen )
	netdata_collectors_adaptec_raid? ( python )
	netdata_collectors_am2320? ( python )
	netdata_collectors_apache? ( python )
	netdata_collectors_beanstalk? ( python )
	netdata_collectors_bind_rndc? ( python )
	netdata_collectors_boinc? ( python )
	netdata_collectors_ceph? ( python )
	netdata_collectors_chrony? ( python )
	netdata_collectors_couchdb? ( python )
	netdata_collectors_dnsdist? ( python )
	netdata_collectors_dns_query_time? ( python )
	netdata_collectors_dockerd? ( python )
	netdata_collectors_dovecot? ( python )
	netdata_collectors_elasticsearch? ( python )
	netdata_collectors_energid? ( python )
	netdata_collectors_example? ( python )
	netdata_collectors_exim? ( python )
	netdata_collectors_fail2ban? ( python )
	netdata_collectors_freeradius? ( python )
	netdata_collectors_gearman? ( python )
	netdata_collectors_go_expvar? ( python )
	netdata_collectors_haproxy? ( python )
	netdata_collectors_hddtemp? ( python )
	netdata_collectors_hpssa? ( python )
	netdata_collectors_httpcheck? ( python )
	netdata_collectors_icecast? ( python )
	netdata_collectors_ipfs? ( python )
	netdata_collectors_isc_dhcpd? ( python )
	netdata_collectors_litespeed? ( python )
	netdata_collectors_logind? ( python )
	netdata_collectors_megacli? ( python )
	netdata_collectors_memcached? ( python )
	netdata_collectors_mongodb? ( python )
	netdata_collectors_monit? ( python )
	netdata_collectors_mysql? ( python )
	netdata_collectors_nginx? ( python )
	netdata_collectors_nginx_plus? ( python )
	netdata_collectors_nsd? ( python )
	netdata_collectors_ntpd? ( python )
	netdata_collectors_nvidia_smi? ( python )
	netdata_collectors_openldap? ( python )
	netdata_collectors_oracledb? ( python )
	netdata_collectors_ovpn_status_log? ( python )
	netdata_collectors_phpfpm? ( python )
	netdata_collectors_portcheck? ( python )
	netdata_collectors_postfix? ( python )
	netdata_collectors_postgres? ( python )
	netdata_collectors_powerdns? ( python )
	netdata_collectors_proxysql? ( python )
	netdata_collectors_puppet? ( python )
	netdata_collectors_rabbitmq? ( python )
	netdata_collectors_redis? ( python )
	netdata_collectors_rethinkdbs? ( python )
	netdata_collectors_retroshare? ( python )
	netdata_collectors_riakkv? ( python )
	netdata_collectors_samba? ( python )
	netdata_collectors_sensors? ( python )
	netdata_collectors_smartd_log? ( python )
	netdata_collectors_spigotmc? ( python )
	netdata_collectors_springboot? ( python )
	netdata_collectors_squid? ( python )
	netdata_collectors_tomcat? ( python )
	netdata_collectors_tor? ( python )
	netdata_collectors_traefik? ( python )
	netdata_collectors_unbound? ( python )
	netdata_collectors_uwsgi? ( python )
	netdata_collectors_varnish? ( python )
	netdata_collectors_w1sensor? ( python )
	netdata_collectors_web_log? ( python )
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
	net-analyzer/tcpdump
	net-analyzer/traceroute
	net-misc/curl
	net-misc/wget
	sys-apps/util-linux
	virtual/awk
	caps? ( sys-libs/libcap )
	netdata_collectors_cups? ( net-print/cups )
	dbengine? (
		app-arch/lz4
		dev-libs/judy
	)
	compression? ( sys-libs/zlib )
	netdata_collectors_ipmi? ( sys-libs/freeipmi )
	netdata_collectors_nfacct? (
		net-firewall/nfacct
		net-libs/libmnl
	)
	nodejs? ( net-libs/nodejs )
	python? (
		${PYTHON_DEPS}
		dev-python/pyyaml[${PYTHON_USEDEP}]
		netdata_collectors_mysql? (
			|| (
				dev-python/mysqlclient[${PYTHON_USEDEP}]
				dev-python/mysql-python[${PYTHON_USEDEP}]
			)
		)
		netdata_collectors_postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		netdata_collectors_tor? ( net-libs/stem[${PYTHON_USEDEP}] )
	)
	ssl? (
		dev-libs/openssl:=
	)
	sudo? (
		app-admin/sudo
	)
	netdata_collectors_xen? (
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
		$(use_enable netdata_collectors_cups plugin-cups) \
		$(use_enable netdata_collectors_nfacct plugin-nfacct) \
		$(use_enable netdata_collectors_ipmi plugin-freeipmi) \
		$(use_enable netdata_collectors_xen plugin-xenstat) \
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
