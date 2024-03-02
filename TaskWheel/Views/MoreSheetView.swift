import SwiftUI

enum OptionItem: Identifiable {
    case rename, defaultList, deleteList, showHide, deleteCompleted
    
    var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .rename: return "Rename list"
        case .defaultList: return "Set as default"
        case .deleteList: return "Delete list"
        case .showHide: return "Show/Hide completed tasks"
        case .deleteCompleted: return "Delete all completed tasks"
        }
    }
    
}

struct MoreSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var titleInput: String = ""
    @State private var showRenameList = false
    
    let moreOptions: [OptionItem] = [.defaultList, .deleteList, .showHide, .deleteCompleted]
    private let color = ColorSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(moreOptions) { option in
                moreOptionsView(option: option)
            }
            
            HStack(spacing: 30) {
                moreOptionsView(option: .rename)
                
                if showRenameList {
                    Button {
                        clickSave()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
            .buttonStyle(NoAnimationStyle())
            
            if showRenameList {
                TextField(titleInput, text: $titleInput)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.accent, lineWidth: 2)
                    )
                    .lineLimit(1)
            }
        }
    }
}

extension MoreSheetView {
    
    private func moreOptionsView(option: OptionItem) -> some View {
        
        var isDisabled: Bool {
            switch option {
            case .defaultList, .deleteList:
                return taskViewModel.getCurrentId() == taskViewModel.defaultTaskList.id
            case .showHide, .deleteCompleted:
                return taskViewModel.getCurrentCompletedTasks().count == 0
            default: return false
            }
        }
        
        return Button {
            click(option: option)
        } label: {
            Text(option.text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .disabled(isDisabled)
        .foregroundStyle(isDisabled ? .gray : color.text)
        .buttonStyle(NoAnimationStyle())
    }
    
}

extension MoreSheetView {
    
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
        taskViewModel.updateDefaultTaskList(taskViewModel.current)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickDeleteList() {
        taskViewModel.deleteTaskList(taskViewModel.current)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickShowHideCompleted() {
        taskViewModel.toggleCurrentDoneVisible()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickDeleteCompleted() {
        taskViewModel.deleteMultipleTasks {
            $0.isDone &&
            $0.ofTaskList == taskViewModel.getCurrentId()
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickRenameList() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showRenameList.toggle()
        }
    }
    
    private func clickSave() {
        taskViewModel.updateListTitle(title: titleInput)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("more sheet") {
    MoreSheetView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}

