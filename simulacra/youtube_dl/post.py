from flows.simulacra.youtube_dl.factory import youtube_dl_flow_factory
from jobrunner.post_job import post_job


def download_videos(channels_file, hierarchy=False):
    """
    Post a job to downloads the latest youtube videos of specified channels
    :param str channels_file: Path to a file containing a list of channels
    :param bool hierarchy: Print the execution graph
    of the flow that would be posted
    :return None:
    """
    with open(channels_file) as f:
        channels = [l.strip() for l in f.readlines()]

    post_job(
        youtube_dl_flow_factory,
        hierarchy=hierarchy,
        factory_args=[channels]
    )
