class debianlike {
    include update_apt
}
class update_apt {
    exec { 'apt-key update':
	command => '/usr/bin/apt-key update'
    } ->
    exec { 'apt-get update':
	command => '/usr/bin/apt-get update'
    } ->
    exec { 'apt-get upgrade -y':
	command => '/usr/bin/apt-get upgrade -y'
    }
}

