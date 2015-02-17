library(shiny)

shinyUI(fluidPage(
  
  headerPanel('XRF Calculator'),
  
  sidebarPanel(
    
    fluidRow(
      
      column(6,
            textInput("atom",
                      label="Atom symbol:",
                      value=NULL)),
      
      column(6,
             numericInput("mass",
                          label="XRF mass (%):",
                          value=0))
    ),
    
    fluidRow(
      column(12,
             actionButton("addButton",
                          "ADD!"))
    ),
    
    fluidRow(
      column(12,
             textOutput("warn1"))
      
      ),
    
    h4("Calculate with respect to:"),
    fluidRow(
      column(6,
             textInput("denom",
                       label=NULL,
                       value=NULL)),
      
      column(6,
             actionButton("calcButton",
                          "DO IT!"))

    
    ),
    
    fluidRow(
      column(12,
             textOutput("warn2"))
      
      ),
    
    fluidRow(
      column(12,
             actionButton("clearButton",
                          "CLEAR!"))
    
    )),
  
  mainPanel(
    
    tableOutput("table")
    
    )
))