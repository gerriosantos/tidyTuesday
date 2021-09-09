
basedosdados::set_billing_id('projeto-key-api-276002')

q <- "SELECT sigla_uf uf, data_aplicacao, COUNT(id_paciente) paciente
FROM `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao`
GROUP BY data_aplicacao, uf"

q1 <- "SELECT * FROM `basedosdados.br_ibge_populacao.uf`"

q2 <- "SELECT * FROM `basedosdados.br_bd_diretorios_brasil.uf`"

d <- basedosdados::read_sql(q) |>
  dplyr::mutate(paciente = as.numeric(paciente))

d1 <- basedosdados::read_sql(q1) |>
  dplyr::filter(ano == 2019) |>
  dplyr::select(uf = sigla_uf, pop = populacao) |>
  dplyr::mutate(pop = as.numeric(pop))

d2 <- basedosdados::read_sql(q2) |>
  dplyr::select(-id_uf, uf = sigla, n_uf = nome, regiao)

d3 <- dplyr::left_join(d, d1, by = 'uf') |>
  dplyr::left_join(d2, by = 'uf') |>
  dplyr::mutate(vac = round((paciente/pop)*100000, 2)) |>
  dplyr::relocate(n_uf:regiao, .before = paciente)

readr::write_rds(d3, 'data/vacinas.rds')



