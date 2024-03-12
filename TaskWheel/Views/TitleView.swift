import SwiftUI

struct TitleView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State var fontSize: CGFloat = 15
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
                    Icon(this: .move, size: fontSize * 0.8)
                }
                
                Text(taskViewModel.currentTitle())
            }
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundStyle(Color.text.opacity(isGreyed ? 0.8 : 1.0))
        }
        .popSheet(selected: $listsSelected)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TitleView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
