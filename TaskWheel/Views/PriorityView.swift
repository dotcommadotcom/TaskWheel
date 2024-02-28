import SwiftUI

enum PriorityItem: Int {
    case high = 1, medium = 2, low = 3, no = 4
    
    init(_ value: Int) {
        switch value {
        case 1: self = .high
        case 2: self = .medium
        case 3: self = .low
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
    let priority: [PriorityItem] = [.high, .medium, .low, .no]
    private let color = ColorSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(priority, id: \.self) { priority in
                view(priority: priority)
                    .onTapGesture {
                        click(priority: priority)
                    }
            }
        }
        .padding(30)
        .font(.system(size: 22))
    }
    
    private func view(priority: PriorityItem) -> some View {
        HStack(spacing: 15) {
            Image(systemName: selected == priority ? "tag.fill" : "tag")
                .fontWeight(selected == priority ? .bold : .regular)
                .foregroundStyle(selected == priority ? priority.color : color.text)
            
            Text(priority.text)
            Spacer()
        }
    }
    
    private func click(priority: PriorityItem) {
        selected = priority
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}



