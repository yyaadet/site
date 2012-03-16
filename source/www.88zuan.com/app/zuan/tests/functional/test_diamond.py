from zuan.tests import *

class TestDiamondController(TestController):

    def test_index(self):
        response = self.app.get(url(controller='diamond', action='index'))
        # Test response...
