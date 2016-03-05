# FinalYearProject 
Code for Computer Science Final Year BSc Computer Science (Infrastructure)

This part of the code is where the Romo Robot elements will be developed over time. 

To use this app, you must have a Romo robot from Romotive, with a Lightening Connector. 
Also, an iDevice (iPhone 5 or 6/iPod Touch 5th or 6th generation).
This app is built for iOS9 and above, so please ensure your iDevice is running iOS 9.0 or later.

To use this code for development, you must have the Romo SDK frameworks in the Frameworks group in your xCode project. 

To do this, you download the SDK for iOS from the Romotive GitHub 
(https://github.com/Romotive/Romo/tree/master/SDK/Public) 
and drag all the items from the frameworks folder into your xCode Project.

Then, in the Build Phases for your app Target, in Link Binary With Libraries, ensure the three Romo frameworks are listed. 
If not listed in Link Binary With libraries, click the + button in the bottom left, select Add Other and navigate to the 
folder where you downloaded the SDK, navigate to the SDK > Frameworks folder and select the files with a ".framework" name.

Lastly, ensure the RMCharacter.bundle is listed in the Copy Bundle Resources section of the Build Phases section of the 
Target of your app. 
If not listed, follow the same process and use the + button, Add Other, SDK > Frameworks and the RMCharacter.bundle file.
     
