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
    
    var background: Color {
        switch self {
        case .high: return Color.highBackground
        case .medium: return Color.mediumBackground
        case .low: return Color.lowBackground
        default: return Color.text
        }
    }
}

struct PriorityView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var priorityInput: PriorityItem
    
    let priority: [PriorityItem] = [.high, .medium, .low, .no]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(priority, id: \.self) { priority in
                
                priorityRowView(priority: priority)
                    .onTapGesture {
                        priorityInput = priority
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    private func priorityRowView(priority: PriorityItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: priorityInput == priority ? "record.circle" : "circle")
                .fontWeight(priorityInput == priority ? .bold : .regular)
                .foregroundStyle(priorityInput == priority ? Color.accent : Color.text)
            
            Text(priority.text)
            Spacer()
        }
    }
}

#Preview("priority") {
    ZStack {
        Color.pink
        PriorityView(priorityInput: .constant(.no))
            .background(Color.background)
    }
}
