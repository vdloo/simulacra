class kodi {
    include install_kodi
}

class clean_before_bootstrap_kodi {
    require refresh_kodi_repo
    require kodi_dependencies
    require kodi_bundled_dependencies
    exec { 'clean kodi repo before bootstrapping':
	command => "/usr/bin/git clean -xfd",
	cwd => "/usr/local/kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
}

class bootstrap_kodi {
    require refresh_kodi_repo
    require kodi_dependencies
    require kodi_bundled_dependencies
    require clean_before_bootstrap_kodi
    exec { 'bootstrap kodi':
	command => "/usr/local/kodi/bootstrap",
	cwd => "/usr/local/kodi/",
        user => $::nonroot_username,
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
}

class configure_kodi {
    require bootstrap_kodi
    exec { 'configure kodi':
	command => "/usr/local/kodi/configure --disable-libcec --disable-dvdcss --disable-joystick --disable-libbluray --disable-nfs",
	cwd => "/usr/local/kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi',
        environment => ['PYTHON_VERSION=2', 'PKG_CONFIG_PATH=/usr/local/x86_64-linux-gnu/lib/pkgconfig/', 'CFLAGS=-I/usr/local/x86_64-linux-gnu/include', 'CXXFLAGS=-I/usr/local/x86_64-linux-gnu/include', "LDFLAGS=-L/usr/local/x86_64-linux-gnu/lib -lcrossguid"],
	timeout     => 0
    }
}

class build_kodi {
    require configure_kodi
    exec { 'build kodi':
	command => "/usr/bin/make -j $processorcount",
	cwd => "/usr/local/kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi',
	timeout     => 0
    }
}

class install_kodi {
    require build_kodi
    exec { 'install kodi':
	command => '/usr/bin/make install',
	cwd => "/usr/local/kodi",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
}

class ensure_usr_local {
    file {'/usr/local':
        ensure => 'directory',
        mode => '0755',
        owner => $::nonroot_username
    }
}

class clone_kodi_repo {
    require ensure_usr_local
    vcsrepo { "/usr/local/kodi":
      ensure   => present,
      revision => '17.0-Krypton',
      provider => git,
      source => 'https://github.com/xbmc/xbmc.git',
      user => $::nonroot_username,
      owner => $::nonroot_username,
      depth => '1',
    }
}

class refresh_kodi_repo {
    require clone_kodi_repo
    exec { 'git clean kodi repo':
	command => '/usr/bin/git clean -f',
	cwd => "/usr/local/kodi/",
        user => $::nonroot_username
    }
}

class ffmpeg_dependencies {
    $ffmpeg_deps = [
	'yasm',
    ]
    package { $ffmpeg_deps: 
	ensure => 'installed',
    }
}

class bootstrap_depends {
    require refresh_kodi_repo
    exec { 'bootstrap depends':
	command => "/usr/local/kodi/tools/depends/bootstrap",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local'
    }
}

class install_crossguid {
    package { "libcrossguid":
	ensure => 'installed',
    }
}

class build_crossguid {
    require refresh_kodi_repo
    require bootstrap_depends
    require kodi_dependencies
    exec { 'configure depends for crossguid':
	command => "/usr/local/kodi/tools/depends/configure --prefix=/usr/local",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600,
	notify => Exec['build crossguid'],
	onlyif => '/usr/bin/test ! -f /usr/local/x86_64-linux-gnu/lib/libcrossguid.a'
    }
    exec { 'build crossguid':
	command => "/usr/bin/make -C target/crossguid",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600,
	refreshonly => true,
        require => Exec['configure depends for crossguid'],
	onlyif => '/usr/bin/test ! -f /usr/local/x86_64-linux-gnu/lib/libcrossguid.a'
    }
}

class install_dcadec {
    package { "dcadec":
	ensure => 'installed',
    }
}

class install_taglib {
    package { "taglib":
	ensure => 'installed',
    }
}

class build_cmake {
    require refresh_kodi_repo
    require bootstrap_depends
    exec { 'configure depends for cmake':
	command => "/usr/local/kodi/tools/depends/configure --prefix=/usr/local",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600,
	notify => Exec['build cmake'],
	onlyif => '/usr/bin/test ! -f /usr/local/x86_64-linux-gnu-native/bin/cmake'
    }
    exec { 'build cmake':
	command => "/usr/bin/make -C native/cmake-native/",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600,
	refreshonly => true,
        require => Exec['configure depends for cmake'],
	onlyif => '/usr/bin/test ! -f /usr/local/x86_64-linux-gnu-native/bin/cmake'
    }
}

class build_taglib {
    require refresh_kodi_repo
    require bootstrap_depends
    require build_cmake
    require kodi_dependencies
    exec { 'configure depends for taglib':
	command => "/usr/local/kodi/tools/depends/configure --prefix=/usr/local",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600,
	notify => Exec['build taglib'],
	onlyif => '/usr/bin/test ! -f /usr/local/x86_64-linux-gnu/bin/taglib-config'
    }
    exec { 'build taglib':
	command => "/usr/bin/make -C target/taglib/",
	cwd => "/usr/local/kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600,
	refreshonly => true,
        require => Exec['configure depends for taglib'],
	onlyif => '/usr/bin/test ! -f /usr/local/x86_64-linux-gnu/bin/taglib-config'
    }
}


class kodi_dependencies {
    require clone_kodi_repo
    require refresh_kodi_repo
    require ffmpeg_dependencies
    include kodi_bundled_dependencies
    $libxslt = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxslt-dev',
	default => 'libxslt',
    }
    package { "$libxslt":
	ensure => 'installed',
    }
    $openjdk = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'openjdk-8-jdk',
	default => 'jre8-openjdk',
    }
    package { "$openjdk":
	ensure => 'installed',
    }
    $glu = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libglu-dev',
	default => 'glu',
    }
    package { "$glu":
	ensure => 'installed',
    }
    $mariadbclient = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libmysqlclient-dev',
	default => 'libmariadbclient',
    }
    package { "$mariadbclient":
	ensure => 'installed',
    }
    $libass = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libass-dev',
	default => 'libass',
    }
    package { "$libass":
	ensure => 'installed',
    }
    $tinyxml = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libtinyxml-dev',
	default => 'tinyxml',
    }
    package { "$tinyxml":
	ensure => 'installed',
    }
    $libcdio = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libcdio-dev',
	default => 'libcdio',
    }
    package { "$libcdio":
	ensure => 'installed',
    }
    $libssh = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libssh-dev',
	default => 'libssh',
    }
    package { "$libssh":
	ensure => 'installed',
    }
    $libuuid = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'uuid-dev',
	default => 'util-linux',
    }
    package { "$libuuid":
	ensure => 'installed',
    }
    if $operatingsystem != 'Archlinux' {
	    $kodi_debian_deps = [
		'libcurl4-openssl-dev',
		'libegl1-mesa-dev',
		'autopoint',
		'libiso9660-dev'
	    ]
	    package { $kodi_debian_deps: 
		ensure => 'installed',
	    }
    }
    $python = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'python-dev',
	default => 'python2',
    }
    package { "$python":
	ensure => 'installed',
    }
    $glew = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libglew-dev',
	default => 'glew',
    }
    package { "$glew":
	ensure => 'installed',
    }
    $libmpeg2 = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libmpeg2-4-dev',
	default => 'libmpeg2',
    }
    package { "$libmpeg2":
	ensure => 'installed',
    }
    $libjpeg = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libjpeg-dev',
	default => 'libjpeg-turbo',
    }
    package { "$libjpeg":
	ensure => 'installed',
    }
    $libogg = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libogg-dev',
	default => 'libogg',
    }
    package { "$libogg":
	ensure => 'installed',
    }
    $libvorbis = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libvorbis-dev',
	default => 'libvorbis',
    }
    package { "$libvorbis":
	ensure => 'installed',
    }
    $libbz2 = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libbz2-dev',
	default => 'bzip2',
    }
    package { "$libbz2":
	ensure => 'installed',
    }
    $libtiff = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libtiff-dev',
	default => 'libtiff',
    }
    package { "$libtiff":
	ensure => 'installed',
    }
    $liblzo = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'liblzo2-dev',
	default => 'lzo',
    }
    package { "$liblzo":
	ensure => 'installed',
    }
    $libyajl = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libyajl-dev',
	default => 'yajl',
    }
    package { "$libyajl":
	ensure => 'installed',
    }
    $sqlite3 = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libsqlite3-dev',
	default => 'sqlite',
    }
    package { "$sqlite3":
	ensure => 'installed',
    }
    $libpcre = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libpcre3-dev',
	default => 'pcre',
    }
    package { "$libpcre":
	ensure => 'installed',
    }
    $libjasper = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libjasper-dev',
	default => 'jasper',
    }
    package { "$libjasper":
	ensure => 'installed',
    }
    $libmicrohttpd = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libmicrohttpd-dev',
	default => 'libmicrohttpd',
    }
    package { "$libmicrohttpd":
	ensure => 'installed',
    }
    $libxrandr = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxrandr-dev',
	default => 'libxrandr',
    }
    package { "$libxrandr":
	ensure => 'installed',
    }
    $libsmbclient = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libsmbclient-dev',
	default => 'smbclient',
    }
    package { "$libsmbclient":
	ensure => 'installed',
    }
    $libusb = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libusb-dev',
	default => 'libusb',
    }
    package { "$libusb":
	ensure => 'installed',
    }
    $boost = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libboost-dev',
	default => 'boost',
    }
    package { "$boost":
	ensure => 'installed',
    }
    $kodi_deps = [
	'swig',
	'gperf',
	'libtool',
	'gettext',
	'cmake',
	'gawk',
	'zip'
    ]
    package { $kodi_deps: 
	ensure => 'installed',
    }
}

class kodi_bundled_dependencies {
    require kodi_dependencies
    case $operatingsystem {
	'Archlinux': 	{ require install_crossguid }
	'Debian':	{ require build_crossguid }
	'Ubuntu':	{ require build_crossguid }
    }
    case $operatingsystem {
	'Archlinux': 	{ require install_dcadec }
    }
    case $operatingsystem {
	'Archlinux': 	{ require install_taglib }
	'Debian':	{ require build_taglib }
	'Ubuntu':	{ require build_taglib }
    }
}
