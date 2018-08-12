class libvirt {
    if ! ($operatingsystem =~ /^(Debian|Ubuntu)$/) {
        include install_libvirt
    }
}

class install_libvirt {
    $packages = [
      'libvirt',
      'qemu',
      'firewalld',
      'dnsmasq',
      'virt-manager'
    ]
    package { $packages:
      ensure => 'installed',
    } -> 
    # See https://bbs.archlinux.org/viewtopic.php?pid=1801224#p1801224
    file { '/etc/firewalld/firewalld.conf':
        ensure => file,
        content => template('libvirt/firewalld.conf.erb')
    }
    file { '/root/hypervisor.sh':
        ensure => file,
        mode => '0744',
        content => template('libvirt/hypervisor.sh.erb')
    }
    file { '/root/images':
        ensure => 'directory',
    }
    file { '/root/pool.xml':
        ensure => file,
        content => template('libvirt/pool.xml.erb')
    }
}

