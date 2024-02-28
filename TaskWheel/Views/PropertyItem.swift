import SwiftUI

enum PropertyItem: Identifiable, Hashable {
    
    case details, complete, schedule, priority, save
    
    var id: Self {
        self
    }
    
    var icon: String {
        switch self {
        case .details: return "text.alignleft"
        case .complete: return "square"
        case .schedule: return "alarm"
        case .priority: return "tag"
        case .save: return "square.and.arrow.down"
        }
    }
    
    var altIcon: String {
        switch self {
        case .complete: return "checkmark.square"
        case .priority: return "tag.fill"
        default: return self.icon
        }
    }
    
    var emptyText: String {
        switch self {
        case .details: return "Add details"
        case .complete: return "Incomplete"
        case .schedule: return "Set schedule"
        case .priority: return "Add priority"
        default: return ""
        }
    }
    
    var fullText: String {
        switch self {
        case .complete: return "All done"
        default: return "Should be hidden"
        }
    }
    
    var color: Color {
        switch self {
        case .save: return .gray
        default: return ColorSettings().text
        }
    }
    
    var accent: Color {
        switch self {
        case .save: return ColorSettings().text
        default: return ColorSettings().accent
        }
    }
}
