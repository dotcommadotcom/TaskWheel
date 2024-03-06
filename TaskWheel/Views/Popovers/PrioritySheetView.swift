import SwiftUI

enum PriorityItem: Int {
    case high = 0, medium = 1, low = 2, no = 3
    
    init(_ value: Int) {
        switch value {
        case 0: self = .high
        case 1: self = .medium
        case 2: self = .low
        default: self = .no
        }
    }
    
    var text: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        case .no: return "None"
        }
    }
    
    var color: Color {
        switch self {
        case .high: return Color.high
        case .medium: return Color.medium
        case .low: return Color.low
        default: return Color.text
        }
    }
}

struct PrioritySheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selected: PriorityItem
    @Binding var showPriority: Bool
    
    let priority: [PriorityItem] = [.high, .medium, .low, .no]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(priority, id: \.self) { priority in
                priorityRowView(priority: priority)
                    .onTapGesture {
                        selected = priority
                        showPriority.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    private func priorityRowView(priority: PriorityItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: selected == priority ? "record.circle" : "circle")
                .fontWeight(selected == priority ? .bold : .regular)
                .foregroundStyle(selected == priority ? Color.accent : Color.text)
            
            Text(priority.text)
            Spacer()
        }
    }
}

#Preview("priority") {
    ZStack {
        Color.pink
        PrioritySheetView(selected: .constant(.no), showPriority: .constant(false))
            .background(Color.background)
    }
}



