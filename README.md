This repository is created for my proposed project for [the data incubator](https://www.thedataincubator.com/).

#American Radiation

The Environmental Protection Agency’s RadNet system “monitors the nation's air, precipitation and drinking water for radiation.” 
The radiation measurements collected from 130+ stations in all 50 states plus the District of Columbia and Puerto Rico. 
The goal of my project is two-fold: 
1) to investigate the changing pattern of radiation level across time (year, month, weekday/weekend, day, time) and space (different US states)
2) to explore the causing variables to predict radiation level, e.g. air quality, drinking water quality, precipitation, temperature, latitude, longitude, economic development (GDP) etc.

1. data source:
The data was downloaded from the website of [US Environmental Protection Agency](https://www.epa.gov/radnet/radnet-csv-file-downloads).
I choose the following 11 cities:
AK: FAIRBANKS 
CA: SAN FRANCISCO        
CO: DENVER    
DC: WASHINGTON 
FL: MIAMI     
HI: HONOLULU    
IA: DES MOINES        
MN: DULUTH 
NY: NEW YORK CITY      
TX: HOUSTON       
WA: SEATTLE
As they are respectively from North, middle, South, West, East and two separate states.  
The sampling of states represent varying latitude and longitude, and thus would display differences in economy, temperature, precipitation etc.
These variables will provide further information to investigate the correlation between them and the radiation level.

2. Directories: Data, scripts and results

3. Main findings:

A. In Denver, when the hazardous rate increases (from R02 to R09) , the radition measurement increase  more dramatically across years.
At R02, the radiation measurement doesnot change much across years; but when the hazardous rate equals R09, radiation increases dramatically across years.

B. In Denver, we see a general pattern that the radiation level (rate=R09) is lower in Summer than in winter.

C. In Denver, the radiation level is at its peak during 12-13pm.

D. Different cities showed variable pattern of radiation change over years. 
The radiation in some cities decreased a lot, such as New York city in 2008-2009.
Further question could be: what policies has NYC taken to reduce the radiation level? what we can learn from it?

E. In the most recent month (this April), Denver has the highest radiation. 
Could it be related with the mining industry neaby?
Fairbanks, duluth, honolulu etc showed the lowest radiation.

4. Future directions:
Owing to the time limitation, I mainly focused on the first goal of the project. 
Next, I will gather more data (from other sources) related with these cities and establish ML models to predict radiation levels.
