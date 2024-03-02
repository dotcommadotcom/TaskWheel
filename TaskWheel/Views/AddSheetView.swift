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
            
            addBarView()
                .buttonStyle(NoAnimationStyle())
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
}

extension AddSheetView {
    
    private func addBarView() -> some View {
        let size: CGFloat = 22
        
        return HStack(spacing: 30) {
            Button {
                showDetails.toggle()
            } label: {
                IconView(icon: .details, size: size)
            }
            .foregroundStyle(!detailsInput.isEmpty ? color.accent : color.text)
            
            Button {
            } label: {
                IconView(icon: .schedule, size: size)
            }
            
            Button {
                showPriority.toggle()
            } label: {
                IconView(icon: .priority, isAlt: priorityInput.rawValue != 4, size: size)
            }
            .foregroundStyle(priorityInput.color)
            .padding(.vertical, 8)
            .popover(isPresented: $showPriority, attachmentAnchor: .point(.top), arrowEdge: .top) {
                PriorityView(selected: $priorityInput)
                    .presentationCompactAdaptation(.popover)
                    .presentationBackground(color.background)
            }
            
            Button {
                clickSave()
            } label: {
                IconView(icon: .save, isSpace: true, size: size)
            }
            .disabled(isTaskEmpty() ? true : false)
            .foregroundStyle(isTaskEmpty() ? .gray : color.text)
        }
    }
}

extension AddSheetView {
    
    private func clickSave() {
        taskViewModel.addTask(title: titleInput, details: detailsInput, priority: priorityInput.rawValue)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty && priorityInput.rawValue == 4
    }
}

struct NoAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
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


