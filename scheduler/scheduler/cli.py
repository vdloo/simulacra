from argparse import ArgumentParser

from scheduler.log import setup_logging
from scheduler.actions.transform_machines import transform_machines


def parse_arguments(parser, args=None):
    """
    Add default parser arguments to parser and parse arguments.
    Also sets logging level.
    :param obj parser:
    :param list args: Args to pass to the arg parser.
    Will use argv if none specified.
    :return obj args: parsed arguments
    """
    parser.add_argument('--verbose', '-v', action='store_true')
    args = parser.parse_args(args=args)
    setup_logging(debug=args.verbose)
    return args


def parse_transform_arguments():
    """
    Parse the commandline options for transforming the machines
    available (listed from consul members) into the best possible
    instantiation of the declarative infrastructure.
    :return obj args: parsed arguments
    """
    parser = ArgumentParser(
        description='Transform the available machines into the '
                    'most appropriate instantiation of the '
                    'configured infrastructure'
    )
    return parse_arguments(parser)


def transform():
    """
    Transform the available machines into the most appropriate 
    instantiation of the configured infrastructure
    :return None:
    """
    parse_transform_arguments()
    transform_machines()
