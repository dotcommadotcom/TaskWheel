import SwiftUI

struct AddSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String = ""
    @State var detailsInput: String = ""
    @State var priorityInput: PriorityItem = .no
    @State private var showDetails = false
    @State private var showPriority = false
    
    private let color = ColorSettings()
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            TextField(textDefault, text: $titleInput, axis: .vertical)
                .lineLimit(20)
            //                .preventTextFieldError()
            
            if showDetails {
                TextField(detailDefault, text: $detailsInput, axis: .vertical)
                    .lineLimit(5)
                    .font(.system(size: 17))
            }
            
            HStack(spacing: 30) {
                Button {
                    showDetails.toggle()
                } label: {
                    viewImage(IconItem.details)
                }
                .foregroundStyle(!detailsInput.isEmpty ? color.accent : color.text)
                
                Button {
                } label: {
                    viewImage(IconItem.schedule)
                }
                
                Button {
                    showPriority.toggle()
                } label: {
                    viewImage(IconItem.priority, isAlternative: priorityInput.rawValue != 4)
                }
                .foregroundStyle(priorityInput.color)
                .padding(.vertical, 8)
                .popover(isPresented: $showPriority, attachmentAnchor: .point(.top), arrowEdge: .top) {
                    PriorityView(selected: $priorityInput)
                        .presentationCompactAdaptation(.popover)
                        .presentationBackground(color.background)
                }
                
                Spacer()
                
                Button {
                    clickSaveButton()
                } label: {
                    viewImage(IconItem.save)
                }
                .disabled(isTaskEmpty() ? true : false)
                .foregroundStyle(isTaskEmpty() ? .gray : color.text)
            }
            .buttonStyle(NoAnimationStyle())
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func viewImage(_ icon: IconItem, isAlternative: Bool = true) -> some View {
        Image(systemName: isAlternative ? icon.alternative : icon.text)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 22, height: icon == .save ? 26 : 22)
    }
    
    private func viewPopover(property: IconItem) -> some View {
        Text(property.text)
            .presentationCompactAdaptation(.popover)
    }
    
    private func clickSaveButton() {
        taskViewModel.addTask(title: titleInput, details: detailsInput, priority: priorityInput.rawValue)
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
        Color.gray.opacity(0.3).ignoresSafeArea()
        AddSheetView()
    }
    .environmentObject(TaskViewModel())
}

#Preview("short text", traits: .sizeThatFitsLayout) {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: "Hello, World!", detailsInput: "Hiya")
    }
    .environmentObject(TaskViewModel())
}

#Preview("long text", traits: .sizeThatFitsLayout) {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        AddSheetView(titleInput: String(repeating: longText, count: 5),
                     detailsInput: String(repeating: longText, count: 3))
    }
    .environmentObject(TaskViewModel())
}


