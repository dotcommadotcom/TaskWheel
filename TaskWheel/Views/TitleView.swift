import SwiftUI

struct TitleView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State var sizeOrder: FontItem
    @State var fontWeight: Font.Weight = .regular
    @State var isGreyed: Bool = false
    @State var hideIcon: Bool = false
    
    @State private var listsSelected: IconItem? = nil
    
    var body: some View {
        Button {
            listsSelected = .lists
        } label: {
            HStack(alignment: .center) {
                if !hideIcon {
                    Icon(this: .move)
                        .font(sizeOrder.size)
                            //sizeOrder.size * 0.8)
                }
                
                Text(taskViewModel.currentTitle())
            }
            .font(sizeOrder.size)
            .fontWeight(fontWeight)
            .foregroundStyle(Color.text.opacity(isGreyed ? 0.8 : 1.0))
        }
        .popSheet(selected: $listsSelected)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TitleView(sizeOrder: .large)
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
