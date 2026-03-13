# rkit

Personal collection of R utility functions for data analysis, visualization, and reporting.

## Usage

To load all functions:

```r
source("R/load_all.R")
```

To see all available functions:

```r
rk_show_functions()
```

## Modules

| File | Description |
|------|-------------|
| `table.R` | Styled Excel table output (`rk_table`, `rk_sheet`) |
| `colors.R` | Color palettes and ggplot2 color/fill scales (`rk_palettes`, `rk_scale_color`, `rk_scale_fill`) |
| `charts.R` | Bar chart functions (`rk_barchart`, `rk_stacked_bar_*`, `rk_grouped_bar_*`) |
| `ggtheme.R` | Custom ggplot2 themes (`rk_theme`, `rk_theme_map`) |
| `categorize.R` | Convert continuous variables to labeled categories (`rk_cut`) |
| `geolocate.R` | NL-wide PDOK geolocation (`rk_get_pdok_location`) |
| `lookups.R` | Amsterdam geo lookup tables (`rk_get_geo_json`, `rk_extract_name_code_table`) |
| `get_geoms.R` | Amsterdam geometry data (`rk_get_geom`) |

## Acknowledgement

This project is based on [tools-onderzoek-en-statistiek](https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek), originally developed by the Onderzoek en Statistiek (Research and Statistics) department of the City of Amsterdam.
