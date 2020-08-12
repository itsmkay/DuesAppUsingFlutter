# dues

An App which keeps the records of Dues of the user. It uses Firebase to sync the data on the online server so that user can login in different devices and still does not lose their data. The app is basically build using Flutter with Dart programming language. User can select between Google and Facebook to login to the app. 

## Getting Started

This project is my first Flutter App which I build and now I am making it public so that all the beginners like me can look at the code and probably can learn something from it. 

I used Firebase to sync the data on the online server and also to login the user to the app. 

Rather than using my own verification logic to verify the user I used "Sign in with Google" and "Login with Facebook". 

In this project I have implemented *Provider Class* approach to provide the data to all the required widgets when needed.

A provider class is a special class which is declared with mixin with ChangeNotifier class.

In provider class we can run NotifyListeners whenever we change the data inside the provider class. So that all the listener widgets can rebuild themselves with the new data provided by the provider class.

I also used *SliverAppBar* and *SliverList* to give the app a nicer look.


## Screenshots

<p align="start">
  <img src="https://github.com/itsmkay/DuesAppUsingFlutter/raw/master/screenshots/login_screen.png" width="250" length="600" title="Login Screen">
  <img src="https://github.com/itsmkay/DuesAppUsingFlutter/raw/master/screenshots/home_screen.png" width="250" length="600" title="Home Screen">
  <img src="https://github.com/itsmkay/DuesAppUsingFlutter/raw/master/screenshots/drawer.png" width="250" length="600" title="Drawer Screen">
  <img src="https://github.com/itsmkay/DuesAppUsingFlutter/raw/master/screenshots/add_screen.png" width="250" length="600" title="Add Expense Screen">
  <img src="https://github.com/itsmkay/DuesAppUsingFlutter/raw/master/screenshots/account_screen.png" width="250" length="600" title="Account Screen">
  <img src="https://github.com/itsmkay/DuesAppUsingFlutter/raw/master/screenshots/settle_up_screen.png" width="250" length="600" title="Settle up Screen">
</p>
