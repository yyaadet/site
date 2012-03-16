from zuan.tests import *

class TestOrderController(TestController):

    def test_index(self):
        response = self.app.get(url(controller='order', action='index'))
        # Test response...
