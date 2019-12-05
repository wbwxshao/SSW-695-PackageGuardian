"""SSW695_Gudian_of_Packages"""

import unittest
from server import calculateDistance

class TestCalculationDistance(unittest.TestCase):
    """unit test for function calculationDistance"""

    def test_calculationDistance(self):
        """test case 1"""
        self.assertEqual(calculateDistance(40.7448, -74.0256), 0)

if __name__ == '__main__':
    unittest.main(exit = False, verbosity = 2)
