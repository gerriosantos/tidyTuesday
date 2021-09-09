
library(tidyverse)
library(gganimate)
library(gifski)
library(ggimage)

#' Gráfico em gif -- será usado somente a imagem gif salva na pasta
#' dist, pois, o gganimate é bem demorado.
#'

dados <- readr::read_rds('data/vacinas.rds') |>
  dplyr::filter(data_aplicacao >= '2021-01-17')

gr1 <- dados |> group_by(data_aplicacao, regiao) |>
  summarise(across(paciente:pop, ~ sum(.x)), .groups = 'drop') |>
  mutate(pac_pop = round((paciente/pop)*100000, 2)) |>
  arrange(data_aplicacao) |>
  ggplot(aes(x = data_aplicacao,
             y = paciente, group = regiao, color = regiao)) +
  geom_line()+
  geom_image(image='dist/giphy.gif', size = 0.08)+
  geom_segment(aes(xend = max(data_aplicacao),
                   yend = paciente), linetype = 2, colour = 'grey') +
  geom_text(aes(x = as.Date('2021-08-10'), label = regiao), hjust = 0)+
  #geom_point(size = 2) +
  theme_minimal()+
  scale_y_continuous(n.breaks = 12)+
  scale_x_date(date_breaks = '30 day',
               labels = \(x) stringr::str_to_title(format( x, '%b-%d')))+
  theme(text = element_text(family="Times New Roman", color="black",
                            size=12, face="bold"),
        legend.position = 'none',
        panel.grid = element_line(colour = 'lightgray'),
        #plot.background = element_rect(fill = "#111111")
  )+
  labs(title = 'Vacinação nas Regiões do Brasil',
       subtitle = 'Quantidade Total de Pacientes Vacinados',
       x = '', y = '',
       caption = '@gerriosantos',
       tag = '', fill = '')+
  #facet_wrap(~ regiao)+
  transition_reveal(data_aplicacao)+
  coord_cartesian(clip = 'off')

      # Salvando em gif

#anim_save(animation = gr1, filename = 'dist/gr1.gif')



# Renderizando (dar pra fazer mp4)
# animate(plot = gr1,
#         renderer = ffmpeg_renderer())







