$nonroot_username = hiera('nonroot_username', 'nonroot')
$nonroot_git_email = hiera('nonroot_git_email', 'johndoe@example.com')
$nonroot_git_username = hiera('nonroot_git_username', 'John Doe')

include common
include headless_cron

class headless_cron {
    cron { "puppet apply":
        command => "/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/papply.sh /root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/manifests/headless.pp",
        user    => "root",
        hour    => 0,
        minute  => 15
    }
}
