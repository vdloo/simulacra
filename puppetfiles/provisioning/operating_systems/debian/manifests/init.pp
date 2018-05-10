class debian {
    require keyring_packages
    include debianlike
}
class keyring_packages {
  $packages = [
    'debian-keyring',
    'debian-archive-keyring',
  ]
  package { $packages:
    ensure => 'installed',
  }
}

