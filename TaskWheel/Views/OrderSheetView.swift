import SwiftUI

enum OrderItem {
    case manual, date, priority
    
    var text: String {
        switch self {
        case .manual: return "Manual (default)"
        case .date: return "Date"
        case .priority: return "Priority"
        }
    }
}

struct OrderSheetView: View {
    
    @State private var selected: OrderItem = .manual
    
    let orders: [OrderItem] = [.manual, .date, .priority]
    private let color = ColorSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Sort by")
                .font(.system(size: 20, weight: .semibold))
            
            VStack(spacing: 15) {
                ForEach(orders, id: \.self) { order in
                    view(order: order)
                        .onTapGesture {
                            click(order: order)
                        }
                }
                
            }
        }
        .padding(20)
    }
    
    private func view(order: OrderItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: selected == order ? "record.circle" : "circle")
                .fontWeight(selected == order ? .bold : .regular)
                .foregroundStyle(selected == order ? color.accent : color.text)
            
            Text(order.text)
            Spacer()
        }
        .font(.system(size: 22))
        .padding(.horizontal, 10)
        
    }
    
    private func click(order: OrderItem) {
        selected = order
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        OrderSheetView()
    }
}
