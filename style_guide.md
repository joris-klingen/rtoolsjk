## Style guide R

We broadly follow the [Tidyverse Style Guide](https://style.tidyverse.org/). Tidyverse packages (ggplot2, dplyr, purrr, forcats, etc.) are preferred over base R equivalents for their consistent syntax and interoperability.

### R script outline

Start with some information about the script:
```
# Script name
# Project number and name
# Month Year
# Purpose of the script, e.g. 'generate tables' or 'merge dataset 1 and dataset 2'
```
Load the relevant packages and rkit tools. If you write many functions, consider putting them in a separate script and loading it with `source()`.
```
# load packages ----
library(tidyverse)
library(haven)   # for loading SPSS files
library(readxl)  # for loading Excel files
source('R/load_all.R')
```
Load the relevant dataframe(s). Use an .Rproj file to open the project in RStudio. Make sure all paths work relative to the project file.
```
# load data ----
read_spss(PATH)
```
Divide the script into clear sections. For long scripts, consider adding an outline at the top.

### General

Use one consistent naming convention within a script, e.g.: `with_underscores`, `WithCamelCase`, or `with.dots`.

When writing a function, include a brief explanation of its purpose, inputs, and outputs:
```
my_function <- function(input, optional = TRUE){
    # what the function does
    # input       type, explanation
    # optional    type, explanation
}
```
