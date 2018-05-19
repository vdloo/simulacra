class jobrunner {
    exec { 'ensure jobrunner is running':
        command => 'sh /root/.raptiformica.d/modules/simulacra/deploy.sh',
        provider => 'shell',
        timeout => 1800
    }
}
