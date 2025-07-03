## Currency Exchange app

## This is an iOS application built with Swift(UIkit), following **MVVM (Model-View-ViewModel)** design pattern and **Clean Architecture** principles. This app has list of currencies and user can convert currencies based on a base currency

## Features

- Fetch and display a list of currency and rates based on a base currency.
- Built using **MVVM** and **Clean Architecture** to ensure scalability and maintainability.
- Built with RxSwift and CoreData
- Can use this project as a Template for future projects

---

## Technologies Used

- **Swift**: Programming language.
- **UIkit/RxCocoa**: UI framework.
- **RxSwift**: For managing asynchronous events.
- **Clean Architecture**: Ensures maintainable and scalable code.
- **MVVM**: Design pattern for clear separation of concerns.
- **exchangeratesapi.io**: To fetch currency rates

---

## Installation

1. Clone the repository:
   ```bash
   git clone git@gitlab.com:refatIbnAnwar/trooper-currency-converter.git
   ```
2. Navigate to the project directory:
   ```bash
   cd trooper-currency-converter
   ```
3. Open the `.xcodeproj` file in Xcode:
   ```bash
   open trooper-currency-converter.xcworkspace
   ```
4. Change the API_key with your API Key in the AppConstant.swift file

   ```swift
   static let apiKey : String = "my_api_key"
   ```

5. Build and run the app on a simulator or a physical device.

6. If you encounter any issue with pod, install the pod again with this command
   ```bash
   pod install
   ```

---

## Usage

1. Launch the app.
2. Select the currency and see the exchange rate
3. Can use the offline mode
4. See the graph for a better understanding

---

---

## Limitation

- Could not project the 1-week historical rate on the graph because of the free API limitation.
- Could not project same-day rates because free api limitation.

## Contact

For questions or feedback, feel free to reach out:

- **Email**: refatibnanwar@gmail.com

---
