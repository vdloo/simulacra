from tests.testcase import TestCase

from scheduler.actions.transform_machines import run_configuration_management


class TestRunConfigurationManagement(TestCase):
    def setUp(self):
        self.run_remote_command = self.set_up_patch(
            'scheduler.actions.transform_machines.'
            'run_remote_command'
        )
        self.run_remote_command.return_value = ('', 0)

    def test_run_configuration_management_runs_configuration_management(self):
        run_configuration_management('1.2.3.4')

        expected_command = [
            '/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/papply.sh',
            '/root/.raptiformica.d/modules/simulacra/puppetfiles/provisioning/manifests/headless.pp'
        ]
        self.run_remote_command.assert_called_once_with(
            expected_command, '1.2.3.4'
        )
