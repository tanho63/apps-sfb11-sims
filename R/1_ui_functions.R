dp_header <- function(header, debug) {
  if(debug)(debug_button <- actionButton("debug","debug"))
  if(!debug)(debug_button <- shinyjs::hidden(actionButton("debug","debug")))
  
  bs4Dash::dashboardHeader(
    fixed = TRUE,
    border = TRUE,
    title = dashboardBrand(
      title = "DynastyProcess",
      color = "gray-dark",
      href = "https://dynastyprocess.com",
      image = "https://raw.githubusercontent.com/dynastyprocess/graphics/main/.dynastyprocess/logohexonly.png"),
    header,
    debug_button
  )
}

dp_sidebar <- function(...) {

  bs4Dash::dashboardSidebar(
    skin = "dark",
    width = 250,
    fixed = TRUE,
    elevation = 3,
    collapsed = TRUE,
    opacity = 0.8,
    expand_on_hover = TRUE,
    br(),
    ...,
    br()
  )
}

dp_cssjs <- function() {
  tags$head(
    tags$style(
      includeHTML("dp.css")
      )
    )
}

sever_dp <- function() {
  sever(
    tagList(
      h1("Disconnected"),
      em(joker::dadjoke()),
      br(),
      shiny::tags$button(
        "Reload",
        style = "color:#000;background-color:#fff;",
        class = "button",
        onClick = "location.reload();"
      )
    ),
    bg_color = "#000"
  )
}

dp_errorhandler <- function(app_state, e, title = "Oh no, we've hit an error!") {
  showModal(modalDialog(title = title, e$message))
  app_state$error <- "ERROR"
}

