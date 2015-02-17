library(shiny)
atoms = read.table("atoms.txt",col.names=list("Atom","Number","Mass"))

# server.R

shinyServer(function(input, output) {     
  
  values <- reactiveValues()

  addData <- observe({ 
    
    if(input$addButton == 0) {
      
      isolate(values$data <- data.frame(Atom=character(0),
                                        Atomic.Mass=numeric(0),
                                        Percent.Mass=numeric(0)))
      
    }
    
    if(input$addButton > 0) {

      
      if(isolate(!any(grepl(paste(input$atom,"$",sep=""),atoms$Atom)))) {
        
        output$warn1 <- renderText({
          
          "Atom not found, please try again"
          
        })
        
      } else {
        
        output$warn1 <- renderText({
          
          ""
          
        })

        values$AM <- isolate(atoms$Mass[grep(paste(input$atom,"$",sep=""),
                                             atoms$Atom)])
        
        newLine <- isolate(c(input$atom, values$AM, input$mass))
        isolate(values$data <- rbind(as.matrix(values$data), unlist(newLine)))
      
      }
           
    }
    
  })  
  
#   addData <- observe({ 
#     
#     if(input$addButton == 1) {
#       
#       values$AM <- isolate(atoms$Mass[grep(paste(input$atom,"$",sep=""),
#                                            atoms$Atom)])
#       
#       isolate(values$data <- data.frame(Atom=input$atom,
#                                         Atomic.Mass=values$AM,
#                                         Percent.Mass=input$mass))
#             
#     }
#     
#     if(input$addButton > 1) {
#       
#       values$AM <- isolate(atoms$Mass[grep(paste(input$atom,"$",sep=""),
#                                            atoms$Atom)])
#       
#       newLine <- isolate(c(input$atom, values$AM, input$mass))
#       isolate(values$data <- rbind(as.matrix(values$data), unlist(newLine)))
#           
#     }
#   })

   calcData <- observe({
     
     if(input$calcButton > 0) {
     
       if(isolate(!any(grepl(input$denom,values$data[,1])))) {
       
       output$warn2 <- renderText({
         
         "Atom not found, selecting first atom in list"
         
       })
       
       WRTatom = isolate(values$data[1,1])
       WRTpos = isolate(grep(paste(WRTatom,"$",sep=""),values$data[,1]))
       WRTratio = isolate(as.numeric(values$data[WRTpos,3])/
                            as.numeric(values$data[WRTpos,2]))
       
     } else {
       
       output$warn2 <- renderText({
         
         ""
         
       })
       
       WRTatom = isolate(input$denom)
       WRTpos = isolate(grep(paste(WRTatom,"$",sep=""),values$data[,1]))
       WRTratio = isolate(as.numeric(values$data[WRTpos,3])/
                            as.numeric(values$data[WRTpos,2]))
     }
     
     values$ratios <- isolate(as.numeric(values$data[,3])/
                                as.numeric(values$data[,2])/
                                as.numeric(WRTratio))
     
     isolate(values$data <- cbind(values$data[,1:3],Ratio=values$ratios))
         
     } 
   })
  
clearData <- observe({
    
    if (input$clearButton > 0) {
      
      isolate(values$data <- NULL)
      values$data <- isolate(values$data <- data.frame(Atom=character(0),
                                                       Atomic.Mass=numeric(0),
                                                       Percent.Mass=numeric(0)))
      
    } 
})
  
  output$table <- renderTable({values$data},include.rownames=F)
#  output$table <- renderDataTable({values$data})


}
)