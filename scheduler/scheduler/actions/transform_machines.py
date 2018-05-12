from logging import getLogger
from tempfile import NamedTemporaryFile
from json import loads, dump
from multiprocessing.pool import ThreadPool
from urllib.request import Request, urlopen
from sys import stdout
from subprocess import Popen, PIPE

from scheduler.actions.generate_config import generate_config_for_machines


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


# TODO: there are no tests for this function, fix that
def run_remote_command(command_as_list, host, port=22):
    """
    Run a command on a remote machine
    :param list command_as_list: The command to run
    :param str host: the host to run the command on
    :param int port: the ssh port to use to login with
    """
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
    process = Popen(
        ssh_command_as_list + command_as_list,
        stdout=PIPE, universal_newlines=False, stderr=PIPE,
        shell=False, bufsize=0,
        )
    for line in iter(process.stdout.readline, b''):
        stdout.buffer.write(line)
        stdout.flush()
    standard_error = process.communicate()
    exit_code = process.returncode
    return standard_error, exit_code


# TODO: there are no tests for this function, fix that
def upload_file(source, destination, host, port=22):
    """
    Rsync a path to the specified host
    :param str source: The source path
    :param str destination: The destination path
    :param str host: The host to rsync to
    :param int port: The SSH port to use
    """
    upload_command = [
        '/usr/bin/env', 'rsync', '-q', '--force', '-avz',
        source, 'root@[{}]:{}'.format(host, destination),
        '--exclude=.venv', '--exclude=*.pyc',
        '--exclude=var', '--exclude=last_advertised',
        '-e', 'ssh -p {} '
              '-oStrictHostKeyChecking=no '
              '-oUserKnownHostsFile=/dev/null'.format(port)
    ]
    process = Popen(
        upload_command,
        stdout=PIPE, universal_newlines=False, stderr=PIPE,
        shell=False, bufsize=0,
    )
    for line in iter(process.stdout.readline, b''):
        stdout.buffer.write(line)
        stdout.flush()
    standard_error = process.communicate()
    exit_code = process.returncode
    return standard_error, exit_code


# TODO: implement an async command here (jobrunner?)
def run_configuration_management(host):
    """
    Perform the configuration management
    :param str host: The hostname or IP of the machine
    to run the configuration management on
    """
    log.info("Running configuration management on {}".format(host))
    configuration_management_command_as_list = [
        '/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/papply.sh',
        '/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/manifests/headless.pp'
    ]
    standard_error, exit_code = run_remote_command(
        configuration_management_command_as_list,
        host
    )
    if exit_code != 0:
        log.info(
            "Running configuration management on {} failed, "
            "error was: {}".format(host, standard_error)
        )


def ensure_config_directory_exists(host):
    """
    Create the config directory on the remote machine
    :param str host: Host to create the directory on
    """
    log.info("Ensuring config directory exists on {}".format(host))
    mkdir_command_as_list = [
        'mkdir', '-p', '/etc/facter/facts.d'
    ]
    standard_error, exit_code = run_remote_command(
        mkdir_command_as_list, host
    )
    if exit_code != 0:
        log.info(
            "Ensuring the config directory on {} failed, "
            "error was: {}".format(host, standard_error)
        )


def place_config_on_machine(host, config):
    """
    Write the specified configuration file to
    a temporary file and upload it to the
    remote machine.
    :param str host: the host to place the config on
    :param dict config: The config as a dict
    """
    log.info("Uploading config to {}".format(host))
    with NamedTemporaryFile() as temp_file:
        with open(temp_file.name, 'w') as f:
            dump(
                config, f, indent=4,
                sort_keys=True
            )
        standard_error, exit_code = upload_file(
            temp_file.name, '/etc/facter/facts.d/simulacra.json', host
        )
        if exit_code != 0:
            log.info(
                "Uploading config to {} failed, "
                "error was: {}".format(host, standard_error)
            )


def transform_machine(host, config):
    """
    Write the configuration management config on
    the remote machine and run configuration management.
    :param str host: The host to transform
    :param dict config: The config to use
    """
    ensure_config_directory_exists(host)
    place_config_on_machine(host, config)
    run_configuration_management(host)


def transform_machines(concurrent=5):
    """
    Discover machines and run configuration management
    on them using appropriate settings based on the
    amount of resources available in the network.
    :param int concurrent: How many machines to
    transform at the same time.
    :return None
    """
    machines = list_machines()
    machine_hosts = [m['Address'] for m in machines]
    machine_configs = generate_config_for_machines(machines)
    pool = ThreadPool(processes=concurrent)
    pool.starmap(
        transform_machine,
        zip(machine_hosts, machine_configs)
    )
