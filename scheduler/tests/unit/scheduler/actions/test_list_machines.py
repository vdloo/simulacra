from unittest.mock import Mock
from tests.testcase import TestCase

from scheduler.actions.transform_machines import list_machines


class TestListMachines(TestCase):
    def setUp(self):
        self.request = self.set_up_patch(
            'scheduler.actions.transform_machines.Request'
        )
        self.urlopen = self.set_up_patch(
            'scheduler.actions.transform_machines.urlopen'
        )
        self.urlopen.return_value.__exit__ = lambda a, b, c, d: None
        self.req_handle = Mock()
        self.resp = b'[{"ID":"f45dae53-0fcc-fb73-37d9-d55816420ab5",' \
                    b'"Node":"fc00:d4e0:31b6:0e19:a983:e335:4569:2b26",' \
                    b'"Address":"fc00:d4e0:31b6:e19:a983:e335:4569:2b26",' \
                    b'"Datacenter":"raptiformica","TaggedAddresses":{"lan":' \
                    b'"fc00:d4e0:31b6:e19:a983:e335:4569:2b26","wan":' \
                    b'"fc00:d4e0:31b6:e19:a983:e335:4569:2b26"},"Meta":' \
                    b'{"consul-network-segment":""},"CreateIndex":49154,' \
                    b'"ModifyIndex":64579},{"ID":' \
                    b'"962c903e-f206-aa23-8c8d-0a80db121078","Node":' \
                    b'"fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357","Address":' \
                    b'"fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357","Datacenter":' \
                    b'"raptiformica","TaggedAddresses":{"lan":' \
                    b'"fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357","wan":' \
                    b'"fc03:cced:19b5:7c78:b7e5:520d:b7e3:1357"},"Meta":' \
                    b'{"consul-network-segment":""},"CreateIndex":72149,' \
                    b'"ModifyIndex":72155},{"ID":' \
                    b'"765104ce-8c88-9baa-2a29-6f7ee50f1719","Node":' \
                    b'"fc9f:34ec:b491:293e:edb3:a890:b239:b6d6",' \
                    b'"Address":"fc9f:34ec:b491:293e:edb3:a890:b239:b6d6",' \
                    b'"Datacenter":"raptiformica","TaggedAddresses":{"lan":' \
                    b'"fc9f:34ec:b491:293e:edb3:a890:b239:b6d6","wan":' \
                    b'"fc9f:34ec:b491:293e:edb3:a890:b239:b6d6"},"Meta":' \
                    b'{"consul-network-segment":""},"CreateIndex":72929,' \
                    b'"ModifyIndex":72931},{"ID":' \
                    b'"757cf773-6d5d-6500-83a0-1010918b9809","Node":' \
                    b'"fcdf:a62d:1b46:b898:761e:d753:04e5:07fd","Address":' \
                    b'"fcdf:a62d:1b46:b898:761e:d753:4e5:7fd","Datacenter":' \
                    b'"raptiformica","TaggedAddresses":{"lan":' \
                    b'"fcdf:a62d:1b46:b898:761e:d753:4e5:7fd","wan":' \
                    b'"fcdf:a62d:1b46:b898:761e:d753:4e5:7fd"},"Meta":' \
                    b'{"consul-network-segment":""},"CreateIndex":53366,' \
                    b'"ModifyIndex":53369}]'.decode('utf-8')
        self.req_handle.read.return_value = self.resp

        self.urlopen.return_value.__enter__ = lambda x: self.req_handle

    def test_list_machines_instantiates_urllib_request(self):
        list_machines()

        self.request.assert_called_once_with(
            'http://localhost:8500/v1/catalog/nodes'
        )

    def test_list_machines_opens_request(self):
        list_machines()

        self.urlopen.assert_called_once_with(
            self.request.return_value
        )

    def test_list_machines_reads_request_handle(self):
        list_machines()

        self.req_handle.read.assert_called_one_with()

    def test_list_machines_returns_list_of_machines(self):
        ret = list_machines()

        expected_machines = [
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
        self.assertEqual(expected_machines, ret)
