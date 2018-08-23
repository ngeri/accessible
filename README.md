
# Accessible
**Accessible** is tool which makes your UITesting experience way better on iOS.
#### Table of Contents
1. [Intro](#intro)
2. [Usages](#usage)
## Intro <a name="intro"></a>
**Accessible** parses your `.storyboard` files and generates accessibilityIdentifiers for every `IBOutlet` connection.
```swift
enum Accessible {
    struct Storyboard {
        struct Screen { 
            static let rootView = "Accessible.Storyboard.Screen.rootView"
            struct UIElementTpye {
                static let aView = "Accessible.Storyboard.Screen.UIElementTpye.aView"
            }
            ...
        }
        ...
    }
    ...
}
```
UITestableExtensions.swift makes setting the previously generated id-s for every UIElement easy.
If you provide UITestableExtensions.swift path then **Accessible** will also generate a Swift file like below.
```swift

protocol UITestable {
    func setAccessibilityIdentifiers()
}

extension ScreenViewController: UITestable {
    func setAccessibilityIdentifiers() {
        view.accessibilityIdentifier = Accessible.Storyboard.Screen.rootView
        aView.accessibilityIdentifier = Accessible.Storyboard.Screen.UIElementTpye.aView
        ...
    } 
}
...
```
You should call ``` setAccessibilityIdentifiers()``` in the ```viewDidLoad()``` method of the UIViewController instance.

UITapMans.swift makes writing XCTestCase files way more fun then previously. 
```swift
class ScreenUITests: XCTestCase {
    var tapMan: ScreenTapMan!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        tapMan = OnboardingTapMan().start()
    }
  
    func testCaseA() {
        tapMan
           .aView.isHittable()
           .aView.tap()
    }
}
```

## Usage <a name="usage"></a>

1. Download the latest [released binary](https://github.com/ngergo100/Accessible/releases/download/0.0.1/accessible).
2. Make it executable with `chmod +x accessible`. (If you have a .dms extension then remove it first)
3. Copy it to `/usr/local/bin/`.

You should create a `.accessible.yml` configuration file in your project's root directory (next to your project file).
```yaml
#enumName: Accessible
inputs: 
  - Path/To/Storyboards
  - Path/To/OtherStoryboards
  - Path/To/One/SpecificStoryboard.storyboard
outputs:
  identifiersPath: Directory/Of/Generated/Files
  #testableExtensionsPath: Directory/Of/Generated/Files
  #tapMansPath: Directory/Of/Generated/Files
```

Uncomment `enumName` if you would like to provide the Accessibiliy Identifiers enum's name.

Uncomment `testableExtensionsPath` if you would like **Accessible** to generate UITestableExtensions.swift file for you.

Uncomment `tapMansPath` if you would like **Accessible** to generate UITapMans.swift file for you.

If your done with the configuration file. The only thing left is calling `accessible` in the root directory of your project or set up a new run script build phase in your Xcode project file.



