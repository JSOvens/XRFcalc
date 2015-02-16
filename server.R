library(shiny)
atoms = read.table("atoms.txt",col.names=list("Atom","Number","Mass"))

# server.R

shinyServer(function(input, output) {     
  
  values <- reactiveValues()

  addData <- observe({ 
    
    if(input$addButton == 1) {
      
      values$AM <- isolate(atoms$Mass[grep(paste(input$atom,"$",sep=""),
                                           atoms$Atom)])
      
      isolate(values$data <- data.frame(Atom=input$atom,
                                        Atomic.Mass=values$AM,
                                        Percent.Mass=input$mass))
      
    }
    
    if(input$addButton > 1) {
      
      values$AM <- isolate(atoms$Mass[grep(paste(input$atom,"$",sep=""),
                                           atoms$Atom)])
      
      newLine <- isolate(c(input$atom, values$AM, input$mass))
      isolate(values$data <- rbind(as.matrix(values$data), unlist(newLine)))
    
    }
  })

   calcData <- observe({
     
     if(input$calcButton > 0) {
     
       if(isolate(!any(grepl(input$denom,values$data[,1])))) {
       
       output$warn <- renderText({
         
         "Atom not found, selecting first atom in list"
         
       })
       
       WRTatom = isolate(values$data[1,1])
       WRTpos = grep(paste(WRTatom,"$",sep=""),values$data[,1])
       WRTratio = isolate(as.numeric(values$data[WRTpos,3])/
                            as.numeric(values$data[WRTpos,2]))
       
     } else {
       
       output$warn <- renderText({
         
         ""
         
       })
       
       WRTatom = isolate(input$denom)
       WRTpos = grep(paste(WRTatom,"$",sep=""),values$data[,1])
       WRTratio = isolate(as.numeric(values$data[WRTpos,3])/
                            as.numeric(values$data[WRTpos,2]))
     }
     
     values$ratios <- isolate(as.numeric(values$data[,3])/
                                as.numeric(values$data[,2])/
                                as.numeric(WRTratio))
     
     isolate(values$data <- cbind(values$data[,1:3],Ratio=values$ratios))
    
     } 
   })
  
  output$table <- renderTable({values$data}, include.rownames=F)
}
)