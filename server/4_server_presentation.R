output$presentation = renderUI({
  HTML(paste("
  <center><h1>Fuel Poverty</h1></center>
  <div style = 'margin : 0 auto; width: 450px'>
    <hr>
    <p style = 'text-align: justify; font-size: 16px;'>
    This app is built using R Shiny in the frame of an internship in the Center for Research in Economics and Management (CREM). It enables to visualize the data from the EU-SILC survey.
    This survey done annually by Eurostat provides information about individuals (financial comfort, social exclusion, living conditions, ...) and household (structure, income, ...). Among the available data, we can find important factors concerning fuel poverty.
    </p>
    
    
    
    <br>
    <p style = 'text-align: right;'>Last update : June 2019.</p>
    <hr>
  </div>
  <center><img src = 'logo_crem.png' height = 172px width = 220px></center>
  <br>
<center><p style = 'text-decoration: underline;'><strong>Trainees</p></strong></center>
<center><p><strong>Yohann TRAN</strong>, Master 1 Applied Mathematics, Statistics, University of Rennes 1.</p></center>
<center><p><strong>Guy TSANG</strong>, Master 1 Applied Mathematics, Statistics, University of Rennes 1.</p>    </center>  
  <br>
<center><p style = 'text-decoration: underline;'><strong>Internship supervisors</p></strong></center>
<center><p><strong>Isabelle CADORET</strong>, Full Professor of Economics, University of Rennes 1 and Research Fellow, CREM.</p></center>
<center><p><strong>Véronique THÉLEN</strong>, Assistant Professor, University of Rennes 1 and Research Fellow, CREM.</p></center>
<br>
             "))
})