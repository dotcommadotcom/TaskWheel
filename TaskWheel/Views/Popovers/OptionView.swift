import SwiftUI

enum OptionItem: Identifiable {
    case defaultList, deleteList, showHide, deleteCompleted, rename
    
    var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .defaultList: return "Set as default"
        case .deleteList: return "Delete list"
        case .showHide: return "Show/Hide completed tasks"
        case .deleteCompleted: return "Delete all completed tasks"
        case .rename: return "Rename list"
        }
    }
    
}

struct OptionView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titleInput: String = ""
    @State private var showRenameList = false
    
    private let options: [OptionItem] = [.defaultList, .deleteList, .showHide, .deleteCompleted]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(options) { option in
                optionRowView(option: option)
            }
            
            renameListView()
        }
    }
}

extension OptionView {
    
    private func optionRowView(option: OptionItem) -> some View {
        
        var isDisabled: Bool {
            switch option {
            case .defaultList, .deleteList:
                return taskViewModel.currentId() == taskViewModel.defaultTaskList.id
            case .showHide, .deleteCompleted:
                return taskViewModel.countDone() == 0
            default: return false
            }
        }
        
        return Button {
            click(option: option)
        } label: {
            Text(option.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .disableClick(if: isDisabled)
    }
    
    private func renameListView() -> some View {
        VStack {
            HStack(spacing: 30) {
                optionRowView(option: .rename)
                
                if showRenameList {
                    Spacer()
                    
                    Button {
                        clickSave()
                    } label: {
                        Icon(this: .save, style: IconOnly())
                    }
                    .disableClick(if: titleInput.isEmpty)
                }
            }
            
            if showRenameList {
                TextField(titleInput, text: $titleInput, axis: .vertical)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accent, lineWidth: 2))
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .onAppear {
                        titleInput = taskViewModel.currentTitle()
                    }
                    .onSubmit {
                        clickSave()
                    }
                    
            }
        }
    }
}

extension OptionView {
    
    private func click(option: OptionItem) {
        switch option {
        case .defaultList: clickDefaultList()
        case .deleteList: clickDeleteList()
        case .showHide: clickShowHideCompleted()
        case .deleteCompleted: clickDeleteCompleted()
        case .rename: clickRenameList()
        }
    }
    
    private func clickDefaultList() {
        taskViewModel.updateDefault(with: taskViewModel.current)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickDeleteList() {
        taskViewModel.deleteList(at: taskViewModel.current)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickShowHideCompleted() {
        taskViewModel.toggleCurrentDoneVisible()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickDeleteCompleted() {
        taskViewModel.deleteDone()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickRenameList() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showRenameList.toggle()
        }
    }
    
    private func clickSave() {
        if !titleInput.isEmpty {
            taskViewModel.updateCurrentTitle(to: titleInput)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("more sheet") {
    OptionView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
