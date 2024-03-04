import SwiftUI

enum IconItem: Identifiable, Hashable {
    
    case details, schedule, priority, complete, delete, save, lists, order, more, add, settings
    
    var id: Self {
        self
    }
    
    var name: String {
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
        case .settings: return "gearshape.fill"
        }
    }
    
    var alternative: String {
        switch self {
        case .complete: return "checkmark.square"
        case .priority: return "tag.fill"
        default: return self.name
        }
    }
}

struct IconView: View {
    let icon: IconItem
    var isSpace: Bool = false
    var isAlt: Bool = false
    var size: CGFloat = 25
    
    var body: some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Image(systemName: !isAlt ? icon.name : icon.alternative)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: icon == .save ? size + 4 : size)
        }
    }
}

#Preview("icon") {
    IconView(icon: .lists)
}
