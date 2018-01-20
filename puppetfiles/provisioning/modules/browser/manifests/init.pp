class browser {
    $browser = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'chromium-browser',
	default => 'chromium',
    }
    package { "$browser":
	ensure => 'installed',
	alias => 'browser',
    }
}
