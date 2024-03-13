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

struct MoreView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var titleInput: String = ""
    @State private var showRenameList = false
    
    let moreOptions: [OptionItem] = [.defaultList, .deleteList, .showHide, .deleteCompleted]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(moreOptions) { option in
                moreOptionsView(option: option)
            }
            
            HStack(spacing: 30) {
                moreOptionsView(option: .rename)
                
                if showRenameList {
                    Spacer()
                    
                    Button {
                        clickSave()
                    } label: {
                        Icon(this: .save, style: IconOnly())
                    }
                }
            }
            .noAnimation()
            
            if showRenameList {
                TextField(titleInput, text: $titleInput, axis: .vertical)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
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

extension MoreView {
    
    private func moreOptionsView(option: OptionItem) -> some View {
        
        var isDisabled: Bool {
            switch option {
            case .defaultList, .deleteList:
                return taskViewModel.currentId() == taskViewModel.defaultTaskList.id
            case .showHide, .deleteCompleted:
                return taskViewModel.currentDoneTasks().count == 0
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
        .noAnimation()
    }
    
}

extension MoreView {
    
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
        taskViewModel.deleteIf {
            $0.isDone &&
            $0.ofTaskList == taskViewModel.currentId()
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickRenameList() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showRenameList.toggle()
        }
    }
    
    private func clickSave() {
        taskViewModel.updateCurrentTitle(to: titleInput)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("more sheet") {
    MoreView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
