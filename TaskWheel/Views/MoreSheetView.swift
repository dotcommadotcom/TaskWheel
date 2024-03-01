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
        case .showHide: clickShowHideCompleted()
        case .deleteCompleted: clickDeleteCompleted()
        default: do {}
        }
    }
    
    private func clickShowHideCompleted() {
        taskViewModel.toggleCurrentDoneVisible()
        selected = nil
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
    MoreSheetView(selected: .constant(.more))
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}

#Preview("bottom tab") {
    BottomTabView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}


