from unittest.mock import ANY

from scheduler.cli import parse_transform_arguments
from tests.testcase import TestCase


class TestTransformArguments(TestCase):
    def setUp(self):
        self.parse_arguments = self.set_up_patch(
            'scheduler.cli.parse_arguments'
        )
        self.argument_parser = self.set_up_patch(
            'scheduler.cli.ArgumentParser'
        )

    def test_parse_transform_arguments_instantiates_argparser(self):
        parse_transform_arguments()

        self.argument_parser.assert_called_once_with(
            description=ANY
        )

    def test_parse_transform_arguments_parses_arguments(self):
        parse_transform_arguments()

        self.parse_arguments.assert_called_once_with(
            self.argument_parser.return_value
        )

    def test_parse_transform_arguments_returns_parsed_arguments(self):
        ret = parse_transform_arguments()

        self.assertEqual(
            ret, self.parse_arguments.return_value
        )
