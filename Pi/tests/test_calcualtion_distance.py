"""SSW695_Gudian_of_Packages"""
LAT = 40.7448
LOG = 74.0256

import unittest
from server import calculateDistance

class TestCalculationDistance(unittest.TestCase):
    """unit test for function calculationDistance"""

    def test_calculationDistance(self):
        """test case 1"""
        self.assertEqual(calculateDistance(40.7448, 74.0256), "The distance between current location and *** is 0 m. ")

if __name__ == '__main__':
    unittest.main(exit = False, verbosity = 2)
