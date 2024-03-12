import SwiftUI

enum TabItem: Hashable {
    case list, wheel
    
    var title: String {
        switch self {
        case .list: return "List"
        case .wheel: return "Wheel"
        }
    }
}

struct TabContainerView<Content: View>: View {
    
    @State var tabs: [TabItem] = []

    @Binding var tabSelected: TabItem

    let content: Content
    
    init(
        tabSelected: Binding<TabItem>,
        @ViewBuilder content: () -> Content
    ) {
        self._tabSelected = tabSelected
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(tabSelected: $tabSelected, tabs: tabs)
            
            ZStack {
                content
            }
        }
        .onPreferenceChange(TabPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
    
}

struct TabView: View {
    
    @Binding var tabSelected: TabItem

    let tabs: [TabItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 35)
    }
}

extension TabView {
    
    private func tabView(tab: TabItem) -> some View {
        Button {
            tabSelected = tab
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(.clear)
                    
                    
                    Text(tab.title)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
                
                Rectangle()
                    .frame(height: 1.5)
                    .frame(maxWidth: .infinity)
                    .shadow(color: Color.text.opacity(0.2), radius: 1, x: 0, y: 0.5)
            }
            .foregroundStyle(tabSelected == tab ? Color.accent : Color.text.opacity(0.3))
        }
        .buttonStyle(NoAnimationStyle())
    }
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: [TabItem] = []
    
    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
        value += nextValue()
    }
}

struct TabViewModifier: ViewModifier {
    
    let tab: TabItem
    @Binding var selected: TabItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selected == tab ? 1.0 : 0.0)
            .preference(key: TabPreferenceKey.self, value: [tab])
    }
}

extension View {
    func showTab(this tab: TabItem, selected: Binding<TabItem>) -> some View {
        self
            .modifier(TabViewModifier(tab: tab, selected: selected))
    }
}

#Preview("tabs") {
    @State var selected: TabItem = .list
    let tabs: [TabItem] = [.list, .wheel]
    
    return TabView(tabSelected: $selected, tabs: tabs)
}
