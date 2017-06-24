from logging import getLogger

from subprocess import check_call
from taskflow.task import Task

log = getLogger(__name__)


class DownloadVideos(Task):
    def execute(self, channel):
        log.info(
            "Downloading latest videos from "
            "configured channel {}".format(channel)
        )
        check_call(
            "youtube-dl --verbose -citw ytuser:{} "
            "--max-downloads 5".format(channel),
            shell=True
        )
