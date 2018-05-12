from tests.testcase import TestCase

from scheduler.actions.transform_machines import transform_machine


class TestTransformMachine(TestCase):
    def setUp(self):
        self.ensure_config_directory_exists = self.set_up_patch(
            'scheduler.actions.transform_machines.'
            'ensure_config_directory_exists'
        )
        self.place_config_on_machine = self.set_up_patch(
            'scheduler.actions.transform_machines.'
            'place_config_on_machine'
        )
        self.run_configuration_management = self.set_up_patch(
            'scheduler.actions.transform_machines.'
            'run_configuration_management'
        )
        self.config = {'simulacra': {'redis': False}}

    def test_transform_machine_ensures_config_directory_exists(self):
        transform_machine('1.2.3.4', self.config)

        self.ensure_config_directory_exists.assert_called_once_with(
            '1.2.3.4'
        )

    def test_transform_machine_places_config_on_machine(self):
        transform_machine('1.2.3.4', self.config)

        self.place_config_on_machine.assert_called_once_with(
            '1.2.3.4', self.config
        )

    def test_transform_machine_runs_configuration_management_on_host(self):
        transform_machine('1.2.3.4', self.config)

        self.run_configuration_management.assert_called_once_with(
            '1.2.3.4'
        )
