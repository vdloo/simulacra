#!/usr/bin/env python3
from scheduler.cli import transform

if __name__ == '__main__':
    transform()
else:
    raise RuntimeError("This script is an entry point and can not be imported")

