
# Swift Xcode Project

Main swift code can't be a Folder Reference.
`Swift Compiler`` won't appear in `Build Settings` if the folder containing the app Swift code isn't a group.


- For `elements_of_interest` and `PrivateHeaders`
  - Create folder references
  - Add to targets: elements_of_interest
- Build Phases -> Compile Sources -> Add elements_of_interest folder


- Add Headers phase (must be Public)
  - XCTest.framework (Add Other -> Folder Reference)
    - /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks/XCTest.framework
  - bridge.h (Add Other -> Folder Reference)
  - PrivateHeaders

- Build Settings -> Objective C bridging header -> $(PROJECT_DIR)/$(PROJECT_NAME)/bridge.h
- Build Phases -> Link Binary With Libraries -> XCTest.framework  (Add Other -> Folder Reference)
  - /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks/XCTest.framework

- Build Settings -> Header Search Paths ->
  - $(PROJECT_DIR)/PrivateHeaders
- Build Settings -> Framework Search Paths
  - $(PLATFORM_DIR)/Developer/Library/Frameworks
- Build Settings -> Runpath Search Paths
  - @executable_path

-----

Facebook's WebDriverAgent links with frameworks via the other linker flags.

- Other Linker Flags
  - $(inherited)
  -  -l"Accessibility"
  -  -framework
  -  "XCTest"

They also modify LD_RUNPATH_SEARCH_PATHS to include:

- Runtime Search Paths
  - $(inherited)
  - @executable_path/Frameworks
  - "$(SDKROOT)/Developer/Library/PrivateFrameworks"
  - "$(SDKROOT)/System/Library/PrivateFrameworks"

The module header must be public or Xcode will complain.