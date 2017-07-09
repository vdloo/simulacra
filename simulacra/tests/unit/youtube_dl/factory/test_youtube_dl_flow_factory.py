from flows.simulacra.youtube_dl.factory import youtube_dl_flow_factory
from jobrunner.utils import list_tasks_in_flow
from tests.testcase import TestCase


class TestYoutubeDLFlowFactory(TestCase):
    def setUp(self):
        self.channels = [
            'some_channel1',
            'some_other_channel2'
        ]

    def test_youtube_dl_flow_factory_creates_flow_with_name(self):
        flow = youtube_dl_flow_factory(self.channels)

        self.assertEqual(flow.name, 'youtube_dl_flow')

    def test_youtube_dl_flow_factory_has_correct_tasks(self):
        flow = youtube_dl_flow_factory(self.channels)

        expected_tasks = (
            'yt_dl_some_channel1',
            'yt_dl_some_other_channel2',
        )
        self.assertCountEqual(list_tasks_in_flow(flow), expected_tasks)

    def test_youtube_dl_flow_factory_is_retried(self):
        flow = youtube_dl_flow_factory(self.channels)

        self.assertEqual(flow.retry._attempts, 3)
