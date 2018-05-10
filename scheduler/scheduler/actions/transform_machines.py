from logging import getLogger
from json import loads
from urllib.request import Request, urlopen
from sys import stdout
from subprocess import Popen, PIPE


CONSUL_API_URL = 'http://localhost:8500/v1/'
CONSUL_NODES_URI = 'catalog/nodes'

log = getLogger(__name__)


def list_machines():
    """
    List all machines by asking the consul API for a list
    :return list[dict, ..]: A list of dicts containing machine information
    """
    log.info("Discovering all live machines")
    req = Request(CONSUL_API_URL + CONSUL_NODES_URI)
    with urlopen(req) as f:
        resp = f.read()
    return loads(resp)


# TODO: move remote command to separate function
# TODO: implement an async command here (jobrunner?)
# TODO: there are no tests for this function, fix that
def run_configuration_management(host):
    """
    Perform the configuration management
    :param str host: The hostname or IP of the machine
    to run the configuration management on
    """
    log.info("Running configuration management on {}".format(host))
    ssh_command_as_list = [
        '/usr/bin/env', 'ssh', '-A',
        '-o', 'ConnectTimeout=5',
        '-o', 'StrictHostKeyChecking=no',
        '-o', 'ServerAliveInterval=10',
        '-o', 'ServerAliveCountMax=3',
        '-o', 'UserKnownHostsFile=/dev/null',
        '-o', 'PasswordAuthentication=no',
        'root@{}'.format(host), '-p', '22',
    ]
    configuration_management_command_as_list = [
        '/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/papply.sh',
        '/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/manifests/headless.pp'
    ]
    process = Popen(
        ssh_command_as_list + configuration_management_command_as_list,
        stdout=PIPE, universal_newlines=False, stderr=PIPE,
        shell=False, bufsize=0,
    )
    for line in iter(process.stdout.readline, b''):
        stdout.buffer.write(line)
        stdout.flush()
    standard_error = process.communicate()
    exit_code = process.returncode
    if exit_code != 0:
        log.info(
            "Running configuration management on {} failed, "
            "error was: {}".format(host, standard_error)
        )


def transform_machines():
    """
    Discover machines and run configuration management
    on them using appropriate settings based on the
    amount of resources available in the network.
    :return None
    """
    machines = list_machines()
    for machine_host in [m['Address'] for m in machines]:
        run_configuration_management(machine_host)
