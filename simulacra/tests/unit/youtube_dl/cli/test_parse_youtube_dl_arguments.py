from mock import ANY

from flows.simulacra.youtube_dl.cli import parse_youtube_dl_arguments
from tests.testcase import TestCase


class TestParseYoutubeDLArguments(TestCase):
    def setUp(self):
        self.argument_parser = self.set_up_patch(
            'flows.simulacra.youtube_dl.cli.ArgumentParser'
        )
        self.parse_arguments = self.set_up_patch(
            'flows.simulacra.youtube_dl.cli.parse_arguments'
        )

    def test_parse_youtube_dl_arguments_instantiates_argparser(self):
        parse_youtube_dl_arguments()

        self.argument_parser.assert_called_once_with(
            prog='jobrunner post youtube_dl',
            description='Post a job that downloads videos from YouTube'
        )

    def test_parse_youtube_dl_arguments_adds_channels_file_argument(self):
        parse_youtube_dl_arguments()

        self.argument_parser.return_value.add_argument.assert_called_once_with(
            'channels_file',
            help=ANY
        )

    def test_parse_youtube_dl_arguments_parses_arguments(self):
        parse_youtube_dl_arguments()

        self.parse_arguments.assert_called_once_with(
            self.argument_parser.return_value, args=None
        )

    def test_parse_youtube_dl_arguments_parses_specified_arguments(self):
        expected_args = ['these', '--are', 'some_args']

        parse_youtube_dl_arguments(args=expected_args)

        self.parse_arguments.assert_called_once_with(
            self.argument_parser.return_value, args=expected_args
        )

    def test_parse_youtube_dl_arguments_returns_parsed_arguments(self):
        ret = parse_youtube_dl_arguments()

        self.assertEqual(
            ret, self.parse_arguments.return_value
        )
