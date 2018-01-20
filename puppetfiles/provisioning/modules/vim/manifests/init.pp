class vim {
    $vim = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'vim-nox',
	default => 'vim',
    }
    package { "$vim":
	ensure => 'installed',
	alias => 'vim',
    }
    include vimrc
    include vundle
    include zenburn
}

class vimrc {
    file { "/home/${::nonroot_username}/.vimrc":
	ensure => 'link',
	target => "/home/${::nonroot_username}/.dotfiles/.vimrc",
	owner => $::nonroot_username,
    }
}

class createdotvim {
    file { "/home/${::nonroot_username}/.vim":
	ensure => 'directory',
	owner => $::nonroot_username,
    }
}

class vundle {
    file { "/home/${::nonroot_username}/.vim/bundle":
	ensure => 'directory',
	owner => $::nonroot_username,
    }
    vcsrepo { "/home/${::nonroot_username}/.vim/bundle/Vundle":
      ensure   => latest,
      provider => git,
      source => 'https://github.com/VundleVim/Vundle.vim',
      user => $::nonroot_username,
      owner => $::nonroot_username,
    }
    require createdotvim
}

class zenburn {
    require wget
    require createdotvim
    file { "/home/${::nonroot_username}/.vim/colors":
	ensure => 'directory',
	owner => $::nonroot_username,
    }
    wget::fetch { 'download zenburn theme':
        source => 'http://www.vim.org/scripts/download_script.php?src_id=15530',
	destination => "/home/${::nonroot_username}/.vim/colors/zenburn.vim",
	timeout => 0,
	verbose => false,
	execuser => $::nonroot_username,
    }
}
