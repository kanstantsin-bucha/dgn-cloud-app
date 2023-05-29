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
      
### Evaluation intervals v 0.9.0
      
| Qualification | IAQ | Temp,C | Humidity, % | Pressure, hPa | CO, ppm | CO2, ppm | bVOC, ppm |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Good | 0..<100 | 16…35 | 20…65 | 980…1030 | 0…<10 | 0..<1200 | 0..<3 |
| Warning | 100..<250 | 10…45 | 0…100 | 790…1215 | 10..<20 | 1200..<2500 | 3..<10 |
| Danger | 250..<400 | 0…55 | N/A | 650…1417 | 20..<40 | 2500..<5000 | 10..<20 |
| Alarm | Other | Other | Other | Other | Other | Other | Other |
      
      
