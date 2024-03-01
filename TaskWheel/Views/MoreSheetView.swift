import SwiftUI

enum OptionItem: Identifiable {
    case rename, delete, showHide, deleteCompleted
    
    var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .rename: return "Rename list"
        case .delete: return "Delete list"
        case .showHide: return "Show/Hide completed tasks"
        case .deleteCompleted: return "Delete all completed tasks"
        }
    }
    
}

struct MoreSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Binding var selected: IconItem?
    
    let moreOptions: [OptionItem] = [.rename, .delete, .showHide, .deleteCompleted]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(moreOptions) { option in
                HStack {
                    moreOptionsView(option: option)
                }
            }
        }
    }
}

extension MoreSheetView {
    
    private func moreOptionsView(option: OptionItem) -> some View {
        Button {
            click(option: option)
        } label: {
            Text(option.text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func click(option: OptionItem) {
        switch option {
        case .deleteCompleted: clickDeleteCompleted()
        default: do {}
        }
    }
    
    private func clickDeleteCompleted() {
        taskViewModel.deleteMultipleTasks {
            $0.isComplete &&
            $0.ofTaskList == taskViewModel.currentTaskList.id
        }
        selected = nil
    }
}

#Preview("more sheet") {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return MoreSheetView(selected: .constant(.more))
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}

#Preview("bottom tab") {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return BottomTabView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}


