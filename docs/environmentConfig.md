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
      
### Evaluation intervals v 1.1.0
      
| Qualification | IAQ* | Temp,C | Humidity, % | Pressure, hPa | CO, ppm | CO2, ppm | bVOC, ppm |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Good | 0..<120 | 16…35 | 15…70 | 960…1060 | 0…<10 | 0..<1500 | 0..<20 |
| Warning | 120..<350 | 0…55 | 0…100 | 650…1417 | 10..<20 | 1500..<10000 | 20..<70 |
| Danger | 350..<450 | Other | N/A | Other | 20..<40 | N/A | Other |
| Alarm | Other | N/A | N/A | N/A | Other | N/A | N/A |
      
IAQ* is not evaluated on the device, only in mobile app     
