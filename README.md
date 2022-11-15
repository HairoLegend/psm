# PSM (Projek Sarjana Muda) // Translated Undergraduate Project
Final year project for my Degree in Computer Science (Software Engineer) at Universiti Tun Hussein Onn Malaysia (UTHM). 2019-2023

**Automatic Watering System Using Arduino and Android based (AWSAA)**

AWSAA is an application that allow user to manage and monitor multiple automatic watering device (Arduino System).
In before, AWSAA was planned to be developed using Android Studio (Fully Java), but because Flutter is a hybrid programming platform,
this allow AWSAA to run both in Android and iOS system instead of only on Android. Throughout the development of AWSAA version 1.0.0,
AWSAA was only tested to run on Android platform and **never tested to run on iOS**. Below are some of key feature of AWSAA :
```
- Use Dart (Flutter Framework) to develop mobile application
- Use Google Cloud Firebase Database as live database
- Use Arduino IDE (C++,C) to develop and upload code for Arduino microcontroller 
```
- AWSAA allow user to manage and monitor multiple watering device at the same time, this include CRUD operation for watering device
- AWSAA allow user to monitor live reading of each watering device sensor such as current temperature, humidity, light intensity, etc.
- AWSAA was planned to allow user make custom watering schedule, or when for each device, to water plant/crop.
- AWSAA was planned to allow watering device to water automatically based on condition set by user.
- In version 1.0.0, user are able to create custom watering schedule and save it to database, but AWSAA will not water **(function to water are still not developed)**.
- In version 1.0.0, AWSAA are able to water plant automatically based on codition set by user (ex. water plant when humidity is 25%) 
- In version 1.0.0, condition for device to water plant automatically can only be change through hard code in Arduino IDE, future version will have a mobile
  interface in which allow user to change condition for each device instead of hard code in through Arduino IDE.
- In version 1.0.0, AWSAA able to record every watering session, and every device will have unique and different watering record.
- In version 1.0.0, user are able to view watering record and display it detail for each device.

AWSAA is currently missing it key feature, which was to water plant both automatically and customically. Future version will surely have the missing function.

Updated on 15/11/2022
