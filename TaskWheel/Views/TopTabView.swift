import SwiftUI

enum TopTabItem: Hashable {
    case list, wheel
    
    var title: String {
        switch self {
        case .list: return "List"
        case .wheel: return "Wheel"
        }
    }
}

struct TopTabContainerView<Content: View>: View {
    
    @Binding var selected: TopTabItem
    @State var tabs: [TopTabItem] = []

    let content: Content
    
    init(
        selected: Binding<TopTabItem>,
        @ViewBuilder content: () -> Content
    ) {
        self._selected = selected
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopTabView(selected: $selected, tabs: tabs)
            
            ZStack {
                content
            }
        }
        .onPreferenceChange(TopTabPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
    
}

struct TopTabPreferenceKey: PreferenceKey {
    static var defaultValue: [TopTabItem] = []
    
    static func reduce(value: inout [TopTabItem], nextValue: () -> [TopTabItem]) {
        value += nextValue()
    }
}

struct TopTabView: View {
    
    @Binding var selected: TopTabItem

    let tabs: [TopTabItem]
    private let color = ColorSettings()
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        click(tab: tab)
                    }
            }
        }
    }
}

extension TopTabView {
    
    private func tabView(tab: TopTabItem) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(.clear)
                
                Text(tab.title)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
            }
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1.5)
                .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 0.5)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 35)
        .foregroundStyle(selected == tab ? color.accent : color.text.opacity(0.3))
    }
    
    private func click(tab: TopTabItem) {
        withAnimation(.easeInOut) {
            selected = tab
        }
    }
}

struct TopTabViewModifier: ViewModifier {
    
    @Binding var selected: TopTabItem
    let tab: TopTabItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selected == tab ? 1.0 : 0.0)
            .preference(key: TopTabPreferenceKey.self, value: [tab])
    }
}

extension View {
    func topTabItem(tab: TopTabItem, selected: Binding<TopTabItem>) -> some View {
        self
            .modifier(TopTabViewModifier(selected: selected, tab: tab))
    }
}

#Preview("tabs") {
    @State var selected: TopTabItem = .list
    let tabs: [TopTabItem] = [.list, .wheel]
    
    return TopTabView(selected: $selected, tabs: tabs)
}
