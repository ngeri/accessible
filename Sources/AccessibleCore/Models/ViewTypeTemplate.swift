struct ViewTypeTemplate {
    let name: String
    let viewTemplates: [ViewTemplate]

    enum ViewType: String {

        case activityIndicators
        case buttons
        case collectionViews
        case datePickers
        case imageViews = "images"
        case staticTexts
        case navigationBars
        case pageIndicators
        case pickers
        case progressIndicators
        case scrollViews
        case searchFields
        case segmentedControls
        case sliders
        case otherElements
        case steppers
        case switches
        case tabBars
        case tables
        case cells
        case textFields
        case textViews
        case toolbars
        case webViews
    }

    init(name: ViewTypeTemplate.ViewType, viewTemplates: [ViewTemplate]) {
        self.name = name.rawValue
        self.viewTemplates = viewTemplates
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
