from unittest.mock import ANY
from tests.testcase import TestCase
from json import load

from scheduler.actions.transform_machines import place_config_on_machine


class TestPlaceConfigOnMachine(TestCase):
    def setUp(self):
        self.upload_file = self.set_up_patch(
            'scheduler.actions.transform_machines.'
            'upload_file'
        )
        self.upload_file.return_value = ('', 0)
        self.config = {'simulacra': {'redis': False}}

    def test_place_config_on_machine_writes_temp_config(self):
        def assert_config_matches(file_name, *_):
            with open(file_name, 'r') as stream:
                loaded_config = load(stream)
                self.assertDictEqual(loaded_config, self.config)
            return '', 0

        self.upload_file.side_effect = assert_config_matches
        place_config_on_machine('1.2.3.4', self.config)

    def test_place_config_on_machine_uploads_config(self):
        place_config_on_machine('1.2.3.4', self.config)

        self.upload_file.assert_called_once_with(
            ANY, '/etc/facter/facts.d/simulacra.json',
            '1.2.3.4'
        )
