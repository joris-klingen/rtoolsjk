from __future__ import annotations

from typing import Union, Any

import requests


def get_geo_json(
    level: str, year: Union[int, Any], with_water: bool = False
) -> dict[str, str]:
    """_summary_

    Args:
        level (str): 'stadsdelen'/'gebieden'/'wijken'/'buurten'
        year (int): jaar

    Returns:
        dict[str, str]: geo json containg of the desired level and year
    """
    base_url = "https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/main/geo/amsterdam/"

    if year <= 2020:
        year = "2015-2020"

    if with_water:
        url = f"{base_url}/{year}/{level}-{year}-geo.json"
    else:
        url = f"{base_url}/{year}/{level}-{year}-zw-geo.json"

    r = requests.get(url).json()
    return r


def extract_name_code_table(geo_json: dict[str, str]) -> dict[str, str]:
    """_summary_

    Args:
        geo_json (dict[str, str]): geo_json of a specific level and year

    Returns:
        dict[str, str]: dictionary containing the mapping 'naam': 'year'
    """
    naam_code = {}
    f: Any  # Add explicit type hint for complex dict structure
    for f in geo_json["features"]:
        properties = f.get("properties")
        naam_code[properties["naam"]] = properties["code"]
    return naam_code


def get_geo_name_code(level: str, year: int) -> dict[str, str]:
    """_summary_

    Args:
        level (str): 'stadsdelen'/'gebieden'/'wijken'/'buurten'
        year (int): jaar

    Returns:
        dict[str, str]: _description_
    """
    json = get_geo_json(level=level, year=year)
    name_code = extract_name_code_table(json)
    return name_code


if __name__ == "__main__":
    json = get_geo_json(level="stadsdelen", year=2022)
    print(json)

    code_name = get_geo_name_code("stadsdelen", 2018)
    print(code_name)
