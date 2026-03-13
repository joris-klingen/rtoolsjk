## mappenstructuur

Onderstaande structuur geeft richtlijn voor de mappen in een onderzoeksproject.

```
├── data
│   ├── interim        <- tussentijdse data, bijvoorbeeld in RDS, parquet, etc
│   ├── processed      <- opgeschoonde data voor output of analyse
│   └── raw            <- ruwe data, meestal van externe bronnen, bijv in csv
│
├── notebooks          <- Jupyter notebooks en evt. R markdown scripts
│
├── references         <- opzoektabellen, hercoderingen etc
│
├── reports            <- output
│   ├── tables         <- tabellen voor in rapporten etc, meestal in huisstijl
│   └── figures        <- grafieken in huisstijl
│
├── src                <- scripts (.py, .R, .sql etc) eventueel in submappen
│   └── [project_init] <- script met packages, projectparameters, bijv __init__.py of project_init.R
│
├── requirements.txt   <- voor projecten in python
│
├── project.Rproj      <- voor projecten in R
│


```
