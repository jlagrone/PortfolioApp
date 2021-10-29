# Unit Converter

<p align="center">
    <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" />
    <img src="https://img.shields.io/badge/Swift-5.0-brightgreen.svg" />
    <a href="https://twitter.com/jlagrone86">
        <img src="https://img.shields.io/badge/Contact-@jlagrone86-lightgrey.svg?style=flat" alt="Twitter: @jlagrone86" />
    </a>
</p>

Unit Converter is a simple iOS app for converting length, volume, pressure, temperature, and mass to other units. 
A history of conversions is kept automatically. I made this app for my own use and is not available in the App Store.

## License
Please read the [license](LICENSE.md) before using.

## Discussion
The app tries to leverage Apple's Measurement API for doing conversions between common units in the 
Metric and Imperial systems. However, I encountered issues with the Measurement and Unit classes. 
See Apple Feedback FB9708766 and FB9711946.

Unit Converter is localized for Spanish and implements some accessibility for Voice Over. Users can set preferences for output such as formatting the result of concersion using Scientific Notation or Significant Digits.
    
