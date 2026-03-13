# rtoolsjk

Collection of R utility functions for data analysis, visualization, and reporting.

## Usage

To load all functions:

```r
source("R/load_all.R")
```

To see all available functions:

```r
show_functions()
```

## Modules

| File | Description |
|------|-------------|
| `db_configs.R` | Database connection helpers (PostgreSQL, Azure) |
| `table.R` | Styled Excel table output |
| `colors.R` | Color palettes and ggplot2 color/fill scales |
| `charts.R` | Bar chart functions (stacked, grouped, simple) |
| `ggtheme.R` | Custom ggplot2 themes |
| `categorize.R` | Convert continuous variables to labeled categories |
| `statistiek_hulpfuncties.R` | Chi-square tests and survey response helpers |
| `lookups.R` | Geographic lookup tables |
| `geolocate.R` | PDOK geolocation |
| `get_geoms.R` | Fetch Amsterdam geometry data |
| `vacature_tools.R` | Vacancy/job data import |

## Acknowledgement

This project is based on [tools-onderzoek-en-statistiek](https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek), originally developed by the Onderzoek en Statistiek (Research and Statistics) department of the City of Amsterdam. The original repository is licensed and maintained by that team.
