#
#---------------------------------------------------------------------#
#               Shiny App around the UDPipe NLP workflow                              #
#---------------------------------------------------------------------#
library(shiny)
library(shinythemes)

# Define UI for application that read input file and show output results

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny App around the UDPipe NLP workflow"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      fileInput("fileToProcess", "Upload Data (Text File)"), # To maintain input text file
      fileInput("inputUdpipeModel", "Upload Udpipe model(udpipe)"), # Inidcating udpipe file
      hr(),
      
      checkboxGroupInput("xpos", label = h3("Select XPOS"), 
                         choices = list("Adjective" = 'ADJ',
                                        "Noun" = "NOUN",
                                        "Proper Noun" = "PROPN",
                                        "Adverb" = 'ADV',
                                        "Verb" = 'VERB'),
                         selected = c("ADJ","NOUN","PROPN"))
   
    ), # End of sidebarPanel

   
    mainPanel(
      
      # Create various tabs for user visualizations
      tabsetPanel(type = "tabs",
                  
                  # TAB #1
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("This app supports text data file. file should have data.",align="justify"),
                           p("Please refer to the link below for sample text file."),
                           a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv","Sample data input file"),   
                           br(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload data (text file)")),
                             'and uppload the required langauge .udpipe file.')),
                          p('Select the XPOS tag for analysis from check list, default selections are Adjective(JJ), Noun(NN) and Proper Noun(NNP)'), 
                                        
                  # TAB #2
                  tabPanel("XPOS-Annotation",
                           dataTableOutput('tableop')),
 
                  # TAB #3
                  tabPanel("Co-Occurrences_Plot",
                           plotOutput("plotop"))
                  
     ) # end of tabsetPanel
   ) # end of main panel
   
  ) # End of sidebarLayout
 ) # end if fluidPage
) # end of UI


