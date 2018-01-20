class nonroot {
    include createnonrootuser
    include setgitconfig
    include sudo
    include visudo
}

class createnonrootuser {
    user { 
        $::nonroot_username:
        ensure => present,
        shell => '/bin/bash',
        managehome => 'true',
    }
}

class setgitconfig {
    require createnonrootuser
    # if the nonroot_git_* entries are not defined in hiera the use email and name will default to 
    exec { 'set git user email':
        command => "/bin/su - ${::nonroot_username} -c \"/usr/bin/git config --global user.email '${::nonroot_git_email}'\"",
    }
    exec { 'set git user name':
        command => "/bin/su - ${::nonroot_username} -c \"/usr/bin/git config --global user.name '${::nonroot_git_username}'\"",
    }
    exec { 'set git editor':
        command => "/bin/su - ${::nonroot_username} -c \"/usr/bin/git config --global core.editor 'vim'\"",
    }
}

class visudo {
    sudo::conf{ $::nonroot_username:
        ensure => present,
        content => hiera('nonroot_sudoers_entry', "${::nonroot_username} ALL=(ALL) ALL"),
    }
    sudo::conf{ 'vagrant':
        ensure => present,
        content => 'vagrant ALL=(ALL) NOPASSWD: ALL',
    }
    sudo::conf{ 'android':
        ensure => present,
        content => 'android ALL=(ALL) NOPASSWD: ALL',
    }
}
