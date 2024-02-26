import SwiftUI

struct BottomTabType: Identifiable, Equatable {
    var id: String
    var icon: String
}

struct BottomTabView: View {
    @State private var selected: BottomTabType?
    
    let bottomTabs: [BottomTabType] = [
        BottomTabType(id: "lists", icon: "list.dash"),
        BottomTabType(id: "reorder", icon: "arrow.up.arrow.down"),
        BottomTabType(id: "more", icon: "ellipsis"),
        BottomTabType(id: "add", icon: "plus"),
    ]
    
    var body: some View {
        HStack {
            ForEach(bottomTabs) { tab in
                view(tab: tab, isSpace: tab == bottomTabs.last)
            }
        }
        .foregroundStyle(.white)
        .sheet(item: $selected) { tab in
            SheetView(selectedTab: tab)
        }
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
                    .frame(width: 35, height: 35)
            }
            .background(.black.opacity(0.4))
        }
    }
    
    private func dismissSheet() {
        selected = nil
    }
}

struct SheetView: View {
    let selectedTab: BottomTabType
    
    var body: some View {
        VStack {
            switch selectedTab.id {
            case "lists":
                Text(selectedTab.id)
                    .font(.title)
            case "reorder":
                Text(selectedTab.id)
                    .font(.title)
            case "more":
                Text(selectedTab.id)
                    .font(.title)
            case "add":
                Text(selectedTab.id)
                    .font(.title)
            default:
                EmptyView()
            }
        }
        .presentationDetents([.fraction(0.3)])
    }
}


#Preview("main") {
    MainView()
}

#Preview {
    BottomTabView()
}
