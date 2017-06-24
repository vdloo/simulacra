from logging import getLogger
from taskflow.patterns import graph_flow as gf
from taskflow.retry import Times

from flows.simulacra.youtube_dl.tasks import DownloadVideos

log = getLogger(__name__)


def youtube_dl_flow_factory(channels):
    f = gf.Flow("youtube_dl_flow", retry=Times(3))
    for channel in channels:
        log.info("Adding dl task for {}".format(channel))
        f.add(
            DownloadVideos(
                "yt_dl_{}".format(channel),
                inject={'channel': channel}
            )
        )
    return f
