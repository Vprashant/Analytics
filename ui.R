library(shinydashboard)
library(plotly)
library(DT)
library(shinyjs)
library(shinyHeatmaply)



ui <- dashboardPage(
  dashboardHeader(title = "NIMS-Analytics"),
  dashboardSidebar( sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    radioButtons("typeInput", "Extract Data: ", list("data from DB" = "db", "Import Data"= "import")),
    conditionalPanel(
      condition = "input.typeInput == 'db'",
      wellPanel(style = "background-color: #AEAFAB;",
                radioButtons("type1", "Select Option:", list("State Analysis" ="SA", "District Analysis" ="DA")),
                conditionalPanel(
                  condition ="input.type1 == 'SA'",
                  div( style ="color:black", selectInput("dataset", label = "Select State",choices = c("iris", "mtcars", "rocks", "amravati", "bid",
                                                                                                       "dhule", "chandrapur")))
                ),
                conditionalPanel(
                  condition = "input.type1 == 'DA'",
                  div( style ="color:black", selectInput("dataset1", label = "Select State",choices = c("iris", "mtcars", "rocks", "amravati", "bid",
                                                                                                        "dhule", "chandrapur"))),
                  shinyjs::useShinyjs(),
                  shinyjs::hidden(div (id ="o",
                                       div(style ="color:black", uiOutput("ui")) ),
                                  numericInput("obs", "Number of observations to view:", 10)
                  ) ) ) ),
    
    conditionalPanel(
      condition = "input.typeInput == 'import'",
      fileInput("file1", "Choose CSV File", multiple = TRUE, accept = c("text/csv", ".csv"))
    ),
    
    menuItem("Widgets", tabName = "widgets", icon = icon("th")),
    menuItem("Table", tabName = "Table", icon = icon("table") ),
    menuItem("Summary", tabName = "Summary" , icon=icon("list-alt")),
    menuItem("Plot", tabName = "Plot", icon = icon("bar-chart-o")),
    actionButton("show", "Select Data from Database")
    
  )),
  
  dashboardBody(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      
    ),
    
    fluidRow(
      
      box(
        tags$img(src='logo.png'), width = 15
      )  
      
    ),
    
    tabItems(
      
      tabItem(tabName = "dashboard",
              fluidRow(
                # box(
                #     title = "Controls",
                #     sliderInput("slider", "Number of observations:", 1, 100, 50)
                #   )
              )
      ),
      
      
      tabItem(tabName = "widgets",
              div(style="text-align:center",h2("Widgets tab content"))
      ),
      tabItem(tabName = "Table",
              div(style="text-align:center",h2("Table tab content")), 
              fluidRow(
                box(title="Selected table",
                    conditionalPanel(
                      condition = "input.typeInput == 'db'",
                      div( style = 'overflow-x: scroll',DT::dataTableOutput("db_table"))
                      
                    ),
                    conditionalPanel(
                      condition = "input.typeInput == 'import'",
                      div(style ='overflow-x: scroll', DT :: dataTableOutput("table")),
                      tableOutput("contents"))
                    
                ),
                
                box(title = "Controls",
                    checkboxInput("header", "Header", TRUE),
                    
                    radioButtons("sep", "Separator", choices = c(Comma = ",",  Semicolon = ";", Tab = "\t"), selected = ","),
                    radioButtons("quote", "Quote", choices = c(None = "", "Double Quote" = '"',"Single Quote" = "'"), selected = '"'),
                    tags$hr(),
                    radioButtons("disp", "Display", choices = c(Head = "head", All = "all"), selected = "head")))),
      
      tabItem(tabName = "Summary",
              div(style="text-align:center",h2("Summary tab content"),verbatimTextOutput("summary"))
      ),
      tabItem(tabName = "Plot",
              
              div(style="text-align:center",h2("Plot tab content"), 
                  tabsetPanel( tabPanel("Table", icon = icon("table"),box(
                    conditionalPanel(
                      condition = "input.typeInput == 'db'",
                      div(style='overflow-x: scroll', DT::dataTableOutput('db_table2'))),  conditionalPanel(
                        condition = "input.typeInput == 'import'", div(style ='overflow-x: scroll', DT :: dataTableOutput("table2")))),box(tags$blockquote('Select Indicator'), 
                                                                                                                                           div(style ="text-align:left",checkboxGroupInput("Indicator","Indicator to Show", c("Women who are literate" ="COL.15",
                                                                                                                                                                                                                              "Men who are literate " ="COL.16",
                                                                                                                                                                                                                              "Women with 10 or more years of schooling"="COL.17",
                                                                                                                                                                                                                              "Mothers who had full antenatal care8"="COL.36",
                                                                                                                                                                                                                              "Institutional births in public facility (%)"="COL.44",
                                                                                                                                                                                                                              "Home delivery conducted by skilled health personnel (out of total deliveries) (%)" ="COL.45",
                                                                                                                                                                                                                              "Sex ratio at birth for children born in the last five years (females per 1,000 males)"="COL.7",
                                                                                                                                                                                                                              "Children under age 5 years whose birth was registered (%)" ="COL.8",
                                                                                                                                                                                                                              "Households with electricity (%)" ="COL.9",
                                                                                                                                                                                                                              "Households with an improved drinking-water source1 (%)" ="COL.10",
                                                                                                                                                                                                                              "Households using improved sanitation facility2 (%)" ="COL.11",
                                                                                                                                                                                                                              "Households using clean fuel for cooking3 (%)" ="COL.12",
                                                                                                                                                                                                                              "Households using iodized salt (%)" ="COL.13",
                                                                                                                                                                                                                              "Households with any usual member covered by a health scheme or health insurance (%)" ="COL.14",
                                                                                                                                                                                                                              "Women age 20-24 years married before age 18 years (%)" ="COL.18",
                                                                                                                                                                                                                              "Men age 25-29 years married before age 21 years (%)" ="COL.19",
                                                                                                                                                                                                                              "Women age 15-19 years who were already mothers or pregnant at the time of the survey (%)" ="COL.20",
                                                                                                                                                                                                                              "Female sterilization (%)" ="COL.23",
                                                                                                                                                                                                                              "Male sterilization (%)" ="COL.24",
                                                                                                                                                                                                                              "IUD/PPIUD (%)" ="COL.25" ) )))),
                    
                    tabPanel("Bar Graph", icon=icon("bar-chart-o"), div(style="height:400px, width:100%",box(plotlyOutput("bar"), width = 15, height = 20))), 
                    tabPanel("Pie", icon=icon("glyphicon glyphicon-cd"),box(plotlyOutput("pie"), width = 15, height = 20)),
                    tabPanel("Scatter",box(plotlyOutput("plot"), width = 15, height = 20)),
                    tabPanel("Line", box(plotlyOutput("line"), width = 15, height = 20)),
                    tabPanel("HeatMap",box(plotlyOutput("heat"), width = 15, height = 20)),
                    tabPanel("Map",box(plotlyOutput("map"), width = 15, height = 20)),
                    tabPanel("PolarMap", box(plotlyOutput("polar"),width = 15))
                  )))
      
      
      
    )
  )
)




