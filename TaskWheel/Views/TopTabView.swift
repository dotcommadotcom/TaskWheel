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
    let content: Content
    
    @State var tabs: [TopTabItem] = []
    @Binding var selected: TopTabItem
    
    init(selected: Binding<TopTabItem>, @ViewBuilder content: () -> Content) {
        self._selected = selected
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
    
    private let color = ColorSettings()
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                view(tab: tab)
                    .onTapGesture {
                        click(tab: tab)
                    }
            }
        }
    }
    
    private func view(tab: TopTabItem) -> some View {
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
                .shadow(color: .gray.opacity(0.5), radius: 1, x: 0, y: 1)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 35)
        .foregroundStyle(selected == tab ? color.accent : .gray)
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

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview("tabs") {
    let tabs: [TopTabItem] = [.list, .wheel]
    @State var selected: TopTabItem = .list
    
    return TopTabView(tabs: tabs, selected: $selected)
}
