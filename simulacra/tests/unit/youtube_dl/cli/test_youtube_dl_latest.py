from flows.simulacra.youtube_dl.cli import youtube_dl_latest
from tests.testcase import TestCase


class TestYoutubeDLLatest(TestCase):
    def setUp(self):
        self.parse_youtube_dl_arguments = self.set_up_patch(
            'flows.simulacra.youtube_dl.cli.parse_youtube_dl_arguments'
        )
        self.download_videos = self.set_up_patch(
            'flows.simulacra.youtube_dl.cli.download_videos'
        )

    def test_youtube_dl_latest_parses_youtube_dl_args(self):
        youtube_dl_latest()

        self.parse_youtube_dl_arguments.assert_called_once_with(
            args=None
        )

    def test_youtube_dl_latest_parses_specified_args(self):
        expected_args = ['these', '--are', 'some_args']

        youtube_dl_latest(args=expected_args)

        self.parse_youtube_dl_arguments.assert_called_once_with(
            args=expected_args
        )

    def test_youtube_dl_latest_runs_youtube_dl(self):
        youtube_dl_latest()

        parsed_arguments = self.parse_youtube_dl_arguments.return_value
        expected_channels_file = parsed_arguments.channels_file
        self.download_videos.assert_called_once_with(
            channels_file=expected_channels_file
        )
