from flows.simulacra.youtube_dl.factory import youtube_dl_flow_factory
from jobrunner.post_job import post_job


def download_videos(channels_file):
    """
    Post a job to downloads the latest youtube videos of specified channels
    :param str channels_file: Path to a file containing a list of channels
    :return None:
    """
    with open(channels_file) as f:
        channels = [l.strip() for l in f.readlines()]

    post_job(
        youtube_dl_flow_factory,
        factory_args=[channels],
        store={'channels': channels}
    )
