from multiprocessing.pool import ThreadPool
from os import system
from time import sleep

from invoke import task


def spawn_instance(compute_type):
    system(
        "raptiformica spawn "
        "--compute-type {}".format(compute_type)
    )


def spawn_devenv(ctx, compute_type, nodes, concurrent):
    pool = ThreadPool(concurrent)
    for _ in range(nodes):
        pool.apply_async(spawn_instance, args=(compute_type,))
    pool.close()
    pool.join()


@task(
    help={
        "compute-type": "The compute type of the dev environment. "
                        "Like 'vagrant' or 'docker",
        "nodes": "The amount of instances to boot",
        "concurrent": "The amount to boot at the same time. "
                      "Defaults to all"
    }
)
def devenv(ctx, compute_type='docker', nodes=3, concurrent=None):
    if compute_type == 'vagrant':
        ctx.run('vagrant plugin install vagrant-tun')
        ctx.run(
            'vagrant plugin list | '
            'grep -q vagrant-vbguest && '
            'vagrant plugin install vagrant-vbguest || '
            '/bin/true'
        )
    concurrent = concurrent or nodes
    spawn_devenv(ctx, compute_type, int(nodes), int(concurrent))

@task(
    help={
        "nodes": "The amount of instances to boot",
        "concurrent": "The amount to boot at the same time. "
                      "Defaults to all",
    }
)
def jobrunner_devenv(ctx, concurrent=None, nodes=3):
    # Clean up old raptiformica state
    system("raptiformica clean")
    # Kill any running Dockers
    system("docker ps | grep -v CONTAINER | awk '{print$1}' | xargs --no-run-if-empty docker kill")
    # Install simulacra module
    system("raptiformica install vdloo/simulacra")

    # TODO(vdloo): implement a taskflow consul jobboard and persistence backend
    # Run a Redis
    system("docker run -d -p 6379:6379 redis")
    # Run a MySQL
    system("docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=taskflow -d mysql")
    # Create the database after waiting a bit
    sleep(10)
    system("mysql -h 172.17.0.1 -u root -ptaskflow -e 'create database taskflow'")

    devenv(ctx, compute_type='docker', nodes=nodes, concurrent=concurrent)
