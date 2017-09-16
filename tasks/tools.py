from multiprocessing.pool import ThreadPool
from os import system

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
                      "Defaults to all",
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
