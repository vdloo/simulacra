#!/usr/bin/env python3
import socket
import subprocess
from argparse import ArgumentParser
from contextlib import suppress
import time

IRC_HOSTNAME = 'retropie'
IRC_PORT = 6667
IRC_CHANNEL = '#status'


def get_irc_host():
    with suppress(Exception):
        output = subprocess.check_output(
            "consul members | grep {} | grep alive | "
            "awk -F '[][]' '{{print$2}}'".format(IRC_HOSTNAME),
            shell=True
        )
        return output.decode('utf-8').strip()


def attempt_send_irc_message(irc_host, message):
    s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM, 0)
    s.connect((irc_host, IRC_PORT))
    s.send("USER {0} {0} bla :{0}\n".format(socket.gethostname()).encode('utf-8'))
    time.sleep(1)
    s.send("NICK {}\n".format(socket.gethostname()).encode('utf-8'))
    time.sleep(1)
    s.send("JOIN {}\n".format(IRC_CHANNEL).encode('utf-8'))
    time.sleep(5)
    s.send(
        "PRIVMSG {} : {}\n".format(
            IRC_CHANNEL,
            message
        ).encode('utf-8')
    )


def main():
    parser = ArgumentParser(
        description='Log a message to the {} channel in '
                    'the simulacra IRC'.format(IRC_CHANNEL)
    )
    parser.add_argument('message', help="The message to send")
    args = parser.parse_args()

    irc_host = get_irc_host()
    if irc_host:
        attempt_send_irc_message(
            irc_host,
            args.message
        )


if __name__ == '__main__':
    main()
