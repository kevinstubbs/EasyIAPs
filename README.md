# EasyIAPs

[![CI Status](http://img.shields.io/travis/Alvin Varghese/EasyIAPs.svg?style=flat)](https://travis-ci.org/Alvin Varghese/EasyIAPs)
[![Version](https://img.shields.io/cocoapods/v/EasyIAPs.svg?style=flat)](http://cocoapods.org/pods/EasyIAPs)
[![License](https://img.shields.io/cocoapods/l/EasyIAPs.svg?style=flat)](http://cocoapods.org/pods/EasyIAPs)
[![Platform](https://img.shields.io/cocoapods/p/EasyIAPs.svg?style=flat)](http://cocoapods.org/pods/EasyIAPs)

## Features

- [x] In App Purchases and receipt validation via server.


## Requirements
  iOS 9.0+ 
  Xcode 7.3+
  
## Communication

* If you need help, open an issue.
* If you'd like to ask a general question, open an issue.
* If you found a bug, open an issue.
* If you have a feature request, open an issue.
* If you want to contribute, submit a pull request.

## Installation

**CocoaPods**

EasyIAPs is available through [CocoaPods](http://cocoapods.org). CocoaPods is a dependency manager for Cocoa projects. To install it run this command in Terminal app. *CocoaPods 1.0.0 is required to build EasyIAPs 0.1.0*.

```ruby
gem install cocoapods
```
Then, run the following command from your projects directory to initialise CocoaPods in your project.

```ruby
$ pod init
```

To integrate EasyIAPs into your project using CocoaPods, simply add pod 'EasyIAPs' to your Podfile.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'YourApp' do

  use_frameworks!
  pod 'EasyIAPs'
  
  target 'YourAppTests' do
    inherit! :search_paths
  end

  target 'YourAppUITests' do
    inherit! :search_paths
  end

end

```

Then, run the following command.

```ruby
$ pod install
```

**Manually**

## Usage


|   Error Code    |      Error Type                 |     Error Description  |
| ----------------|:-------------------------------:| :---------------------:|
|     21000       |   CouldNotReadJSON              | The App Store could not read the JSON object you provided |
|     21002       |   DataMalformedOrMissing        | The data in the receipt-data property was malformed or missing |
|     21003       |   CouldNotAuthenticate          | The receipt could not be authenticated |
|     21004       |   DoesNotMatchSharedSecret      | The shared secret you provided does not match the shared secret on file for your account |
|     21005       |   ReceiptServerNotAvailable     | The receipt server is not currently available |
|     21006       |   SubscriptionExpired           | This receipt is valid but the subscription has expired. |
|     21007       |   TestEnvironmentReceipt        | This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead. |
|     21008       |   ProductionEnvironmentReceipt  | This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead. |


## FAQ

## Credits

## Author

Alvin Varghese, alvin@nfnlabs.in

## License

EasyIAPs is available under the MIT license. See the LICENSE file for more info.
