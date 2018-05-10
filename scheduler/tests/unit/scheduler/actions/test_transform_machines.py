from unittest.mock import call
from tests.testcase import TestCase

from scheduler.actions.transform_machines import transform_machines


class TestTransformMachines(TestCase):
    def setUp(self):
        self.list_machines = self.set_up_patch(
            'scheduler.actions.transform_machines.list_machines'
        )
        self.machines = [
            {
                'ID': 'f45dae53-0fcc-fb73-37d9-d55816420ab5',
                'Node': 'fc00:d4e0:31b6:0e19:a983:e335:4569:2b26',
                'Address': 'fc00:d4e0:31b6:e19:a983:e335:4569:2b26',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fc00:d4e0:31b6:e19:a983:e335:4569:2b26',
                    'wan': 'fc00:d4e0:31b6:e19:a983:e335:4569:2b26'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 49154, 'ModifyIndex': 64579
            },
            {
                'ID': '962c903e-f206-aa23-8c8d-0a80db121078',
                'Node': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357',
                'Address': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357',
                    'wan': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 72149, 'ModifyIndex': 72155
            },
            {
                'ID': '765104ce-8c88-9baa-2a29-6f7ee50f1719',
                'Node': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6',
                'Address': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6',
                    'wan': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 72929, 'ModifyIndex': 72931
            },
            {
                'ID': '757cf773-6d5d-6500-83a0-1010918b9809',
                'Node': 'fcdf:a62d:1b46:b898:761e:d753:04e5:07fd',
                'Address': 'fcdf:a62d:1b46:b898:761e:d753:4e5:7fd',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fcdf:a62d:1b46:b898:761e:d753:4e5:7fd',
                    'wan': 'fcdf:a62d:1b46:b898:761e:d753:4e5:7fd'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 53366, 'ModifyIndex': 53369
            }
        ]
        self.list_machines.return_value = self.machines
        self.run_configuration_management = self.set_up_patch(
            'scheduler.actions.transform_machines.run_configuration_management'
        )

    def test_transform_machines_lists_machines(self):
        transform_machines()

        self.list_machines.assert_called_once_with()

    def test_transform_machines_runs_config_management_on_all_machines(self):
        transform_machines()

        expected_calls = [call(m['Address']) for m in self.machines]
        self.assertCountEqual(
            expected_calls, self.run_configuration_management.mock_calls
        )

    def test_transform_machines_can_run_serially_if_specified(self):
        pool = self.set_up_patch(
            'scheduler.actions.transform_machines.ThreadPool'
        )

        transform_machines(concurrent=1)

        pool.assert_called_one_with(processes=1)

    def test_transform_machines_runs_concurrently_by_default(self):
        pool = self.set_up_patch(
            'scheduler.actions.transform_machines.ThreadPool'
        )

        transform_machines()

        pool.assert_called_one_with(processes=5)
