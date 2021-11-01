[![Build main](https://github.com/tkausch/MyUplink2/actions/workflows/swift.yml/badge.svg)](https://github.com/tkausch/MyUplink2/actions/workflows/swift.yml)


# myuplink
The myUplink API is a RESTful API to access public data from the NIBE S-Series heat pumps. This Swift library provides a simple client using this RESTful API. 

- No third party dependencies - only Swift Foundation libraries
- Authentication/Authorization with Openid Connect using autorisation code flow
- Fully UnitTested against a PostmanMock

Get more information about the public RESTful MyUplink API from [myUplink](https://dev.myuplink.com)


## Installation
MyUplinkSwift is packaged as a Swift framdework. Currently this is the simplest way to add it to your app:
- Drag MyUplink.xcodeproj to your project in the Project Navigator.
- Select your project and then your app target. Open the Build Phases panel.
- Expand the Target Dependencies group, and add `MyUplink` framework.
- import `MyUplink` whenever you want to use OAuthSwift.


### Swift Package Manager Support 

```
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(name: "MyUplink",
            url: "https://https://github.com/tkausch/MyUplinkSwift.git",
            .upToNextMajor(from: "0.1.0"))
    ]
)
```
