from mock import Mock

from flows.simulacra.youtube_dl.factory import youtube_dl_flow_factory
from flows.simulacra.youtube_dl.post import download_videos
from tests.testcase import TestCase


class TestDownloadVideos(TestCase):
    def setUp(self):
        self.open = self.set_up_patch(
            'flows.simulacra.youtube_dl.post.open'
        )
        self.open.return_value.__exit__ = lambda a, b, c, d: None
        self.file_handle = Mock()
        self.file_handle.readlines.return_value = iter([
            'some_channel1',
            'some_other_channel2'
        ])
        self.open.return_value.__enter__ = lambda x: self.file_handle
        self.post_job = self.set_up_patch(
            'flows.simulacra.youtube_dl.post.post_job'
        )

    def test_download_videos_opens_channels_file(self):
        download_videos('/tmp/some_list_of_yt_channels.txt')

        self.open.assert_called_once_with(
            '/tmp/some_list_of_yt_channels.txt'
        )

    def test_download_videos_reads_lines_from_channels_file(self):
        download_videos('/tmp/some_list_of_yt_channels.txt')

        self.file_handle.readlines.assert_called_once_with()

    def test_download_videos_posts_job_to_download_yt_videos(self):
        download_videos('/tmp/some_list_of_yt_channels.txt')

        expected_channels = ['some_channel1', 'some_other_channel2']
        self.post_job.assert_called_once_with(
            youtube_dl_flow_factory,
            factory_args=[expected_channels]
        )
