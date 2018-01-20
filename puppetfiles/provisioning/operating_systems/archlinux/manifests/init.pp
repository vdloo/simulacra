class archlinux {
    include update_pacman
}

class download_mirrorlist {
	require wget
	wget::fetch { 'download archlinux mirrorlist':
		source => 'https://www.archlinux.org/mirrorlist/all/',
		destination => "/home/${::nonroot_username}/.full_mirrorlist",
		timeout => 0,
		verbose => false,
		execuser => $::nonroot_username,
	}
}

class ensure_global_mirrorlist {
	require download_mirrorlist
	exec { 'uncomment mirrors':
		command => "/usr/bin/sed -e 's/^#Server/Server/' /home/${::nonroot_username}/.full_mirrorlist > /home/${::nonroot_username}/.all_mirrors",
	}
}

class ensure_european_mirrorlist {
        require ensure_global_mirrorlist
	exec { 'get european mirrors':
		command => "/usr/bin/grep 'nl\\/\\|eu\\/\\|\\.be\\/\\|\\.de\\/' /home/${::nonroot_username}/.all_mirrors > /home/${::nonroot_username}/.european_mirrors",
	}
}

class get_fastest_mirrors {
	require ensure_european_mirrorlist
	exec { 'rank mirrors':
		command => "/usr/bin/rankmirrors -n 3 /home/${::nonroot_username}/.european_mirrors > /etc/pacman.d/mirrorlist",
		timeout => 600
	}
}

class update_pacman {
	require get_fastest_mirrors
	exec { 'pacman full system upgrade':
		command => '/usr/bin/pacman -Syyu --noconfirm',
		timeout => 3600
	}
}
