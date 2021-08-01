pkgload::load_all()

sfb_picks <- readRDS("data/df_adp.rds") %>% mutate_at("player_name", ffscrapr::dp_clean_names)
sfb_teams <- readRDS("data/sfb_teams.rds")
pca_juice <- readRDS("data/pca_juice.rds")
pca_desc <- readRDS("data/pca_descriptions.rds")
pca_dist <- readRDS("data/pca_dist.rds") %>% mutate_at("franchise_name", as.character)

ui <- dashboardPage(
  dark = NULL,
  title = glue("DynastyProcess Apps: {pkgload::pkg_name()} v{pkgload::pkg_version()}"),
  header = dp_header(glue("{pkgload::pkg_name()} v{pkgload::pkg_version()}"), debug = TRUE),
  sidebar = dp_sidebar(
    sidebarMenu(
      menuItem("Similarity Scores", tabName = "main", icon = icon("quidditch")),
      hr(),
      menuItem("More by DynastyProcess",href = "https://dynastyprocess.com", icon = icon("rocket")),
      menuItem("Follow on Twitter", href = "https://twitter.com/_tanho", icon = icon("twitter"))
    )),
  body = dashboardBody(
    shinyjs::useShinyjs(),
    use_sever(),
    dp_cssjs(),
    tabItems(
      tabItem(
        tabName = "main",
        fluidRow(
          column(
            width = 4,
            box(
              title = "Select a Team!",
              solidHeader = TRUE,
              status = "danger",
              width = 12,
              pickerInput("franchise_name","Franchise",
                          choices = sfb_teams,
                          selected = sample(sfb_teams,1),
                          width = '100%',
                          options = list(
                            `live-search` = TRUE,
                            `size` = 10
                          )),
              actionButton("load_franchise",
                           label = "Load Similarity Scores",
                           width = '100%',
                           class = 'btn-success'),
              br(),
              br(),
              uiOutput("strategy_statement"),
              br(),
              uiOutput("comparison_picker")
            )
          ),
          br(),
          column(8,uiOutput('similarity_scores')),
        ),
        uiOutput("pca_plot"),
        br(),
        fluidRow(uiOutput("team_tables"))
      )
    )
  ) # end of body ----
) # end of UI ----

# Server ----
server <- function(input, output, session) {
  
  #### FUNCTION LOAD ####
  
  sever_dp()
  
  observeEvent(input$debug, browser())
  
  ####
  
  user <- eventReactive(input$load_franchise, {
    input$franchise_name
  })
  
  comparisons <- reactive({
    req(input$comparison_1,input$comparison_2)
    unique(c(input$comparison_1,input$comparison_2))
    
  })
  
  output$dt_teams <- renderDT({
    get_teamrosters(sfb_picks, user(), comparisons()) %>%
      datatable_myteam(user(),comparisons())
  })
  
  output$team_tables <- renderUI({
    
    req(user(), comparisons())
    
    box(title = "Roster Comparisons",
        status = "danger",
        maximizable = TRUE,
        width = 12,
        DTOutput("dt_teams"))
  })
  
  output$comparison_picker <- renderUI({
    
    req(simscores_player(),simscores_strategy())
    
    generate_comparisoninputs(simscores_strategy(), simscores_player())
    
  })
  
  simscores_player <- reactive({
    req(user())
    calculate_playersims(sfb_picks, user())
  })
  
  output$dt_simscore_players <- renderDT({
    simscores_player() %>%
      datatable_playersims()
  })
  
  simscores_strategy <- reactive({
    calculate_strategysims(pca_dist, user())
  })
  
  output$dt_simscore_strategies <- renderDT({
    simscores_strategy() %>%
      datatable_playersims()
  })
  
  user_strategy <- reactive({
    calculate_strategy(pca_juice,
                       user(),
                       pca_desc)
  })
  
  pca_data <- reactive({
    
    calculate_pcatable(pca_juice,pca_desc,user(),comparisons())
    
  })
  
  output$pca_plotly <- renderPlotly({
    
    generate_pcachart(pca_data())
    
  })
  
  output$pca_plot <- renderUI({
    
    req(user())
    
    fluidRow(
      box(title = "Strategy Comparison",
          status = "danger",
          maximizable = TRUE,
          width = 12,
          solidHeader = TRUE,
          plotlyOutput('pca_plotly')
      ))
  })
  
  output$strategy_statement <- renderUI({
    
    req(user())
    HTML(user_strategy())
  })
  
  output$similarity_scores <- renderUI({
    
    req(user())
    
    fluidRow(
      column(
        width = 6,
        box(
          title = "Similarity Scores: Strategies",
          status = "danger",
          solidHeader = TRUE,
          maximizable = TRUE,
          closable = FALSE,
          width = 12,
          DTOutput("dt_simscore_strategies")
        )
      ),
      column(
        width = 6,
        box(
          title = "Similarity Scores: Players",
          status = "danger",
          maximizable = TRUE,
          closable = FALSE,
          solidHeader = TRUE,
          width = 12,
          DTOutput("dt_simscore_players")
        )
      )
    )
  })
  
} # end of server ####

shinyApp(ui, server)
