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
                'ID': '962c903e-f206-aa23-8c8d-0a80db121078',
                'Node': 'cloud1',
                'Address': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357',
                    'wan': 'fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 29511,
                'ModifyIndex': 29528},
            {
                'ID': '757cf773-6d5d-6500-83a0-1010918b9809',
                'Node': 'cloud2',
                'Address': 'fcdf:a62d:1b46:b898:761e:d753:4e5:7fd',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fcdf:a62d:1b46:b898:761e:d753:4e5:7fd',
                    'wan': 'fcdf:a62d:1b46:b898:761e:d753:4e5:7fd'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 6,
                'ModifyIndex': 35
            },
            {
                'ID': '765104ce-8c88-9baa-2a29-6f7ee50f1719',
                'Node': 'host4',
                'Address': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6',
                    'wan': 'fc9f:34ec:b491:293e:edb3:a890:b239:b6d6'
                }, 'Meta': {'consul-network-segment': ''},
                'CreateIndex': 200,
                'ModifyIndex': 202
            },
            {
                'ID': 'f45dae53-0fcc-fb73-37d9-d55816420ab5',
                'Node': 'retropie',
                'Address': 'fc00:d4e0:31b6:e19:a983:e335:4569:2b26',
                'Datacenter': 'raptiformica',
                'TaggedAddresses': {
                    'lan': 'fc00:d4e0:31b6:e19:a983:e335:4569:2b26',
                    'wan': 'fc00:d4e0:31b6:e19:a983:e335:4569:2b26'
                },
                'Meta': {'consul-network-segment': ''},
                'CreateIndex': 182,
                'ModifyIndex': 185
            }
        ]
        self.list_machines.return_value = self.machines
        self.transform_machine = self.set_up_patch(
            'scheduler.actions.transform_machines.transform_machine'
        )
        self.generate_config_for_machines = self.set_up_patch(
            'scheduler.actions.transform_machines.generate_config_for_machines'
        )
        self.generate_config_for_machines.side_effect = lambda ms: [
            {'simulacra': {'redis': m['Node'] == 'retropie'}} for m in ms
        ]

    def test_transform_machines_lists_machines(self):
        transform_machines()

        self.list_machines.assert_called_once_with()

    def test_transform_machines_generates_configs_for_all_machines(self):
        transform_machines()

        self.generate_config_for_machines.assert_called_once_with(
            self.machines
        )

    def test_transform_machines_transforms_all_machines(self):
        transform_machines()

        expected_calls = [
            call(
                m['Address'],
                {'simulacra': {'redis': m['Node'] == 'retropie'}}
            ) for m in self.machines
        ]
        self.assertCountEqual(
            expected_calls, self.transform_machine.mock_calls
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
