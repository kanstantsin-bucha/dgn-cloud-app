# Environment config

The idea behind the device is to eveluate the measured values from the environment to produce the state result 

The device have several states of the environment
*  good 
*  warning
*  danger 
*  alarm

The device can notify user about the actual state by light's flashes on the sensor enclosure and sound that it can produce
*  good each 30s, no Sound, Lights 1s
Warning each 10s, no Sound, Lights 2s
Danger
each 10s, single Beep in sync with Lights 3s
Alarm
permanent Beep and Lights **light blue** or **green** flashes each 30 sec (if device battery is charging)
*  warning **yellow flashes** each 15 sec
*  danger **red flashes** and beep sound each 15 sec
*  alarm

A..<B is a Range - It describes an interval that includes A and all values between A and B. It does not include B
A..B is a ClosedRange -  It describes an interval that includes A, all values between A and B, B
      
      
