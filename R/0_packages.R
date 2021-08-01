
suppressPackageStartupMessages({

  # Data Import
  library(arrow)

  # Data Manipulation
  library(tidyverse)
  library(glue)
  library(magrittr)
  library(janitor)
  library(lubridate)
  library(hrbrthemes)
  # library(tantastic)
  # tantastic::fontimport_bai_jamjuree()
  # tantastic::fontimport_plex_condensed()

  # Shiny libraries
  library(shiny)
  library(shinyjs)
  library(bs4Dash)
  library(shinyWidgets)
  library(DT)
  # library(reactable)
  library(joker) # tanho63/joker
  library(sever)
  library(ggiraph)
  library(plotly)

  # Report libraries
  library(writexl)

  options(shiny.reactlog = TRUE)
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  options(dplyr.summarise.inform = FALSE)
  # extrafont::loadfonts()
})
