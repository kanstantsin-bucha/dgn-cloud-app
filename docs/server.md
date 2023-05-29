
Server address <http://detecta.group/api/2/>


* FirmwareUpdate
```
GET /firmware/update?deviceVersion=string&type=string&deviceId=string
```
binary stream with a firmware file

----

* Get device report by it’s id

```
GET /deviceReports/:id
```
<https://detecta.group/api/2/deviceReports/B8E1DDFD-73C0-48D9-9CBB-C5501F856660>

{"data":{"co2Equivalent":559.1675,"coZeroV":0,"tempCelsius":30.19,"coPpm":0,"gasResistance":410884,"gasPercentage":0,"compGasValue":0,"breathVocEquivalent":0.6252855,"humidity":39.14,"iaq":58.861893,"coV":0.5210625,"staticIaq":39.791862,"busVoltage":3.832,"millis":65857581,"pressureHPa":1000.56},"createdAt":"2022-09-24T08:10:50Z","deviceId":"d-air_eca96ad108f0","id":"B8E1DDFD-73C0-48D9-9CBB-C5501F856660"}

-----
* Get the latest report for a device by deviceId

```
GET /deviceReports/latestWithDevice/:id
```

<https://detecta.group/api/2/deviceReports/latestWithDevice/d-air_eca96ad108f0>

{"data":{"co2Equivalent":559.1675,"coZeroV":0,"tempCelsius":30.19,"coPpm":0,"gasResistance":410884,"gasPercentage":0,"compGasValue":0,"breathVocEquivalent":0.6252855,"humidity":39.14,"iaq":58.861893,"coV":0.5210625,"staticIaq":39.791862,"busVoltage":3.832,"millis":65857581,"pressureHPa":1000.56},"createdAt":"2022-09-24T08:10:50Z","deviceId":"d-air_eca96ad108f0","id":"B8E1DDFD-73C0-48D9-9CBB-C5501F856660"}

----

* Get reports for interval for a device by deviceId

```
GET /deviceReports/interval/:id?lastHoursCount=uint
```

<https://detecta.group/api/2/deviceReports/interval/d-air_eca96ad108f0?lastHoursCount=1>

<https://detecta.group/api/2/deviceReports/interval/d-air_409265d108f0?lastHoursCount=8>

[{"deviceId":"d-air_eca96ad108f0","data":{"coZeroV":0,"co2Equivalent":567.5791,"busVoltage":3.832,"coPpm":0,"pressureHPa":1000.66,"tempCelsius":30.16,"coV":0.50625,"breathVocEquivalent":0.64548177,"gasResistance":412403,"staticIaq":41.894783,"iaq":63.675957,"millis":65256491,"humidity":39.109,"compGasValue":0,"gasPercentage":0},"createdAt":"2022-09-24T08:00:49Z","id":"DBBD6C2A-297E-426E-9892-59AAAA1BD324"},{"deviceId":"d-air_eca96ad108f0","data":{"staticIaq":40.778282,"gasResistance":411642,"breathVocEquivalent":0.6346791,"coZeroV":0,"coV":0.5185625,"tempCelsius":30.18,"millis":65341643,"iaq":61.12003,"co2Equivalent":563.11316,"gasPercentage":0,"busVoltage":3.832,"pressureHPa":1000.64,"compGasValue":0,"humidity":39.105,"coPpm":0},"createdAt":"2022-09-24T08:02:14Z","id":"9E1509AA-EB76-454D-AAB8-85FC94607871"},{"deviceId":"d-air_eca96ad108f0","data":{"coZeroV":0,"coV":0.503125,"pressureHPa":1000.64,"staticIaq":40.344303,"millis":65428066,"tempCelsius":30.17,"humidity":39.114,"breathVocEquivalent":0.63052905,"compGasValue":0,"busVoltage":3.832,"coPpm":0,"gasResistance":411642,"gasPercentage":0,"iaq":60.126553,"co2Equivalent":561.3772},"createdAt":"2022-09-24T08:03:40Z","id":"46D7BFDF-40A8-4ED6-89FA-FE8EAA6B2315"},{"deviceId":"d-air_eca96ad108f0","data":{"coZeroV":0,"coPpm":0,"humidity":39.088,"gasResistance":410884,"breathVocEquivalent":0.65745234,"tempCelsius":30.18,"pressureHPa":1000.6,"millis":65514120,"busVoltage":3.832,"co2Equivalent":572.44147,"iaq":66.45871,"coV":0.503,"compGasValue":0,"gasPercentage":0,"staticIaq":43.11037},"createdAt":"2022-09-24T08:05:06Z","id":"A9356A17-FEF5-4884-BF8C-CBFC6E6077EB"},{"deviceId":"d-air_eca96ad108f0","data":{"iaq":62.064087,"coV":0.5096875,"breathVocEquivalent":0.6386479,"staticIaq":41.190674,"tempCelsius":30.18,"millis":65599547,"humidity":39.157,"coPpm":0,"gasResistance":411389,"co2Equivalent":564.7627,"busVoltage":3.832,"compGasValue":0,"gasPercentage":0,"coZeroV":0,"pressureHPa":1000.56},"createdAt":"2022-09-24T08:06:32Z","id":"96CE7530-DB61-4643-AE1B-D300969999C7"},{"deviceId":"d-air_eca96ad108f0","data":{"coV":0.513625,"busVoltage":3.832,"coZeroV":0,"co2Equivalent":561.2111,"iaq":60.03151,"staticIaq":40.302784,"gasPercentage":0,"coPpm":0,"breathVocEquivalent":0.63013345,"pressureHPa":1000.54,"humidity":39.168,"compGasValue":0,"millis":65685887,"gasResistance":412658,"tempCelsius":30.18},"createdAt":"2022-09-24T08:07:59Z","id":"BD3BE1D7-65A2-4DD9-99CC-E785528DDD29"},{"deviceId":"d-air_eca96ad108f0","data":{"coZeroV":0,"gasResistance":410632,"iaq":61.772633,"coV":0.5075,"pressureHPa":1000.54,"humidity":39.151,"coPpm":0,"staticIaq":41.06336,"tempCelsius":30.18,"breathVocEquivalent":0.63742,"compGasValue":0,"co2Equivalent":564.2534,"millis":65771836,"busVoltage":3.832,"gasPercentage":0},"createdAt":"2022-09-24T08:09:24Z","id":"904BCB41-4323-4A35-9505-8EAAB64993D8"},{"deviceId":"d-air_eca96ad108f0","data":{"gasResistance":410884,"staticIaq":39.791862,"tempCelsius":30.19,"co2Equivalent":559.1675,"gasPercentage":0,"humidity":39.14,"iaq":58.861893,"pressureHPa":1000.56,"coV":0.5210625,"millis":65857581,"coZeroV":0,"busVoltage":3.832,"coPpm":0,"breathVocEquivalent":0.6252855,"compGasValue":0},"createdAt":"2022-09-24T08:10:50Z","id":"B8E1DDFD-73C0-48D9-9CBB-C5501F856660"},{"deviceId":"d-air_eca96ad108f0","data":{"busVoltage":3.832,"gasResistance":411389,"millis":65942966,"co2Equivalent":560.5137,"breathVocEquivalent":0.6284747,"coV":0.5088125,"coZeroV":0,"tempCelsius":30.21,"pressureHPa":1000.54,"gasPercentage":0,"coPpm":0,"compGasValue":0,"humidity":39.213,"iaq":59.632343,"staticIaq":40.128418},"createdAt":"2022-09-24T08:12:15Z","id":"FDB26AA3-56EB-4808-811F-820C1BDD7683"},{"deviceId":"d-air_eca96ad108f0","data":{"co2Equivalent":558.0537,"gasPercentage":0,"millis":66028774,"coV":0.50625,"iaq":58.224495,"gasResistance":411642,"coPpm":0,"compGasValue":0,"busVoltage":3.832,"humidity":39.179,"breathVocEquivalent":0.6226592,"coZeroV":0,"tempCelsius":30.22,"pressureHPa":1000.5,"staticIaq":39.513428},"createdAt":"2022-09-24T08:13:41Z","id":"1DCBA111-0D27-4576-8986-8CBB28CE45AB"},{"deviceId":"d-air_eca96ad108f0","data":{"co2Equivalent":557.2433,"coZeroV":0,"millis":66114499,"gasResistance":412149,"iaq":57.7607,"coV":0.5091875,"humidity":39.207,"compGasValue":0,"gasPercentage":0,"pressureHPa":1000.5,"staticIaq":39.31083,"tempCelsius":30.22,"breathVocEquivalent":0.6207552,"busVoltage":3.832,"coPpm":0},"createdAt":"2022-09-24T08:15:07Z","id":"0D113A77-E787-438D-9928-4DE00F4CAD58"},{"deviceId":"d-air_eca96ad108f0","data":{"compGasValue":0,"co2Equivalent":563.246,"coPpm":0,"gasResistance":410632,"gasPercentage":0,"busVoltage":3.832,"humidity":39.313,"pressureHPa":1000.48,"tempCelsius":30.23,"coV":0.509625,"staticIaq":40.811493,"breathVocEquivalent":0.6349977,"millis":66200403,"iaq":61.19606,"coZeroV":0},"createdAt":"2022-09-24T08:16:33Z","id":"F0BB56A8-821F-4129-9D1C-7C14192CA30C"}]

-----

* Create device report

```
POST /deviceReports
````

BODY: Json with values from device

none

# Query params:
old device deviceId: 
```
d-air_409265d108f0
```
new device deviceId: 
```
d-air_eca96ad108f0
```
deviceVersion: 
```
1.0.0
```
type: 
```
d-air
```
