library(tidyverse)
library(rvest)
library(stringi)

html <- read_html("http://fontawesome.io/cheatsheet/")
lines <- html %>%
  html_nodes( ".col-print-4") %>%
  html_text() %>%
  str_replace_all("\\n", "")

icons <- tibble(
  name = lines %>% str_extract("fa-[a-zA-Z0-9\\-]+") %>% str_replace("fa-", ""),
  version = lines %>% str_extract("4[.][[:digit:]]") %>% as.numeric(),
  unicode = lines %>% str_replace("^.*\\[&#x(.+);\\].*$", "\\1"),
  rune    = paste0("U+", str_to_upper(unicode))
) %>%
  mutate( unicode = strtoi(unicode, base = 16) %>% stri_enc_fromutf32() ) %>%
  select( name, rune, version, unicode )

use_data( icons, overwrite = TRUE )
