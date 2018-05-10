class archlinux {
    include update_pacman
}

class update_pacman {
	exec { 'pacman full system upgrade':
		command => '/usr/bin/pacman -Syyu --noconfirm',
		timeout => 3600
	}
}
