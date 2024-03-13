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
    
    private let priority: [PriorityItem] = [.high, .medium, .low, .no]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(priority, id: \.self) { priority in
                priorityRowView(this: priority)
            }
        }
    }
}

extension PriorityView {
    
    private func priorityRowView(this priority: PriorityItem) -> some View {
        
        let highlight = priority == priorityInput
        
        return Button {
            selectPriority(this: priority)
        } label: {
            Icon(
                this: .select,
                style: Default(spacing: 15),
                color: highlight ? Color.accent : Color.text,
                isAlt: highlight
            ) {
                Text(priority.text)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(highlight ? .bold : .regular)
        }
    }
    
    private func selectPriority(this priority: PriorityItem) {
        priorityInput = priority
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("priority") {
    ZStack {
        Color.pink
        PriorityView(priorityInput: .constant(.no))
            .background(Color.background)
    }
}
