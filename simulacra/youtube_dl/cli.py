from flows.builtin.helpers.parser import flow_parser
from flows.simulacra.youtube_dl.post import download_videos
from jobrunner.cli.parse import parse_arguments
from jobrunner.plugins import register_job


def parse_youtube_dl_arguments(args=None):
    """
    Parse the commandline options for posting a job that
    downloads videos from YouTube to the local disk of the
    conductor running the flow
    :param list args: Args to pass to the arg parser.
    Will use argv if none specified.
    :return obj args: parsed arguments
    """
    parser = flow_parser(
        prog="jobrunner post youtube_dl",
        description='Post a job that downloads videos from YouTube'
    )
    parser.add_argument(
        'channels_file',
        help="Path to a file containing a list of channels to "
             "download the videos of"
    )
    return parse_arguments(parser, args=args)


@register_job()
def youtube_dl_latest(args=None):
    """
    Post a job that downloads the latest youtube videos of a list
    of channels provided as an argument.
    :param list args: Args to pass to the arg parser.
    Will use argv if none specified.
    :return None:
    """
    args = parse_youtube_dl_arguments(args=args)
    download_videos(channels_file=args.channels_file, hierarchy=args.hierarchy)
