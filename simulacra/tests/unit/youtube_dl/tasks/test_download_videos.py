from mock import ANY

from flows.simulacra.youtube_dl.tasks import DownloadVideos
from tests.testcase import TestCase


class TestDownloadVideosExecute(TestCase):
    def setUp(self):
        self.log = self.set_up_patch(
            'flows.simulacra.youtube_dl.tasks.log'
        )
        self.check_call = self.set_up_patch(
            'flows.simulacra.youtube_dl.tasks.check_call'
        )
        self.task = DownloadVideos()

    def test_download_videos_logs_info_message(self):
        self.task.execute(channel='some_youtube_channel')

        self.log.info.assert_called_once_with(ANY)

    def test_download_videos_runs_youtube_dl_to_download_videos_from_the_channel(self):
        self.task.execute(channel='some_youtube_channel')

        expected_command = "youtube-dl --verbose -citw " \
                           "ytuser:some_youtube_channel " \
                           "--max-downloads 5"
        self.check_call.assert_called_once_with(
            expected_command, shell=True
        )

    def test_download_videos_returns_nothing(self):
        ret = self.task.execute(channel='some_youtube_channel')

        self.assertIsNone(ret)
