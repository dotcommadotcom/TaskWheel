import SwiftUI

enum PriorityItem {
    case high, medium, low, no
    
    var text: String {
        switch self {
        case .high: return "High Priority"
        case .medium: return "Medium Priority"
        case .low: return "Low Priority"
        case .no: return "No Priority"
        }
    }
    
    var value: Int {
        switch self {
        case .high: return 1
        case .medium: return 2
        case .low: return 3
        case .no: return 4
        }
    }
    
    var color: Color {
        switch self {
        case .high: return .crayolaBlue
        case .medium: return .mustard
        case .low: return .asparagus
        case .no: return ColorSettings().text
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



