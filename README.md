# Smart Pharmacy 🩺

## Author: Team Droplet
- Pham Hoang Long - s3938007
- Do Phan Nhat Anh - s3915034
- Dinh Le Hong Tin - s3932134
- Ngo Ngoc Thinh - s3879364

## Description

- Smart Pharmacy is an AI-powered e-Pharmacist application.
- Smart Pharmacy aims to bridge the healthcare gap between rural and urban areas by providing underserved communities with digital access to essential medications, health consultations, and prescriptions, improving health outcomes where medical services are limited, such as rural areas in Vietnam.

<p align="center">
  <img src="https://github.com/user-attachments/assets/86ff6cdf-8750-45db-b67b-07c8a8c7ab73" width="300" style="display: inline-block;" > 
  <img src="https://github.com/user-attachments/assets/1f1a2a67-38b1-472e-b25d-b4ba8eff9923" width="300" style="display: inline-block;" > 
  <img src="https://github.com/user-attachments/assets/5dbdf365-7484-4502-a8fd-41bae3ef8003" width="300" style="display: inline-block;" > 
</p>

## Demo



## Build Information
- Xcode 15.4
- SwiftUI Framework
- Target Deployment: iOS 17.5
- Library:
  - [FirebaseAnalytics](https://github.com/firebase/firebase-ios-sdk.git)
  - [FirebaseAuth](https://github.com/firebase/firebase-ios-sdk.git)
  - [FirebaseFirestore](https://github.com/firebase/firebase-ios-sdk.git)
  - [FirebaseStorage](https://github.com/firebase/firebase-ios-sdk.git)
  - [FirebaseFunctions](https://github.com/firebase/firebase-ios-sdk.git)
  - [FirebaseMessaging](https://github.com/firebase/firebase-ios-sdk.git)
  - [GoogleSignIn](https://github.com/google/GoogleSignIn-iOS)
  - [GoogleSignInSwift](https://github.com/google/GoogleSignIn-iOS)
  - [FacebookCore](https://github.com/facebook/facebook-ios-sdk)
  - [FacebookLogin](https://github.com/facebook/facebook-ios-sdk)
  - [ChatGPTSwift](https://github.com/alfianlosari/ChatGPTSwift.git)
  - [Stripe](https://github.com/stripe/stripe-ios-spm)
  - [StripePaymentSheet](https://github.com/stripe/stripe-ios-spm)
  - [ActivityIndicatorView](https://github.com/exyte/ActivityIndicatorView.git)
  - [PopupView](https://github.com/exyte/PopupView.git)
  - [WrappingHStack](https://github.com/dkk/WrappingHStack)


##  External Libraries Installation Instructions

Before running the project, all dependency libaries must be installed. If not, follow these steps to install the dependencies using Swift Package Manager and run the project in Xcode:

### 1. Clone and Open the Project in Xcode
- Clone the repository to your local machine.
- Open the project in Xcode.

### 2. Add Dependencies via Swift Package Manager
- In the Project Navigator, click on your project (e.g., `pharmacist_project`).
- Select your app target (`pharmacist_project`) and go to the **Package Dependencies** tab.
- For each required package:
  
  a. Click the "+" button at the bottom of the package list.
  
  b. In the search field, paste the dependency URL (e.g., `https://github.com/firebase/firebase-ios-sdk.git`).
  
  c. Choose the dependency rule “Up to next major version” and click **Add Package**.
  
  d. A list of modules for that package will appear. Select the appropriate modules based on the **Name** column from the dependencies table (e.g., for `https://github.com/google/GoogleSignIn-iOS`, select both `GoogleSignIn` and `GoogleSignInSwift`).
  
  e. Under "Add to Target," ensure that the current target (`pharmacist_project`) is selected.
  
  f. Click **Add Package** to complete the process.

- Repeat steps 2.a to 2.f for all required dependencies.

### 3. Run the Project
- Once all dependencies are installed, press `Command + R` to build and run the project in Xcode.

