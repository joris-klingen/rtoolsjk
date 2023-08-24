import geopandas as gpd
import pandas as pd
import numpy as np
import contextily as cx

import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib import rc
import matplotlib as mpl
import matplotlib.patches as patches
import matplotlib.colors as colors
import matplotlib.cm as cmx

from geo import get_geo_json 

def custom_patches(color_map: dict) -> list:
    """Rechthoekjes ipv van bolletjes bij kaartjes

    Args:
        color_map (dict]): Dictionary met de kaartjes per categorie

    Returns:
        (list): Lijst met custom patches voor de legenda
    """
    patch_lst = []
    for k, color in color_map.items():
        patch_lst.append(
            patches.Patch(
                facecolor=color, label=k, alpha=0.9, linewidth=1, edgecolor="#BEBEBE"
            )
        )
    return patch_lst


def plot_map(
    df: gpd.GeoDataFrame,
    col: str,
    cmap: dict,
    stadsdeel: str = None,
    stadsdeel_col: str = 'stadsdeelCode',
    path = None,
    legend_loc: str ='lower left',
    with_water: bool =True,
    shift: list = [0.3, 0.1]
):
    """Functie om kaarten te maken (met achtergrondkaart) van dataset met buurten/wijken/stadsdelen 
    met categorieen. Indien een stadsdeelcode wordt opgegeven wordt alleen van het betreffende stadsdeel
    een kaart gemaakt.

    Args:
        df (gpd.GeoDataFrame): df met buurten/wijken/stadsdelen met bijbehorende waarde/categorie
        col (str): Kolom met waarde/categorie 
        cmap (dict): Dict met categorieen en bijbehorende kleuren
        
        stadsdeel (str, optional): Stadsdeelcode. Defaults to None.
        stadsdeel_col (str, optional): Kolomnaam van kolom met stadsdeelcodes. Defaults to 'stadsdeelCode'.
        path (_type_, optional): Pad naar figuur. Defaults to None.
        legend_loc (str, optional): Locatie van legenda. Defaults to 'lower left'.
        with_water (bool, optional): Wel of geen water bij stadsdelen. Defaults to True.
        shift (list, optional): Shift van figuur zodat legenda passend gemaakt kan worden. Defaults to [0.3, 0.1].
    """

    mpl.rcParams["font.family"] = ["corbel"]
    mpl.rcParams["font.size"] = 11

    fig, ax = plt.subplots(figsize=(10, 6))

    if stadsdeel:

        # Filter data
        df = df[df[stadsdeel_col] == stadsdeel]

        # Load stadsdelen
        stadsdelen_geojson = get_geo_json(level='stadsdelen', year=2022, with_water=with_water)
        stadsdelen_shapes = gpd.GeoDataFrame.from_features(stadsdelen_geojson, crs='EPSG:4326').to_crs('EPSG:28992')

        # Plot outline around stadsdeel
        stadsdelen_shapes = stadsdelen_shapes[stadsdelen_shapes['code'] == stadsdeel]
        stadsdelen_shapes.plot(ax=ax, color="none", edgecolor="#C0C0C0", linewidth=2, zorder=2)

        # Increase bounding box of ax for legend
        minx, miny, maxx, maxy = df.total_bounds
        ax.set_xlim(minx - (maxx-minx) * shift[0], None)
        ax.set_ylim(miny - (maxy-miny) * shift[1], None)

    # Plot data
    df.plot(
        column=col,
        categorical=True,
        legend=True,
        ax=ax,
        cmap=ListedColormap(cmap.values()), 
        edgecolor="dimgray",
        linewidth=0.2,
        zorder=1
    )

    # Add legend
    patch_lst = custom_patches(cmap)
    leg = ax.legend(handles=patch_lst, loc=legend_loc)
    leg.get_frame().set_edgecolor("none")    
    
    # Add basemap
    cx.add_basemap(ax, crs=df.crs, source=cx.providers.Esri.WorldGrayCanvas, attribution='')

    # Some layout stuff
    ax.set_axis_off()
    plt.tight_layout()

    if path:
        plt.savefig(path)

    plt.show()


def map_labels(df: pd.DataFrame, cat_map: dict, cols: list = None) -> pd.DataFrame:
    """Map de categorieen op de values (b.v. 1 -> minder dan gemiddeld)

    Args:
        df (pd.DataFrame): Dataset
        cat_map (dict): Vertaling van de categorieen (int) naar de uiteindelijke categorieen (str)
        cols (list, optional): Kolommen die gemapt moeten worden. Defaults to None.

    Returns:
        pd.DataFrame: [description]
    """
    if not cols:
        cols = df.columns

    for col in cols:
        df[col] = df[col].map(cat_map)
        df[col] = pd.Categorical(
            df[col], categories=list(cat_map.values()), ordered=True
        )

    return df