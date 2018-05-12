from tests.testcase import TestCase

from scheduler.actions.transform_machines import ensure_config_directory_exists


class TestEnsureConfigDirectoryExists(TestCase):
    def setUp(self):
        self.run_remote_command = self.set_up_patch(
            'scheduler.actions.transform_machines.'
            'run_remote_command'
        )
        self.run_remote_command.return_value = ('', 0)

    def test_ensure_config_directory_exists_creates_config_directory(self):
        ensure_config_directory_exists('1.2.3.4')

        expected_command = ['mkdir', '-p', '/etc/facter/facts.d']
        self.run_remote_command.assert_called_once_with(
            expected_command, '1.2.3.4'
        )
