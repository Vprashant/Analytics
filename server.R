server <- function(input, output, session) {
  
  
  
  output$ui <- renderUI({
    if (is.null(input$dataset))
      return()
    
    switch(input$dataset1,
           selectInput("dynamic", label = "Select District", choices = "Nicobar")
    )
  })
  
  observeEvent(input$dataset1,{
    if(input$dataset1 =="amravati"){
      shinyjs::show("o")
    }
    else{
      shinyjs::hide("o")
    }
  })
  
  
  
  dataInput<-reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath, header = input$header, sep = input$sep, quote = input$quote)
    
  })
  
  conn <- dbConnect(drv = RMySQL::MySQL(),dbname = "db_test",host = "localhost",  username = "root",password = "")
  on.exit(dbDisconnect(conn), add = TRUE)
  iris<- dbReadTable(conn = conn,  name = 'iris', value = as.data.frame(iris))
  mtcars<- dbReadTable(conn = conn,  name = 'mtcars', value = as.data.frame(mtcars))
  rocks<- dbReadTable(conn = conn,  name = 'rocks', value = as.data.frame(rocks))
  amravati<- dbReadTable(conn = conn,  name = 'amravati', value = as.data.frame(amravati))
  bid<- dbReadTable(conn = conn,  name = 'bid', value = as.data.frame(bid))
  dhule<- dbReadTable(conn = conn,  name = 'dhule', value = as.data.frame(dhule))
  chandrapur<- dbReadTable(conn = conn,  name = 'chandrapur', value = as.data.frame(chandrapur))
  
  output$table = DT::renderDataTable(dataInput(), server = FALSE)
  #output$table2=DT::renderDataTable(datasetInput(), server=FALSE)
  output$db_table2=DT::renderDataTable(datasetInput(), server=FALSE)
  output$table2 = DT::renderDataTable(dataInput(), server = FALSE)
  
  datasetInput <- reactive({
    switch(input$dataset, "iris" = iris, "mtcars" = mtcars, "rocks" = rocks, "amravati"=amravati[, c("COL.1","COL.2", input$Indicator)], "bid"=bid, 
           "dhule"=dhule[,c("COL.1","COL.2" , input$Indicator)], "chandrapur"=chandrapur[, c("COL.1","COL.2",input$Indicator)])
  })
  
  output$db_table <-DT::renderDataTable({
    head(datasetInput(), n = input$obs, options=list(scrollX =TRUE)) 
  })
  
  output$summary <- renderPrint({
    dataset <- (datasetInput())
    summary(dataset)
    
  })
  
  
  output$plot <- renderPlotly({
    plot_ly(datasetInput(), type='scatter', mode='lines')
    #plot(mtcars$wt, mtcars$mpg)
  })
  
  output$pie<-renderPlotly({
    print(datasetInput[input$Indicator])
    #print(input$Indicator)
    plot_ly(datasetInput(), values= ~input$Indicator, type = 'pie')
  })
  
  ##################data Filter
  
  
  output$bar<-renderPlotly({
    
    plot_ly(data=datasetInput(),y= ~input$Indicator, type='bar', marker = list(color = 'rgb(49,130,189)'))
    
  })
  
  output$line<-renderPlotly({
    
    p <- plot_ly(datasetInput(), type = 'scatter', mode = 'lines')
  })
  
  output$heat<-renderPlotly({
    
    plot_ly(x=names(dataInput()),y =names(dataInput()),  type='heat', source = "heatplot") %>%
      layout(xaxis = list(title = ""), 
             yaxis = list(title = ""))
  })
  output$map<-renderPlotly({
    
  })
  output$polar<-renderPlotly({
    plot_ly(plotly::wind, r=~mtcars$wt, t=~mtcars$mpg) %>% add_area(color = ~nms)
    
  })
  
  observeEvent(input$abc, {
    showModal(modalDialog(title = "Important message", "This is an important message!",easyClose = TRUE
    ))
  }
  )
  
}
