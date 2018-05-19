class jobrunner {
    exec { 'ensure jobrunner is running':
        command => 'ps aux | grep -q "/root/.raptiformica.d/modules/simulacra/bin/[j]obrunner_run" || sh /root/.raptiformica.d/modules/simulacra/deploy.sh',
        provider => 'shell'
    }
}
