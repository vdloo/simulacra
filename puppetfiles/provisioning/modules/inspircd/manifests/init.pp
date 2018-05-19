class inspircd {
    if $facts['simulacra'] {
        $simulacra = $facts['simulacra']
    } else {
        $simulacra = {}
    }
    if $simulacra['inspircd'] {
        $inspircd_enabled = true
    } else {
        $inspircd_enabled = false
    }

    if $inspircd_enabled {
        require install_inspircd
    }
    $inspircd = $operatingsystem ? {
        /^(Debian|Ubuntu)$/ => 'inspircd',
        # Note that on Archlinux this is in the AUR and puppet 
        # won't be able to get it unless yaourt is installed.
        # See https://github.com/puppetlabs/puppet/blob/5a58eb768414a8397c668547385ac57ff957483e/lib/puppet/provider/package/pacman.rb#L144
        default => 'inspircd',
    }
    service { "$inspircd":
        ensure => $inspircd_enabled ? {true => 'running', default => 'stopped'}
    }
}

class install_inspircd {
    if $facts['simulacra'] {
        $simulacra = $facts['simulacra']
    } else {
        $simulacra = {}
    }
    if $simulacra['ipv6_address'] {
        $inspircd_ipv6_address = $simulacra['ipv6_address']
    } else {
        $inspircd_ipv6_address = null
    }

    file { '/etc/inspircd/':
        ensure => 'directory',
    }
    file { '/etc/inspircd/inspircd.conf':
        ensure => file,
        content => template('inspircd/inspircd.conf.erb')
    }
    package { "inspircd":
        ensure => 'installed',
        alias => 'inspircd',
    }
    exec { 'fix inspircd config subdir permissions':
        command => 'find /etc/inspircd -type d -exec chmod 770 {} \;',
    }
    exec { 'fix inspircd config file permissions':
        command => 'find /etc/inspircd -type f -exec chmod 644 {} \;',
    }
    exec { 'fix inspircd config dir ownership permissions':
        command => '/bin/chown -R irc:irc /etc/inspircd',
    }
    cron { 'truncate irc daemon logs':
      command => '/usr/bin/truncate /var/log/inspircd.log > /dev/null 2>&1',
      user    => 'root',
      hour    => 4,
    }
}
