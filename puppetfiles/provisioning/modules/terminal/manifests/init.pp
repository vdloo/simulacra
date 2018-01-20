include terminal
class terminal {
	package { 'terminator':
		ensure => 'installed',
	}
	# Terminator doesn't like the terminus system font for some reason
	# We need to have ttf-dejavu installed to get proper rendering (in Virtualbox only?)
	if $operatingsystem == 'Archlinux' {
		package { 'ttf-dejavu':
			ensure => 'installed',
		}
	}
}
