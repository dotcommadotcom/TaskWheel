import SwiftUI

struct TopTabContainerView<Content: View>: View {
    let content: Content
    
    @State var tabs: [TopTabItem] = []
    @Binding var selected: TopTabItem
    
    init(selected: Binding<TopTabItem>, @ViewBuilder content: () -> Content) {
        self._selected = selected
        self.content = content()
    }
    
    var body: some View {
        VStack {
            TopTabView(tabs: tabs, selected: $selected)
            
            ZStack {
                content
            }
        }
        .onPreferenceChange(TopTabPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct TopTabView: View {
    
    let tabs: [TopTabItem]
    
    @Binding var selected: TopTabItem
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                view(tab: tab)
                    .onTapGesture {
                        click(tab: tab)
                    }
            }
        }
    }
    
    private func view(tab: TopTabItem) -> some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(selected == tab ? .red.opacity(0.2) : .gray.opacity(0.2))
            
            HStack {
                Text(tab.title)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .foregroundStyle(selected == tab ? .red : .gray)
    }
    
    private func click(tab: TopTabItem) {
        withAnimation(.easeInOut) {
            selected = tab
        }
    }
}

struct TopTabViewModifier: ViewModifier {
    
    let tab: TopTabItem
    @Binding var selected: TopTabItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selected == tab ? 1.0 : 0.0)
            .preference(key: TopTabPreferenceKey.self, value: [tab])
    }
}

extension View {
    func topTabItem(tab: TopTabItem, selected: Binding<TopTabItem>) -> some View {
        self
            .modifier(TopTabViewModifier(tab: tab, selected: selected))
    }
}


struct TopTabPreferenceKey: PreferenceKey {
    static var defaultValue: [TopTabItem] = []
    
    static func reduce(value: inout [TopTabItem], nextValue: () -> [TopTabItem]) {
        value += nextValue()
    }
}


enum TopTabItem: Hashable {
    case list, wheel
    
    var title: String {
        switch self {
        case .list: return "List"
        case .wheel: return "Wheel"
        }
    }
}


#Preview("main") {
    SkeletonView()
}

#Preview("tabs") {
    let tabs: [TopTabItem] = [.list, .wheel]
    @State var selected: TopTabItem = .list
    
    return TopTabView(tabs: tabs, selected: $selected)
}
