import SwiftUI

enum OrderItem {
    case manual, priority, date, dofirst
    
    var text: String {
        switch self {
        case .manual: return "Manual (default)"
        case .date: return "Date"
        case .priority: return "Priority"
        case .dofirst: return "Do First"
        }
    }
}

struct OrderSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode

    let orders: [OrderItem] = [.manual, .dofirst, .priority, .date]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Sort by")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.text.opacity(0.5))
            
            VStack(spacing: 15) {
                ForEach(orders, id: \.self) { order in
                    orderRowView(order: order)
                        .onTapGesture {
                            selectOrder(this: order)
                        }
                }
                
            }
        }
    }
    
    private func orderRowView(order: OrderItem) -> some View {
        let highlight = order == taskViewModel.currentOrder()
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? Color.accent : Color.text)
            
            Text(order.text)
            Spacer()
        }
    }
    
    private func selectOrder(this order: OrderItem) {
        taskViewModel.updateCurrentOrder(to: order)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        OrderSheetView()
    }
}
