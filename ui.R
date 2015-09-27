library(shiny)

shinyUI(fluidPage(
  titlePanel("FolioView"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select stocks:"),
    
      textInput("symb", "Stock 1", "AAPL"),
	  numericInput("Wgt","Stock 1 Weighting",0.4,min=0,max=1),
      textInput("symb2", "Stock 2", "SPY"),
	  numericInput("Wgt2","Stock 2 Weighting",0.3,min=0,max=1),
	  textInput("symb3", "Stock 3", "BAC"),
	  numericInput("Wgt3","Stock 3 Weighting",0.3,min=0,max=1),
      dateRangeInput("dates","Date range",start = "2010-01-01",end = as.character(Sys.Date()))
     
    ),
    
    mainPanel(
	tabsetPanel(
	tabPanel("Overview",br(),br(),tableOutput("tablePerformance")),
	tabPanel("Return", plotOutput("plot")),
	tabPanel("Risk", plotOutput("plot2")),
	
	tabPanel("About",
HTML("
<p></p>
<p> This Shiny application is designed to help analysing the Investment Portfolio.</p>

<b>How to use the App as it is?</b>
<p></p>
<p>At the moment, the App allows to select up to 3 stocks, their weightings and the date range.</p>


<li><i>Overview</i>: The tab gives an overview of the portfolio performance, including the annualised return,annualised voltality,maximum drawdown,sharp ratio and profit factor.  </li>
<p></p>
<li><i>Return</i>: The tab gives the distribution of the daily returns. It allows you to see the average returns and number of days of positive and negative return. </li>
<p></p>
<li><i>Risk</i>: The tab gives the drawdowns of the portfolio. It allows you to determine the risk of the portfolio.</li>
<p></p>
<p></p>
<p></p>
<p>Data are sourced from Yahoo Finance. The symbol lookup is available from http://finance.yahoo.com/lookup</p>


"))

	
	
	
	)
	)
  )
))
