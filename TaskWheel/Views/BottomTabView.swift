import SwiftUI

enum BottomTabItem: Hashable {
    case lists, reorder, more, add
    
    var icon: String {
        switch self {
        case .lists: return "list.dash"
        case .reorder: return "arrow.up.arrow.down"
        case .more: return "ellipsis"
        case .add: return "plus"
        }
    }
}

struct BottomTabView: View {
    
    let leftTabs: [BottomTabItem] = [.lists, .reorder, .more]
    let rightTabs: [BottomTabItem] = [.add]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            
            HStack {
                ForEach(leftTabs, id: \.self) { tab in
                    view(tab: tab)
                        .onTapGesture {
                            click(tab: tab)
                        }
                }
                Spacer()
                
                ForEach(rightTabs, id: \.self) { tab in
                    view(tab: tab)
                        .onTapGesture {
                            click(tab: tab)
                        }
                }
            }
        }
        .foregroundStyle(.white)
        .frame(height: 70)
    }
    
    private func view(tab: BottomTabItem) -> some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black.opacity(0.5))
            
            Image(systemName: tab.icon)
        }
        .frame(width: 50)
    }
    
    private func click(tab: BottomTabItem) {
        print("im \(tab.icon)")
    }
}

#Preview("main") {
    MainView()
}

#Preview {
    BottomTabView()
}
