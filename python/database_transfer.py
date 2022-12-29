from __future__ import annotations

from typing import Union

from sqlalchemy import MetaData, create_engine
from sqlalchemy.exc import ProgrammingError
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session


def table_from_db_to_db(
    conn_string_db_from: str,
    conn_string_db_to: str,
    table: str,
    schema_to: str,
    if_exist: Union[None, str] = None,
):
    """Function to copy table from one database to another database

    Args:
        conn_string_db_from (str): connection string "from" database
        conn_string_db_to (str): connection string "to" database
        table (str): table name
        schema_to (str): schema to which the table has to be written
        if_exist (Union[None, str], optional): Action in case of excisting table. Defaults to None.
    """
    engine_from = create_engine(conn_string_db_from)
    engine_to = create_engine(conn_string_db_to)

    print("Reflecting table")
    metadata_from = MetaData()
    metadata_from.reflect(engine_from, only=[table])
    Base = automap_base(metadata=metadata_from)
    table_meta = metadata_from.tables[table]
    Base_to = automap_base(metadata=Base.metadata)

    print("Querying table")
    with Session(engine_from) as s:
        rs = s.query(table_meta).all()
        rs = [row._asdict() for row in rs]

    print("Setting schema")
    Base_to.metadata.tables[table].schema = schema_to

    if if_exist == "drop":
        print("Dropping table")
        try:
            table_meta.drop(engine_to)
        except ProgrammingError as pe:
            print(f"Exception Caught: {pe}")

    print("Creating table")
    Base_to.metadata.create_all(engine_to)

    print("Writing table")
    with Session(engine_to) as s:
        s.execute(table_meta.insert(), rs)
        s.commit()


def query_as_dict(rs):
    result = []
    for idx, row in enumerate(rs):
        try:
            result.append(row._as_dict())
        except AttributeError:
            print(idx)
