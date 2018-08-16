struct ConnectionTemplate {

    let name: String
    let connections: [Connection]

    init(type: String, connections: [Connection]) {
        switch type {
        case "UIActivityindicatorView":     name = "activityIndicators"
        case "UIButton":                    name = "buttons"
        case "UICollectionView":            name = "collectionViews"
        case "UICollectionViewCell":        name = "cells"
        case "UIDatePicker":                name = "datePickers"
        case "UIImageView":                 name = "imageViews"
        case "UILabel":                     name = "staticTexts"
        case "UINavigationBar":             name = "navigationBars"
        case "UIPageControl":               name = "pageIndicators"
        case "UIPickerView":                name = "pickers"
        case "UIProgressView":              name = "progressIndicators"
        case "UIScrollView":                name = "scrollViews"
        case "UISearchBar":                 name = "searchFields"
        case "UISegmentedControl":          name = "segmentedControls"
        case "UISlider":                    name = "sliders"
        case "UIStackView":                 name = "otherElements"
        case "UIStepper":                   name = "steppers"
        case "UISwitch":                    name = "switches"
        case "UITabBar":                    name = "tabBars"
        case "UITableView":                 name = "tables"
        case "UITableViewCell":             name = "cells"
        case "UITextField":                 name = "textFields"
        case "UITextView":                  name = "textViews"
        case "UIToolbar":                   name = "toolbars"
        case "UIView":                      name = "otherElements"
        case "UIVisualEffectView":          name = "otherElements"
        case "WKWebView":                   name = "webViews"
        default:
            print("\(type) is not known")
            name = "otherElements"
        }
        self.connections = connections
    }
}
