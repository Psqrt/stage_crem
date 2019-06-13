output$presentation_homepage = renderUI({
  HTML(paste('<h1 style = "padding: 13px; font-family: Garamond;"> <strong>Fuel Poverty</strong></h1>
  <p style = "font-size: 17px; text-align: justify; padding: 15px;">Although its existence is not debated, the fuel poverty phenomenon is still largely unknown to most people and governments. Indeed, it is not until recently that countries and European institutions took an interest in the matter. The definition is notably still under debate. <br><br>
In a general manner fuel poverty concerns households and individuals who have trouble keeping their house warm or cool at a reasonable cost. However, all countries do not have the same definition. The European commission counted four types of definition. Some countries choose to define it according to fuel affordability like France or Sweden. Others have a socio-economic approach, like the UK or Ireland who considers that any person or household spending more than 10% of their income on energy bills is affected by fuel poverty. In some countries, are affected by fuel poverty those who receive from the government any kind of social welfare to help than with energy bills. Finally, some countries define fuel poverty according to the social or health disabilities it can create for those affected. <br><br>
A second issue of the definition is the difference between fuel poverty and energy poverty. Both are used by various organisations. The difference stems from the energies understated by energy or fuel. Indeed, energy only takes in account gas and electricity, where fuel includes all kind of energy and therefore houses heated with oil notably. Papers tent to prefer the term fuel poverty as it covers a larger range of cases and gives a more realistic state of the phenomena. <br><br>
In a report for the European Commission <i>(Energy poverty and vulnerable consumers in the energy sector across the EU: analysis of policies and measures, INSIGHT_E (2012))</i>, three driving factors of energy poverty are identified: high energy bills, low income, and poor energy efficiency.  As of today, the European Commission (through Eurostat data set) estimates that 54 million people are unable to keep their house comfortably warm. A similar number are not able to pay their energy bills on time or present poor housing conditions. Overall, studies find that between 50 million and 125 million people suffer from fuel poverty in the European Union.<br><br>
The data used here to illustrate and explain fuel poverty comes from the Eurostat data base. This enables to take in consideration a large range of indicators in most European countries in a relevant period of time. Indeed, economists and organisation agree to say that fuel poverty can be caused by three factors <i>(Healy and Clinch (2004), Thomson and Snell (2013), Buzorvaski... (2012))</i>, therefore it is interesting to study any socio-economic or socio-demographic data that could be linked to those factors and to fuel poverty. This explains that this data base contains many factors from income to the number of rooms per houses surveyed. This data was collected through the EU-SILC surveys. Although not always adapted for studies about poverty <i>(Thomson and Snell 2013)</i>, the EU-SILC metric is the best metric for now to guarantee similar survey in all the countries and therefore comparable data from one country to another. <br><br>

This app enables an easy visualisation of all the data that could be linked to fuel poverty. Indeed, this app displays trough an interactive map the different statistics of each European countries in different variables, all of which could be a factor of fuel poverty, and enables comparison between regions of different scales and at different times.</p>')
  )
})

output$presentation_homepage_eusilc_titre = renderUI({
  HTML(paste('<h1 style = "padding: 15px; float: left; font-family: Garamond;"> <strong>EU-SILC Survey</strong></h1>'))
})

output$presentation_homepage_img = renderUI({
  HTML(paste('<center><img src = "logo_eurostat.png" height = 55px width = 360px></center><hr>'))
})

output$presentation_homepage_survey_text = renderUI({
  HTML(paste('<hr><p style = "font-size: 17px; text-align: justify;">
The EU-SILC survey (EU statistics on income and living Conditions) is a Europe - scaled longitudinal and multidimensional survey. Indeed, the survey has existed since 2003 and enables to follow the studied units on a four-year period. Additionally, the poll includes many information domains like:</p>
<ul>
<li><p style = "font-size: 17px; text-align: justify;">household structure </p></li>
<li><p style = "font-size: 17px; text-align: justify;">living units and living conditions (dwelling, financial comfort…) </p></li>
<li><p style = "font-size: 17px; text-align: justify;">individual data (activity, resources, well-being, health…).</p></li>
</ul>
<p style = "font-size: 17px; text-align: justify;">The number of participating countries in the study grows every year. In 2003, 7 countries including 6 members of the EU were the first to poll their population. In 2019, the EU-SILC survey applies to 35 countries with the integration of the Montenegro this year.</p><hr>
<p><strong>Yohann TRAN</strong>, Master 1 Applied Mathematics, Statistics, University of Rennes 1.</p>
<p><strong>Guy TSANG</strong>, Master 1 Applied Mathematics, Statistics, University of Rennes 1.</p>             
<p><strong>Alexia MARSAL</strong>, First year at École Normale Supérieure Rennes.</p>             
             '))
})