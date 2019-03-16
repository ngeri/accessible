import PathKit

struct AccessibleEditor {
    static func enrichStoryboardsWithAccessible(storyboardTemplates: [StoryboardTemplate]) {
        for storyboardTemplate in storyboardTemplates {
            guard let storyboard = try? Path(storyboardTemplate.filePath).read(.utf8) else { continue }
        }
    }
}
