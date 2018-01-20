$nonroot_username = hiera('nonroot_username', 'nonroot')
$nonroot_git_email = hiera('nonroot_git_email', 'johndoe@example.com')
$nonroot_git_username = hiera('nonroot_git_username', 'John Doe')

include common
include workstation
include htpc
include htpc_cron

class htpc_cron {
    cron { "puppet apply":
        command => "/usr/etc/simulacra/puppetfiles/provisioning/papply.sh /usr/etc/simulacra/puppetfiles/provisioning/manifests/htpc.pp",
        user    => "root",
        hour    => 0,
        minute  => 15
    }
}
