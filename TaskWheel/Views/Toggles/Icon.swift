import SwiftUI

enum IconItem: Identifiable, Hashable {
    
    case complete, details, priority, schedule
    
    case shuffle, lists, order, filter, more, add

    case cancel, delete, save, move, settings, ticker
    
    var id: Self {
        self
    }
    
    var name: String {
        switch self {
        case .complete: return "square"
        case .details: return "text.alignleft"
        case .priority: return "tag"
        case .schedule: return "alarm"
            
        case .shuffle: return "checkmark.gobackward"
        case .lists: return "list.dash"
        case .order: return "arrow.up.arrow.down"
        case .filter: return "slider.horizontal.3"
        case .more: return "ellipsis"
        case .add: return "plus.square"
            
        case .cancel: return "xmark"
        case .delete: return "trash"
        case .save: return "square.and.arrow.down"
        case .move: return "chevron.up.chevron.down"
        case .settings: return "gearshape.fill"
        case .ticker: return "arrowtriangle.backward.fill"
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

struct Icon: View {
    let this: IconItem
    var isSpace: Bool = false
    var isAlt: Bool = false
    var isFill: Bool = false
    var size: CGFloat = 25
    
    var body: some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            ZStack {
                if isFill {
                    Image(systemName: this.name + ".fill")
                        .opacity(0.2)
                }
                
                Image(systemName: !isAlt ? this.name : this.alternative)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: this == .cancel ? size * 0.8 : size,
                   height: this == .cancel ? size * 0.8 : this == .save ? size * 1.1 : size)
            
        }
    }
}

#Preview("icons") {
    let icons: [IconItem] = [.lists, .order, .more, .add, .settings, .cancel, .delete, .save, .move]
    
    return HStack {
        ForEach(icons, id: \.self) { icon in
            Icon(this: icon)
        }
    }
}
