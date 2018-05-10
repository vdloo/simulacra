from unittest import TestCase, mock


class TestCase(TestCase):
    def set_up_patch(self, patch_target, mock_target=None, **kwargs):
        patcher = mock.patch(patch_target, mock_target or mock.Mock(**kwargs))
        self.addCleanup(patcher.stop)
        return patcher.start()
