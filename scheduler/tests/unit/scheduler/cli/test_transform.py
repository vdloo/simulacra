from unittest.mock import Mock
from scheduler.cli import transform
from tests.testcase import TestCase


class TestTransform(TestCase):
    def setUp(self):
        self.parse_transform_arguments = self.set_up_patch(
            'scheduler.cli.parse_transform_arguments'
        )
        self.args = Mock(
            concurrent=5
        )
        self.parse_transform_arguments.return_value = self.args
        self.transform_machines = self.set_up_patch(
            'scheduler.cli.transform_machines'
        )

    def test_parse_transform_parses_transform_arguments(self):
        transform()

        self.parse_transform_arguments.assert_called_once_with()

    def test_parse_transform_arguments_transforms_machines(self):
        transform()

        self.transform_machines.assert_called_once_with(
            concurrent=5
        )
