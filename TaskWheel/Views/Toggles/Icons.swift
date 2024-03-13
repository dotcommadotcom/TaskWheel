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
    
    var title: String {
        switch self {
        case .complete: return "square"
        case .details: return "text.alignleft"
        case .priority: return "tag"
        case .schedule: return "alarm"
            
        case .shuffle: return ""
        case .lists: return "Select list"
        case .order: return "Change order"
        case .filter: return ""
        case .more: return "More options"
        case .add: return "Add task"
            
        case .cancel: return "xmark"
        case .delete: return "trash"
        case .save: return "square.and.arrow.down"
        case .move: return "chevron.up.chevron.down"
        case .settings: return "gearshape.fill"
        case .ticker: return "arrowtriangle.backward.fill"
        }
    }
    
    var adjust: Double {
        switch self {
        case .cancel: return 0.8
        case .save: return 1.1
        case .move: return 0.6
        default: return 1.0
        }
    }
}

struct Icon: View {
    let this: IconItem
    let text: String
    var isSpace: Bool = false
    var isAlt: Bool = false
    var isFill: Bool = false
    let size: SizeItem
    let weight: Font.Weight
    let style: any LabelStyle
    //    Icon(this: .move, text: taskViewModel.currentTitle(), size: sizeOrder.scale, style: hideIcon? .text : .both)
    
    
    init(
        this: IconItem,
        text: String = "",
        isSpace: Bool = false,
        isAlt: Bool = false,
        isFill: Bool = false,
        size: SizeItem = .medium,
        weight: Font.Weight = .regular,
        style: any LabelStyle = Default()
    ) {
        self.this = this
        self.text = text
        self.size = size
        self.weight = weight
        self.isSpace = isSpace
        self.isAlt = isAlt
        self.isFill = isFill
        self.style = style
    }
    
    var body: some View {
        AnyView(
            Label {
                Text(text).font(size.font)
            } icon: {
                ZStack {
                    if isFill {
                        Image(systemName: this.name + ".fill")
                            .opacity(0.2)
                    }
                    
                    Image(systemName: !isAlt ? this.name : this.alternative)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: size.scale * this.adjust, height: size.scale * this.adjust)
            }
            .labelStyle(style)
        )
    }
}

struct Default: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.icon
            configuration.title
        }
    }
}

struct TextOnly: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.title
    }
}

struct IconOnly: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.icon
    }
}

struct Backward: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            configuration.title
            configuration.icon
        }
    }
}

#Preview("default") {
    Icon(this: .move, text: "sample task list", style: Default())
}

//#Preview("icons") {
//    let icons: [IconItem] = [.lists, .order, .more, .add, .settings, .cancel, .delete, .save, .move]
//
//    return HStack {
//        ForEach(icons, id: \.self) { icon in
//            Icon(this: icon)
//        }
//    }
//}
