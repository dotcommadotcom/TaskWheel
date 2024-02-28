import SwiftUI

enum IconItem: Identifiable, Hashable {
    
    case details, schedule, priority, complete, trash, save, lists, order, more, add
    
    var id: Self {
        self
    }
    
    var icon: String {
        switch self {
        case .details: return "text.alignleft"
        case .schedule: return "alarm"
        case .priority: return "tag"
        case .complete: return "square"
        case .trash: return "trash"
        case .save: return "square.and.arrow.down"
        case .lists: return "list.dash"
        case .order: return "arrow.up.arrow.down"
        case .more: return "ellipsis"
        case .add: return "plus.square"
        }
    }
    
    var altIcon: String {
        switch self {
        case .complete: return "checkmark.square"
        case .priority: return "tag.fill"
        default: return self.icon
        }
    }
}
