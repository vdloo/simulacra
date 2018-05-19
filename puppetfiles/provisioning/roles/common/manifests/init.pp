class common {
  require default_packages
  include nonroot
  include dotfiles
  include vim
  include update_puppetfiles
  include locales
  include redis
  include mysql
  include inspircd
  include jobrunner
}

class os {
  case $operatingsystem {
    'Archlinux': 	{ require archlinux }
    'Debian':	{ require debian }
    'Ubuntu':	{ require ubuntu }
  }
}

class locales {
  require decide_locales_package_needed
  file {
    "/etc/locale.gen":
      mode    => '0644',
      content => "en_US.UTF-8 UTF-8\n",
      notify  => Exec['generate-locales'];
  }
  file {
    "/etc/default/locale":
      mode    => '0644',
      content => "LANGUAGE=en_US:en\nLANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8\n";
  }
  exec {
    'generate-locales':
      command  => '/usr/sbin/locale-gen',
      user     => root,
  }
}

class decide_locales_package_needed {
  case $operatingsystem {
    'Debian':	{ require locales_package }
    'Ubuntu':	{ require locales_package }
  }
}

class locales_package {
  package {
    'locales':
      ensure  => installed;
  }
}

class default_packages {
  require os
  $buildessential = $operatingsystem ? {
    /^(Debian|Ubuntu)$/ => 'build-essential',
    default => 'base-devel',
  }
  package { "$buildessential":
    ensure => 'installed',
    alias => 'buildessential',
  }
  $packages = [
    'python-virtualenv',
    'unzip',
    'curl',
    'nmap',
    'automake',
    'make',
    'htop',
    'iftop',
    'sysstat',
    'task',
    'irssi',
    'ctags',
    'git',
    'screen',
    'xclip',
    'feh',
  ]
  package { $packages:
    ensure => 'installed',
  }
}

class update_puppetfiles {
  vcsrepo { '/root/.raptiformica.d/modules/simulacra':
    ensure   => latest,
    provider => git,
    source => 'https://github.com/vdloo/simulacra',
    revision => 'master',
    force => true
  }
}

