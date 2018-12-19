
#---------------------------------------------------------------------#
#               Shiny App around the UDPipe NLP workflow                              #
#---------------------------------------------------------------------#

#------------ Team details----------------#
# S Gngadhara Rao Boppana # PGID: 11810066
# Raghu Bomminayuni # PGID: 11810052
# Nischal Mohan Nalawade # PGID: 11810092
#----------------------------------------#
options(shiny.maxRequestSize=40*1024^2) # Increase Shiny App size so that Input filesize can be upto 40MB
# Import all needed libraries 
library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

# Define server logic required to read input file and show output results
shinyServer(function(input, output) {
  
  # getInputFile fucntion
  getInputFile <- reactive({
    if(is.null(input$fileToProcess)){
      return(NULL)
    }
    else{
    txt = readLines(input$fileToProcess$datapath)
    txt = str_replace_all(txt,"<.*?>","")
    txt = txt[txt != ""]
    return(txt)
    }
  }) # End of getInputFile
  
  
  # inputUdpipeModel fucntion
  processFile <- reactive({
    if(is.null(input$inputUdpipeModel)){
      return(NULL)
    }
    else{
      processFile = udpipe_load_model(input$inputUdpipeModel$datapath)  # file_model
       return(processFile)
    }
  }) # End of inputUdpipeModel
  
  #Annotation
    annotation = reactive({
    x <- udpipe_annotate(processFile(),x = getInputFile())
    x <- as.data.frame(x)
    return(x)
  })
  
  #Displaying Table
    output$tableop = renderDataTable({
    if(is.null(input$fileToProcess)){
      return(NULL)
    }
    else{
      out = annotation()[,-4]
      return(out)
    }
  })
  
  #Displaying Plot
  output$plotop = renderPlot({
    if(is.null(input$fileToProcess)){
     return(NULL)
    }
    else{
      text_cooc <- cooccurrence(
        x = subset(annotation(),upos %in% input$xpos),
        term = "lemma",
        group = c("doc_id","paragraph_id","sentence_id"))
      
      wordnetwork <- head(text_cooc,50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      
      ggraph(wordnetwork, layout = "fr") +
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +
        theme(legend.position = "none") +
        
        labs(title = "Cooccurence plot", subtitle = input$xpos[2])
      
    }
  }) 
}) 
    


