include dwm
class dwm {
    require nonroot
    require refresh_dwm_repo
    require fibonacci
    require gaplessgrid
    require dwm_dependencies
    require config_h
    exec { 'build dwm':
	command => '/usr/bin/make clean',
	cwd => "/home/${::nonroot_username}/.dwm/"
    }
    exec { 'install dwm':
	command => '/usr/bin/make install',
	cwd => "/home/${::nonroot_username}/.dwm/"
    }
}

class clone_dwm_repo {
    vcsrepo { "/home/${::nonroot_username}/.dwm":
      ensure   => latest,
      provider => git,
      source => 'http://git.suckless.org/dwm',
      user => $::nonroot_username,
      owner => $::nonroot_username,
      revision => 'master',
    }
}

class refresh_dwm_repo {
    require clone_dwm_repo
    exec { 'git clean dwm repo':
	command => '/usr/bin/git clean -f',
	cwd => "/home/${::nonroot_username}/.dwm/"
    }
}

class fetch_patches {
    require wget
    require clone_dwm_repo
    require refresh_dwm_repo
    wget::fetch { 'download dwm fibonacci patch':
        source => 'https://dwm.suckless.org/patches/fibonacci/dwm-fibonacci-5.8.2.diff',
	destination => "/home/${::nonroot_username}/.dwm/fibonacci.diff",
	timeout => 0,
	verbose => false,
	execuser => $::nonroot_username,
    }
    wget::fetch { 'download dwm gapless_grid patch':
        source => 'https://dwm.suckless.org/patches/gaplessgrid/dwm-gaplessgrid-6.1.diff',
	destination => "/home/${::nonroot_username}/.dwm/gapless_grid.diff",
	timeout => 0,
	verbose => false,
	execuser => $::nonroot_username,
    }
}

class fibonacci {
    exec { 'patch dwm with fibonacci':
	command => '/usr/bin/patch < fibonacci.diff -f',
	cwd => "/home/${::nonroot_username}/.dwm/"
    }
    require fetch_patches
    require refresh_dwm_repo
}

class gaplessgrid {
    exec { 'patch dwm with gapless_grid':
	command => '/usr/bin/patch < gapless_grid.diff -f',
	cwd => "/home/${::nonroot_username}/.dwm/"
    }
    require fetch_patches
    require refresh_dwm_repo
}

class config_h {
    require refresh_dwm_repo
    require fibonacci
    require gaplessgrid
    file { "/home/${::nonroot_username}/.dwm/config.h":
	ensure => 'link',
	target => "/home/${::nonroot_username}/.dotfiles/code/configs/dwm/arch-config.h",
    }
}

class dwm_dependencies {
    $libx11 = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libx11-dev',
	default => 'libx11',
    }
    package { "$libx11":
	ensure => 'installed',
	alias => 'libx11',
    }
    $libxft = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxft-dev',
	default => 'libxft',
    }
    package { "$libxft":
	ensure => 'installed',
	alias => 'libxft',
    }
    $libxinerama = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxinerama-dev',
	default => 'libxinerama',
    }
    package { "$libxinerama":
	ensure => 'installed',
	alias => 'libxinerama',
    }
    if $virtual != 'physical' {
      if $operatingsystem =~ /^(Debian|Ubuntu)$/ {
        package { "xserver-xorg-legacy":
	    ensure => 'installed',
        }
      }
    }
    $xorg = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'xorg',
	default => 'xorg-server',
    }
    package { "$xorg":
	ensure => 'installed',
	alias => 'xorg',
    }
    $xinit = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'xinit',
	default => 'xorg-xinit',
    }
    package { "$xinit":
	ensure => 'installed',
	alias => 'xinit',
    }
    $xsetroot = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'x11-xserver-utils',
	default => 'xorg-xsetroot',
    }
    package { "$xsetroot":
	ensure => 'installed',
	alias => 'xsetroot',
    }
    $xrandr = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'x11-xserver-utils',
	default => 'xorg-xrandr',
    }
    package { "$xrandr":
	ensure => 'installed',
	alias => 'xrandr',
    }
    package { "dmenu":
	ensure => 'installed',
    }
}
