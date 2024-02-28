import SwiftUI

enum IconItem: Identifiable, Hashable {
    
    case details, schedule, priority, complete, delete, save, lists, order, more, add
    
    var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .details: return "text.alignleft"
        case .schedule: return "alarm"
        case .priority: return "tag"
        case .complete: return "square"
        case .delete: return "trash"
        case .save: return "square.and.arrow.down"
        case .lists: return "list.dash"
        case .order: return "arrow.up.arrow.down"
        case .more: return "ellipsis"
        case .add: return "plus.square"
        }
    }
    
    var alternative: String {
        switch self {
        case .complete: return "checkmark.square"
        case .priority: return "tag.fill"
        default: return self.text
        }
    }
}
