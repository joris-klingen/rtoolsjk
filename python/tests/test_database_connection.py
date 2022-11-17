import unittest

from database_connection import (
    get_db_connection_strings,
    build_conn_string,
    get_pw_from_keyring,
    DbStringCollection,
)


class TestDatabaseConnection(unittest.TestCase):
    def test_build_conn_string(self):
        ...


if __name__ == "__main__":
    unittest.main()
