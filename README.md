
# JubaExpressSDK-iOS Integration Guide

JubaExpress SDK allows seamless integration of JubaExpress payment services into your iOS applications. This document outlines the steps required to integrate the JubaExpress SDK into your project and initialize it to start sending payments.


## Compatibility

- iOS 13+
- Xcode 13+


## Documentation

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website.

To integrate JubaExpress SDK into your iOS project, Add the following line to your Podfile:


## Installation
```bash
  pod 'JubaExpressSDK' 
```
    
## Import SDK

Import the JubaExpressSDK in the ViewController where you want to initialize it:

```bash
  import JubaExpressSDK 
```


## Initialization
Initialize the JubaExpressSDK with the required `JESDKConfiguration` and a reference to the root view controller. The initialization process requires configuration parameters such as `JESSDKCustomerDocument`, `JESSDKCustomerName`, and `JESSDKCustomerInfo` objects

#### JESSDKCustomerDocument

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Document Type` | `string` | **Required** |
| `Document Number` | `string` | **Required** |
| `Document Issue Date` | `string` | **Required** |
| `Document Expiry Date` | `string` | **Required** |
| `Document Issuing Country` | `string` | **Required** |


#### JESSDKCustomerName


| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `First Name` | `string` | **Required** |
| `Middle Name` | `string` | **Required** |
| `Last Name` | `string` | **Required** |

#### JESSDKCustomerInfo


| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `CIF (Customer Identification Number)` | `string` | **Required** |
| `Mobile` | `string` | **Required** |
| `Email` | `string` | **Required** |
| `Nationality` | `string` | **Required** |
| `Date of Birth` | `string` | **Required** |
| `Place of Birth` | `string` | **Required** |
| `Gender` | `string` | **Required** |
| `JESSDKCustomerName` object | `string` | **Required** |
| `JESSDKCustomerDocument` object | `string` | **Required** |

## JESDKConfiguration

Initialise JESSDKCustomerName Object

```bash
let customerNameObject = JESSDKCustomerName(FirstName: "<Customer First Name>", 
  MiddleName: "<Customer Middle Name>",
  LastName: "<Customer Last Name>")
```

Initialise JESSDKCustomerDocument Object

```bash
let customerDocumentObject = JESSDKCustomerDocument(DocumentType: "<DocumentType>",
  DocumentNumber: "<DocumentNumber>",
  DocumentIssueDate: "<DocumentIssueDate>",
  DocumentExpiryDate: "<DocumentExpiryDate>",
  DocumentIssuingCountry: "<DocumentIssuingCountry>")
```

Initialise JESSDKCustomerInfo Object

```bash
let customerInfoObject = JESSDKCustomerInfo(name:customerNameObject,
  CIF: "<CIF>",
  mobile: "<mobile>",
  nationality: "<nationality>",
  DateOfBirth: "<DateOfBirth>",
  PlaceOfBirth: "<PlaceOfBirth>",
  Gender: "<Gender>",
  Document: customerDocumentObject)
```
After creating the necessary objects for customer document, customer name, and customer information, proceed to create a `JESDKConfiguration` object:


```bash
let configuration = JESDKConfiguration(BaseURL: "<BaseURL>",
  SubscriptionKey: "<SubscriptionKey>",
  PartnerKey: "<PartnerKey>",
  referenceid: "<referenceid>",
  enviroment: "<enviroment>",
  customerInfo: customerInfoObject)
```

Finally, initialize the SDK by calling:

```bash
JESDK.init(configuration: configuration, root: self) 
```

## JubaExpressSDK Delegate

To receive delegate callbacks, set the delegate of the shared instance of JESDK:

```bash
JESKD.sharedInstance()?.delegate = self  
```

Upon creation of transaction, the SDK will return a payment object. This object contains the transaction `secretkey` and `referenceID` which can be utilized as required.

```bash
ViewController: JESDKDelegate {
    
    func JESDKSecretKey(payment: Payment) {
        let secretKey = payment.secretkey
        let referenceId = payment.referenceId
        
        // handle your payment process
    }
}
```
##  Transaction Receipt

Upon successful payment you will get `ReferenceId` from your payment partner ,  to view transaction receipt  Via JubaExpressSDK  initialize the SDK by calling:

```bash
let configuration = JESDKConfiguration(subscriptionKey:
  "<Your_Subscription_Key>", 
  partnerKey: "<Your_Partner_Key>", 
  referenceID: "<Your_Reference_ID>",
  environment: .UAT,
  customerInfo: customerInfoObject)  

  JESDK.init(configuration: configuration, root: self) 
```

You will redirect to transaction receipt screen. 

## Theme Color Customization

JubaExpress SDK provides theme color customization options. Ensure to set the theme colors before initializing the SDK. You can customize `primary color`, `secondary color`, `tertiary color`, `field background color`, `heading color`, `button text color`, and `button background color`.

```bash
JESDK.setPrimaryColor("YourPrimaryColor")
JESDK.setSecondaryColor("YourSecondaryColor")
JESDK.setTertionaryColor("YourTertionaryColor")
JESDK.setBackgroundColor("YourColor")
JESDK.setTopHeadingColor("YourColor")
JESDK.setButtonTextColor("YourColor")
JESDK.setButtonBackgroundColor("YourColor")
```


**Note: Theme color customization should be set before calling the SDK initialization method.**
 
By following these steps, you can seamlessly integrate JubaExpress SDK into your iOS application and leverage its functionalities for payment processing.
