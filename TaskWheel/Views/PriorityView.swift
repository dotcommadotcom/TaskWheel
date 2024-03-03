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
        case .high: return "High Priority"
        case .medium: return "Medium Priority"
        case .low: return "Low Priority"
        case .no: return "No Priority"
        }
    }
    
    var color: Color {
        switch self {
        case .high: return ColorSettings().high
        case .medium: return ColorSettings().medium
        case .low: return ColorSettings().low
        default: return ColorSettings().text
        }
    }
}

struct PriorityView: View {
    @Binding var selected: PriorityItem
    @Binding var showPriority: Bool
    let priority: [PriorityItem] = [.high, .medium, .low, .no]
    private let color = ColorSettings()
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .fill(color.background)
                .stroke(color.text)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(priority, id: \.self) { priority in
                    priorityRowView(priority: priority)
                        .onTapGesture {
                            selected = priority
                            showPriority.toggle()
                        }
                }
            }
            .padding(15)
            .font(.system(size: 22))
        }
    }
    
    private func priorityRowView(priority: PriorityItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: selected == priority ? "tag.fill" : "tag")
                .fontWeight(selected == priority ? .bold : .regular)
                .foregroundStyle(selected == priority ? priority.color : color.text)
            
            Text(priority.text)
            Spacer()
        }
    }
}

#Preview("priority") {
    ZStack {
        Color.pink
        PriorityView(selected: .constant(.no), showPriority: .constant(false))
            .background(.white)
    }
}



