# Environment config

The idea behind the device is to eveluate the measured values from the environment to produce the state result 

The environment have several states of the environment
*  good 
*  warning
*  danger 
*  alarm

To evaluate the state, we use the ranges of control parameters from the table below: 

A..<B is a Range - It describes an interval that includes A and all values between A and B. It does not include B
A..B is a ClosedRange -  It describes an interval that includes A, all values between A and B, B
      
### Evaluation intervals v 1.0.0
      
| Qualification | IAQ | Temp,C | Humidity, % | Pressure, hPa | CO, ppm | CO2, ppm | bVOC, ppm |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Good | 0..<120 | 16…35 | 15…70 | 960…1060 | 0…<10 | 0..<1500 | 0..<5 |
| Warning | 120..<350 | 10…45 | 0…100 | 790…1215 | 10..<20 | 1500..<2500 | 5..<10 |
| Danger | 350..<450 | 0…55 | N/A | 650…1417 | 20..<40 | 2500..<5000 | 10..<20 |
| Alarm | Other | Other | N/A | Other | Other | Other | Other |
      
      
