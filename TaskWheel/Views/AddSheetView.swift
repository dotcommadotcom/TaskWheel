import SwiftUI

enum PropertyItem: Hashable {
    case details, complete, schedule, priority, save
    
    var icon: String {
        switch self {
        case .details: return "text.alignleft"
        case .complete: return "square"
        case .schedule: return "alarm"
        case .priority: return "tag"
        case .save: return "square.and.arrow.down"
        }
    }
    
    var altIcon: String {
        switch self {
        case .complete: return "checkmark.square"
        default: return self.icon
        }
    }
    
    var emptyText: String {
        switch self {
        case .details: return "Add details"
        case .complete: return "Incomplete"
        case .schedule: return "Set schedule"
        case .priority: return "Add priority"
        default: return ""
        }
    }
    
    var fullText: String {
        switch self {
        case .complete: return "All done"
        default: return "Should be hidden"
        }
    }
    
    var color: Color {
        switch self {
        case .save: return .gray
        default: return ColorSettings().text
        }
    }
    
    var accent: Color {
        switch self {
        case .save: return ColorSettings().text
        default: return ColorSettings().accent
        }
    }
}


struct AddSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String = ""
    @State var detailsInput: String = ""
    @State private var isDetailsHidden = true
    
    let properties: [PropertyItem] = [.details, .schedule, .priority, .save]
    
    private let color = ColorSettings()
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            TextField(textDefault, text: $titleInput, axis: .vertical)
                .lineLimit(20)
            
            if !isDetailsHidden {
                TextField(detailDefault, text: $detailsInput, axis: .vertical)
                    .lineLimit(5)
                    .font(.system(size: 17))
                    .background(.blue.opacity(0.3))
            }
            
            HStack(spacing: 30) {
                ForEach(properties, id: \.self) { property in
                    view(property: property)
                }
            }
        }
    }
    
    private func view(property: PropertyItem) -> some View {
        
        let action: () -> Void
        let accentCondition: Bool
        let disableCondition: Bool
        
        switch property {
        case .details:
            action = { isDetailsHidden.toggle() }
            accentCondition = !detailsInput.isEmpty
            disableCondition = false
        case .save:
            action = clickSaveButton
            accentCondition = !isTaskEmpty()
            disableCondition = isTaskEmpty()
        default:
            action = {}
            accentCondition = false
            disableCondition = false
        }
        
        return Button {
            action()
        } label: {
            Image(systemName: property.icon)
        }
        .disabled(disableCondition)
        .foregroundStyle(accentCondition ? property.accent : property.color)
        .buttonStyle(NoAnimationStyle())
    }
    
    private func clickDetailsButton() {
        isDetailsHidden.toggle()
    }
    
    private func clickSaveButton() {
//        taskViewModel.addTask(title: titleInput, details: detailsInput)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty
    }
}

struct NoAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview("empty", traits: .sizeThatFitsLayout) {
    ZStack {
        Color.pink.opacity(0.3).ignoresSafeArea()
        AddSheetView()
    }
//    .environmentObject(TaskViewModel())
}

#Preview("short text", traits: .sizeThatFitsLayout) {
    ZStack {
        Color.pink.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: "Hello, World!")
    }
//    .environmentObject(TaskViewModel())
}

#Preview("medium text", traits: .sizeThatFitsLayout) {
    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    
    return ZStack {
        Color.pink.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: String(repeating: mediumText, count: 3))
    }
//        .environmentObject(TaskViewModel())
}

#Preview("long text", traits: .sizeThatFitsLayout) {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return ZStack {
        Color.pink.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: String(repeating: longText, count: 5),
                     detailsInput: String(repeating: longText, count: 3))
    }
//    .environmentObject(TaskViewModel())
}


