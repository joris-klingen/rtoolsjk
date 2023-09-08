## OS style guide Python


## OS style guide R

We volgen in grote lijnen de Tidyverse Style guide. Bij de tidyverse horen een aantal packages, zoals ggplot2, dplyr, purrr en forcats. De functies binnen deze packages hebben de voorkeur boven vergelijkbare functies in base R, omdat ze goed met elkaar samenwerken en een overzichtelijke syntax hebben.

### Outline van een R script

Begin met wat informatie over het script:
```
# Scriptnaam
# Projectnummer en -naam
# maand jaar
# Auteurs?
# Doel van het script, bijv. 'uitdraaien tabellen' of 'samenvoegen dataset 1 en dataset 2'
```
Laad de relevante packages en de O&S tools in. Als je veel functies in je script schrijft, kun je ervoor kiezen deze in een apart script te zetten en dat script hier in te laden met `source()`.
```
# load packages ----------------------------------------------
libary(tidyverse)
library(haven)  # handig om spss files in te laden
library(readxl) # handig om excel files in te laden
source('http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R')
```
Laad de relevante dataframe(s). In de projectmap staat een .Rproj file waarvanuit je het project in R kan openen. Zorg dat alle paths werken vanaf het project bestand. Dit werkt (nog) niet in de Nieuwe ADW - Rstudio wordt langzaam als je vanuit een Rproject werkt. In dat geval kun je .. gebruiken.
```
# load data --------------------------------------------------
read_spss(PATH)
```
Deel het script overzichtelijk in. Als het lang is kun je overwegen een outline bovenaan bij 'doel van het script' te zetten.

### Algemeen
Het is aanbevolen om één naming convention aan te houden binnen een script, bijvoorbeeld: met_streepjes, MetHoofdLetters, of met.punten.tussen.de.woorden. 

Als je een functie schrijft, geef dan een korte uitleg van de functie, input en output in een comment:
```
mooie_functie <- function(input, optioneel = TRUE){
    # uitleg wat de functie doet. 
    # input                 type, uitleg
    # optioneel             type, uitleg 
}
```