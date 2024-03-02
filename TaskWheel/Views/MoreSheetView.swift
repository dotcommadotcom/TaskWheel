import SwiftUI

enum OptionItem: Identifiable {
    case rename, deleteList, showHide, deleteCompleted
    
    var id: Self {
        self
    }
    
    var text: String {
        switch self {
        case .rename: return "Rename list"
        case .deleteList: return "Delete list"
        case .showHide: return "Show/Hide completed tasks"
        case .deleteCompleted: return "Delete all completed tasks"
        }
    }
    
}

struct MoreSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let moreOptions: [OptionItem] = [.rename, .deleteList, .showHide, .deleteCompleted]
    private let color = ColorSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(moreOptions) { option in
                moreOptionsView(option: option)
            }
        }
    }
}

extension MoreSheetView {
    
    private func moreOptionsView(option: OptionItem) -> some View {
        
        var isDisabled: Bool {
            switch option {
            case .deleteList:
                return taskViewModel.currentTaskList.id == taskViewModel.defaultTaskList.id
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
    }
    
}

extension MoreSheetView {
    
    private func click(option: OptionItem) {
        switch option {
        case .deleteList: clickDeleteList()
        case .showHide: clickShowHideCompleted()
        case .deleteCompleted: clickDeleteCompleted()
        default: do {}
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickDeleteList() {
        taskViewModel.deleteTaskList( taskViewModel.currentTaskList)
    }
    
    private func clickShowHideCompleted() {
        taskViewModel.toggleCurrentDoneVisible()
    }
    
    private func clickDeleteCompleted() {
        taskViewModel.deleteMultipleTasks {
            $0.isComplete &&
            $0.ofTaskList == taskViewModel.currentTaskList.id
        }
    }
}

#Preview("more sheet") {
    MoreSheetView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
//
//#Preview("bottom tab") {
//    BarView(tabs: [.lists, .order, .more, .add])
//        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
//}
//

