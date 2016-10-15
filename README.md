# EasyIAPs

[![CI Status](http://img.shields.io/travis/Alvin Varghese/EasyIAPs.svg?style=flat)](https://travis-ci.org/Alvin Varghese/EasyIAPs)
[![Version](https://img.shields.io/cocoapods/v/EasyIAPs.svg?style=flat)](http://cocoapods.org/pods/EasyIAPs)
[![License](https://img.shields.io/cocoapods/l/EasyIAPs.svg?style=flat)](http://cocoapods.org/pods/EasyIAPs)
[![Platform](https://img.shields.io/cocoapods/p/EasyIAPs.svg?style=flat)](http://cocoapods.org/pods/EasyIAPs)

## Features

- [x] In-App Purchases supports only Consumables.
- [x] In-App Purchases and receipt validation via server.
- [ ] A receipt validation server for testing [ Will be available in 0.1.5 ].
- [ ] Non-Consumables, Auto-Renewable Subscriptions, Free Subscriptions, Non-Renewing Subscriptions [ Will be available in 0.1.5 ].


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

## Usage

This how you should call EasyIAP in your viewController. Input your product name and reciept validating server URL, if you dont have one you can just put **https://sandbox.itunes.apple.com/verifyReceipt**.

```
EasyIAP().startProductRequest("BuyMoreCoins", receiptValidatingServerURL: "https://yourReceiptValidatingURL.com", loaderRingColor : UIColor.greenColor() , restore: false) { (success, error) in
            
            if let properError = error {
                print(properError.description)
            } else {
                print(success)
            }
        }
```

The receipt validation server should always get the data from the key "receipt-data", HTTP POST will be send like the following strucutre.

```
HTTPBody = { "receipt-data" : base64EncodedReceiptData }
HTTPHeaderField = application/json : Content-Type
HTTPHeaderField = base64EncodedReceiptDataLength : Content-Length // Put your NSData() length in this header
HTTPHeaderField = application/json : Accept
```

Always check whether the error is nil or not, if it is not nil you can get a proper explanation for it by calling the error description. Please take a look at all errors from the table below.

Also you don't have to worry about putting a loader. EasyIAP takes care of it. Please input your favorite color in the function call for the loader color.

#Errors 

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
|     100         |   NoProducts                    | There are no products available |
|     101         |   NoProductFound                | No product found in iTunesConnect for the requested product name |
|     102         |   CantMakePayments              | You can not make payments |
|     103         |   NotAValidReceiptURL           | Not a valid url, Please check your receipt validating server url |
|     104         |   DidntMakeAnyPayments          | You did not make any payments |
|     105         |   CouldNotRestore               | Could not restore the requested product |
|     106         |   ProductRequestFailed          | Product request failed |
|     107         |CoultNotParseJSONFromRecieptServer| Could not parse JSON recieved from receipt server |
|     108         |StatusKeyDoesNotExistsInJSON     | Status key does not exists in receipt response JSON |
|     109         |CouldNotConvertReceiptURLToNSData| Could not convert receipt url to NSData |
|     110         |   ReceiptURLDoesNotExists       | Receipt URL does not reachable |
|     111         |   NoResponseFromServer          | No response from server |
|     500         |   NoError :)                    | Just to tell you that there was no error - You will not be using this|
|     501         |   CantRunInSimulator            | Please run the app in Physical device rather than in iOS Simulator |

Also if you are using your own receipt validating URL and if it does not have a valid SSL installed you should add your domain name into **App Transport Security Settings**. Just copy paste this in your info.plist file.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSExceptionDomains</key>
	<dict>
		<key>www.yourdomain.com</key>
		<dict>
			<key>NSExceptionAllowsInsecureHTTPLoads</key>
			<true/>
			<key>NSIncludesSubdomains</key>
			<true/>
		</dict>
	</dict>
</dict>
</plist>

```

**EasyIAP will not work in iOS Simulator, You should run this in a Physical device**


## Credits

Swift Coder Club, http://swiftcoder.club

## Author

Alvin Varghese, alvin@nfnlabs.in

## License

EasyIAPs is available under the MIT license. See the LICENSE file for more info.
