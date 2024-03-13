import SwiftUI

enum OrderItem {
    case manual, dofirst, priority, date
    
    var text: String {
        switch self {
        case .manual: return "Manual (default)"
        case .dofirst: return "Do First"
        case .date: return "Date"
        case .priority: return "Priority"
        }
    }
}

struct OrderView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode

    let orders: [OrderItem] = [.manual, .dofirst, .priority, .date]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Sort by").greyed()
                .smallFont()
                .fontWeight(.semibold)
            
            orderRowView()
        }
    }
    
    private func orderRowView() -> some View {
        VStack(spacing: 22) {
            ForEach(orders, id: \.self) { order in
                let highlight = order == taskViewModel.currentOrder()
                
                Button {
                    selectOrder(this: order)
                } label: {
                    Icon(
                        this: .select,
                        style: Default(spacing: 15),
                        color: highlight ? Color.accent : Color.text, isAlt: highlight
                    ) {
                        Text(order.text)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(highlight ? .bold : .regular)
                }
            }
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
        OrderView()
    }
}
