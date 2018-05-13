class mysql {
    if $facts['simulacra'] {
        $simulacra = $facts['simulacra']
    } else {
        $simulacra = {}
    }
    if $simulacra['mysql'] {
        $mysql_enabled = true
    } else {
        $mysql_enabled = false
    }

    if $mysql_enabled {
        require install_mysql
    }
    service { "mysql":
        ensure => $mysql_enabled ? {true => 'running', default => 'stopped'}
    }
}

class install_mysql {
    if $facts['simulacra'] {
        $simulacra = $facts['simulacra']
    } else {
        $simulacra = {}
    }
    if $simulacra['ipv6_address'] {
        $mysql_ipv6_address = $simulacra['ipv6_address']
    } else {
        $mysql_ipv6_address = null
    }

    file { '/etc/mysql/':
        ensure => 'directory',
    }
    file { '/etc/mysql/mariadb.conf.d':
        ensure => 'directory',
    }
    file { '/etc/mysql/mariadb.conf.d/90-simulacra.cnf':
        ensure => file,
        content => template('mysql/mysql.conf.erb')
    }
    $mysql = $operatingsystem ? {
        /^(Debian|Ubuntu)$/ => 'mariadb-server',
        default => 'mariadb',
    }
    package { "$mysql":
        ensure => 'installed',
        alias => 'mysql',
    }
    exec { "ensure_database":
        unless => "/usr/bin/mysql simulacra",
        # No password but the service only binds on the internal ipv6 address on the
        # encrypted overlay network, see mysql.conf.erb. Grant only allows fc00::/8
        # addresses to login, see https://en.wikipedia.org/wiki/Unique_local_address
        command => "/usr/bin/mysql -uroot -e \"create database simulacra;
        create user simulacra@'fc:%'; grant all on simulacra.* to simulacra@'fc:%';\"",
    }
}
