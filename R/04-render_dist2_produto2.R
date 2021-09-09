

#' Esse código deve renderizar o produto2.Rmd na pasta dist2, que
#' criará relatórios de gráficos estáticos das regiões do Brasil.
#'


reg <- c("Sudeste", "Nordeste", "Centro-Oeste", "Norte", "Sul")


purrr::map(
  .x = reg,
  .f = ~ rmarkdown::render(
    here::here('dist2', 'produto2.Rmd'),
    params = list(reg = .x),
    output_file = paste0(.x, '.html')
  )
)
