from logging import getLogger, StreamHandler, DEBUG, INFO
from sys import stdout


def setup_logging(debug=False):
    logger = getLogger('scheduler')
    logger.setLevel(DEBUG if debug else INFO)
    console_handler = StreamHandler(stdout)
    logger.addHandler(console_handler)
    return logger
