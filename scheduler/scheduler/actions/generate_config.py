# TODO: there are no tests for this function, fix that
def generate_config_for_machine(machine):
    return {
        'simulacra': {
            'ipv6_address': machine['Address'],
            'redis': machine['Node'] == 'retropie'
        }
    }


# TODO: there are no tests for this function, fix that
def generate_config_for_machines(machines):
    return [generate_config_for_machine(m) for m in machines]
