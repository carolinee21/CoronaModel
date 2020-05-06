# CoronaModel
by Caroline Evans and JJ Kampf 

See the demo for CoronaModel [here](https://www.youtube.com/watch?v=JR0VIqvCcuM). 

## Instructions 
### Set-Up (After having cloned the repository to your local machine)
1. Download Xcode (only available for Mac - unfortunately, Apple has pretty restrictive policies and do not currently support running Xcode on Windows)

2. Double click "CoronaModel.xcworkspace" to open the project workspace 

3. Run the app by clicking play button in the upper left corner. There are options to run on any size iPhone as a "simulator" which appears on your computer screen, or you can connect your iPhone via cable and it will install the app on your phone. This sometimes requires authenticating/approving our app, as it is technically a third-party developer application (by running the app on your phone, you can "download" it and use it without being connected to Xcode as well). 

### Launch Screen
*On the launch screen, you can input parameters for the simulation:*
1. Simulation duration (days): this represents the number of "days" that the model will represent. In our app, these days are scaled to seconds, so the default duration of thirty days implies a thirty second simulation. 

2. Desired population: the desired starting population count of all individuals. Default is 100. 

3. Number of Initial Sick Cases: the number of initial cases of the virus. Default is 2. 

4. Social Distancing value: this runs on a scale from 0 to 100% and is based off of a more general concept of social distancing. 0 means no social distancing, and correspondingly on the map, the individuals move around a lot faster and infect a lot of people early on. 100 represents maximum social distancing. To keep it realistic, the nodes do still move around and sometimes infect others, but it is at a much lower rate than in the other cases. 

## Simulation Scene
*At the top, you will see a variety of statistics representing the current state of the simulation:*
1. R0: this statistic is meant to represent the number of new persons infected per infected individual. Due to model limitations such as limited population/region size and scaling difficulties such as distance and time, we determined that it was necessary to adjust this value to better represent observed R0 values during the current pandemic. At a social distancing value of 50%, the model terminated with an R0 of approximately 1.62. At a higher social distancing value of 75%, the model now terminated with an R0 of 1.07. Finally, with a low social distancing value of 25%, the R0 climbs to 3.48, representing the dramatic effect of decreased social distancing. You can play with other parameters to affect R0 as well, such as population size and the number of initial sick cases. 

2. The counts for healthy, infected, recovered, and fatalities represent the current number of cases in each category. This is updated live every time a case changes status. 

3. Days remaining represents the number of days left in the simulation. 
