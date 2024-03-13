import SwiftUI

enum IconItem: Identifiable, Hashable {
    
    case add, back, cancel, complete, details, delete, filter
    case left, lists, order, more, move, plus, priority
    case right, save, schedule, select, settings, shuffle, ticker
    
    var id: Self {
        self
    }
    
    var name: String {
        switch self {
        case .add: return "plus.square"
        case .back: return "arrow.backward"
        case .cancel: return "xmark"
        case .complete: return "square"
        case .details: return "text.alignleft"
        case .delete: return "trash"
        case .filter: return "slider.horizontal.3"
        case .left: return "slider.horizontal.3"
        case .lists: return "list.dash"
        case .order: return "arrow.up.arrow.down"
        case .more: return "ellipsis"
        case .move: return "chevron.up.chevron.down"
        case .plus: return "plus"
        case .priority: return "tag"
        case .right: return "chevron.right"
        case .save: return "square.and.arrow.down"
        case .select: return "circle"
        case .schedule: return "alarm"
        case .settings: return "gearshape.fill"
        case .shuffle: return "checkmark.gobackward"
        case .ticker: return "arrowtriangle.backward.fill"
        }
    }
    
    var alternative: String {
        switch self {
        case .select: return "record.circle"
        case .complete: return "checkmark.square"
        case .priority: return "tag.fill"
        default: return self.name
        }
    }
    
    var adjust: Double {
        switch self {
        case .cancel: return 0.8
        case .save: return 1.2
        case .move: return 0.6
        case .plus: return 0.8
        default: return 1.0
        }
    }
}

struct Icon<Content: View>: View {
    let this: IconItem
    let content: Content
    var isSpace: Bool = false
    var isAlt: Bool = false
    var isFill: Bool = false
    let size: SizeItem
    let color: Color
    let style: any LabelStyle
    
    init(
        this: IconItem,
        size: SizeItem = .medium,
        style: any LabelStyle = Default(spacing: 10),
        color: Color = Color.text,
        isAlt: Bool = false,
        isFill: Bool = false,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.this = this
        self.size = size
        self.color = color
        self.isAlt = isAlt
        self.isFill = isFill
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        AnyView(
            Label {
                content
                    .font(size.font)
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
                .foregroundStyle(color)
                .frame(width: size.scale * this.adjust, height: size.scale * this.adjust)
            }
            .labelStyle(style)
        )
    }
}

struct Default: LabelStyle {
    
    let spacing: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: spacing) {
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

#Preview("default") {
    Icon(this: .move, style: Default(spacing: 10)) {
        Text("hello world")
    }
}
