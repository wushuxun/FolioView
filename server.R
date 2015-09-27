# server.R

library(quantmod)
library(PerformanceAnalytics)

shinyServer(function(input, output) {

  dataInput <- reactive({
    data<-getSymbols(input$symb, src = "yahoo", 
      from = input$dates[1],
      to = input$dates[2],
      auto.assign = FALSE)
	data2<-getSymbols(input$symb2, src = "yahoo", 
      from = input$dates[1],
      to = input$dates[2],
      auto.assign = FALSE)
	data3<-  getSymbols(input$symb3, src = "yahoo", 
      from = input$dates[1],
      to = input$dates[2],
      auto.assign = FALSE)
	  
	input$Wgt*data+input$Wgt2*data2+input$Wgt3*data3
  })

 
  output$tablePerformance <- renderTable({  
    numDays <- nrow(dataInput())
    numYears <- numDays/252
    totalReturn <- (as.numeric(tail(dataInput()[,6],1))-as.numeric(head(dataInput()[,6],1)))/as.numeric(head(dataInput()[,6],1))
	dailyR<-dailyReturn(dataInput()[,6],NULL,"arithmetic",leading=TRUE)
    annReturn <- round(totalReturn/numYears,2)*100
    annVol <- round(sd(dailyR)*sqrt(252),2)*100
    sharpeRatio <- round(annReturn/annVol,2)
    profitFactor <- round(sum(dailyR[dailyR > 0])/abs(sum(dailyR[dailyR < 0])),2)
    maxDrawdown <- round(maxDrawdown(dailyR)*100,0)
	
    PTable <- rbind(paste(annReturn,"%",sep=""),paste(annVol,"%",sep=""),paste(maxDrawdown,"%",sep=""),sharpeRatio,profitFactor)
    rownames(PTable) <- c("Ann.Return","Ann.Vol","Max Drawdown","Sharpe Ratio","Profit Factor")
    colnames(PTable) <- c("Performance")
    PTable                                 
  })
 
 
  
  output$plot <- renderPlot({    
	 chart.Histogram(dailyReturn(dataInput()[,6],NULL,"arithmetic",leading=TRUE)*100, breaks = "FD", main = NULL, xlab = "Returns",
	ylab = "Frequency", methods = c("none", "add.density", "add.normal",
	"add.centered", "add.cauchy", "add.sst", "add.rug", "add.risk", "add.qqplot"),
	show.outliers = TRUE, colorset = c("blue", "#00008F", "#005AFF",
	"#23FFDC", "#ECFF13", "#FF4A00", "#800000"), border.col = "white",
	lwd = 2, xlim = NULL, ylim = NULL, element.color = "darkgray",
	note.lines = NULL, note.labels = NULL, note.cex = 0.7,
	note.color = "darkgray", probability = FALSE, p = 0.95,
	cex.axis = 0.8, cex.legend = 0.8, cex.lab = 1, cex.main = 1,
	xaxis = TRUE, yaxis = TRUE)
  })

  output$plot2 <- renderPlot({    
  chart.Drawdown(dailyReturn(dataInput()[,6],NULL,"arithmetic",leading=TRUE),main="Drawdowns of the Portfolio",legend.loc=NULL)
  })
  
})
