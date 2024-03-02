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
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selected: OrderItem
    
    let orders: [OrderItem] = [.manual, .date, .priority]
    private let color = ColorSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Sort by")
                .font(.system(size: 20, weight: .semibold))
            
            VStack(spacing: 15) {
                ForEach(orders, id: \.self) { order in
                    orderRowView(order: order)
                        .onTapGesture {
                            selected = order
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                
            }
        }
    }
    
    private func orderRowView(order: OrderItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: selected == order ? "record.circle" : "circle")
                .fontWeight(selected == order ? .bold : .regular)
                .foregroundStyle(selected == order ? color.accent : color.text)
            
            Text(order.text)
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        OrderSheetView(selected: .constant(.manual))
    }
}
