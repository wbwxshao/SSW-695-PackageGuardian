"""SSW695_Gudian_of_Packages"""
import unittest
from server import getLatLng

@unittest.skip("need testing sample for lat_string and lng_string")
class TestGetLatLng(unittest.TestCase):
    """Unit test for function getLatLng()"""

    def test_getLatLng(self):
        """Test case"""
        lat_string = ''