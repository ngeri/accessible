import IBDecodable

struct FakeViewController: ViewControllerProtocol {
    var elementClass: String
    var storyboardIdentifier: String?
    var sceneMemberID: String?
    var layoutGuides: [ViewControllerLayoutGuide]?
    var userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    var connections: [AnyConnection]?
    var keyCommands: [KeyCommand]?
    var tabBarItem: TabBar.TabBarItem?
    var rootView: ViewProtocol?
    var size: [Size]?
    var id: String
    var customClass: String?
    var customModule: String?
    var customModuleProvider: String?
    var userLabel: String?
    var colorLabel: String?
    
    init(customClass: String) {
        self.elementClass = "UIViewController"
        self.id = "id"
        self.customClass = customClass
    }
}
