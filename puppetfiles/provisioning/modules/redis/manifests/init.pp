class redis {
    if $facts['simulacra'] {
        $simulacra = $facts['simulacra']
    } else {
        $simulacra = {}
    }
    if $simulacra['redis'] {
        $redis_enabled = true
    } else {
        $redis_enabled = false
    }

    if $redis_enabled {
        require install_redis
    }
    $redis = $operatingsystem ? {
        /^(Debian|Ubuntu)$/ => 'redis-server',
        default => 'redis',
    }
    service { "$redis":
        ensure => $redis_enabled ? {true => 'running', default => 'stopped'}
    }
}

class install_redis {
    if $facts['simulacra'] {
        $simulacra = $facts['simulacra']
    } else {
        $simulacra = {}
    }
    if $simulacra['ipv6_address'] {
        $redis_ipv6_address = $simulacra['ipv6_address']
    } else {
        $redis_ipv6_address = null
    }

    file { '/etc/redis/':
        ensure => 'directory',
    }
    file { '/etc/redis/redis.conf':
        ensure => file,
        content => template('redis/redis.conf.erb')
    }
    $redis = $operatingsystem ? {
        /^(Debian|Ubuntu)$/ => 'redis-server',
        default => 'redis',
    }
    package { "$redis":
        ensure => 'installed',
        alias => 'redis',
    }
}
