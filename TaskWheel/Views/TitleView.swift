import SwiftUI

struct TitleView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State private var listsSelected: IconItem? = nil
    
    let size: SizeItem
    let fontWeight: Font.Weight
    let isGreyed: Bool
    let hideIcon: Bool
    
    init(
        size: SizeItem,
        fontWeight: Font.Weight = .regular,
        isGreyed: Bool = false,
        hideIcon: Bool = false
    ) {
        self.size = size
        self.fontWeight = fontWeight
        self.isGreyed = isGreyed
        self.hideIcon = hideIcon
    }
    
    var body: some View {
        Button {
            listsSelected = .lists
        } label: {
            Icon(
                this: .move,
                size: size,
                style: hideIcon ? TextOnly() : Default(spacing: 10)
            ) {
                Text(taskViewModel.currentTitle())
            }
            .fontWeight(fontWeight)
            .foregroundStyle(Color.text.opacity(isGreyed ? 0.8 : 1.0))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .popSheet(selected: $listsSelected)
    }
}

#Preview {
    TitleView(size: .large, fontWeight: .bold)
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
