struct ConnectionTypeTemplate {
    let name: String
    let connections: [ConnectionTemplate]

    enum ViewType: String {

        case activityIndicators = "activityIndicators"
        case buttons = "buttons"
        case collectionViews = "collectionViews"
        case datePickers = "datePickers"
        case imageViews = "images"
        case staticTexts = "staticTexts"
        case navigationBars = "navigationBars"
        case pageIndicators = "pageIndicators"
        case pickers = "pickers"
        case progressIndicators = "progressIndicators"
        case scrollViews = "scrollViews"
        case searchFields = "searchFields"
        case segmentedControls = "segmentedControls"
        case sliders = "sliders"
        case otherElements = "otherElements"
        case steppers = "steppers"
        case switches = "switches"
        case tabBars = "tabBars"
        case tables = "tables"
        case cells = "cells"
        case textFields = "textFields"
        case textViews = "textViews"
        case toolbars = "toolbars"
        case webViews = "webViews"
    }

    init(name: ConnectionTypeTemplate.ViewType, connections: [ConnectionTemplate]) {
        self.name = name.rawValue
        self.connections = connections
    }


    static func mapViewClassToViewType(type: String) -> ViewType {
        switch type {
        case "UIActivityindicatorView":     return .activityIndicators
        case "UIButton":                    return .buttons
        case "UICollectionView":            return .collectionViews
        case "UICollectionViewCell":        return .cells
        case "UIDatePicker":                return .datePickers
        case "UIImageView":                 return .imageViews
        case "UILabel":                     return .staticTexts
        case "UINavigationBar":             return .navigationBars
        case "UIPageControl":               return .pageIndicators
        case "UIPickerView":                return .pickers
        case "UIProgressView":              return .progressIndicators
        case "UIScrollView":                return .scrollViews
        case "UISearchBar":                 return .searchFields
        case "UISegmentedControl":          return .segmentedControls
        case "UISlider":                    return .sliders
        case "UIStackView":                 return .otherElements
        case "UIStepper":                   return .steppers
        case "UISwitch":                    return .switches
        case "UITabBar":                    return .tabBars
        case "UITableView":                 return .tables
        case "UITableViewCell":             return .cells
        case "UITextField":                 return .textFields
        case "UITextView":                  return .textViews
        case "UIToolbar":                   return .toolbars
        case "UIView":                      return .otherElements
        case "UIVisualEffectView":          return .otherElements
        case "WKWebView":                   return .webViews
        default:
            print("\(type) is not known")
            return .otherElements
        }
    }
}
