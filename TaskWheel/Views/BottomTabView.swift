import SwiftUI

struct BottomTabType: Identifiable, Hashable {
    var id: String
    var icon: String
}

struct BottomTabView: View {
    @State private var selected: BottomTabType?
    
    let bottomTabs: [BottomTabType] = [
        BottomTabType(id: "lists", icon: "list.dash"),
        BottomTabType(id: "reorder", icon: "arrow.up.arrow.down"),
        BottomTabType(id: "more", icon: "ellipsis"),
        BottomTabType(id: "add", icon: "plus.square"),
    ]
    
    var body: some View {
        HStack(spacing: 25) {
            ForEach(bottomTabs, id: \.self) { tab in
                view(tab: tab, isSpace: tab == bottomTabs.last)
            }
        }
        .sheet(item: $selected) { tab in
            SheetView(selectedTab: tab)
        }
        .padding(20)
        

    }
    
    private func view(tab: BottomTabType, isSpace: Bool) -> some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Button {
                selected = tab
            } label: {
                Image(systemName: tab.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
        }
    }
    
    private func dismissSheet() {
        selected = nil
    }
}

#Preview("main") {
    MainView()
}

#Preview {
    BottomTabView()
}
