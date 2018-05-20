MAIN_MACHINES = ('retropie', 'env1vm1', 'env2vm1')


# TODO: there are no tests for this function, fix that
def generate_config_for_machine(machine):
    return {
        'simulacra': {
            'ipv6_address': machine['Address'],
            'mysql': machine['Node'] in MAIN_MACHINES,
            'redis': machine['Node'] in MAIN_MACHINES,
            # IRC server for logging changes from the network to
            # See raptiformica.json in the root of this repo.
            'inspircd': machine['Node'] in MAIN_MACHINES,
        }
    }


# TODO: there are no tests for this function, fix that
def generate_config_for_machines(machines):
    return [generate_config_for_machine(m) for m in machines]
