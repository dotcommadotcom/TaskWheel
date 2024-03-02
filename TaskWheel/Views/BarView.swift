import SwiftUI



//struct BarContainerView<Content: View>: View {
//    
//    let content: Content
//    
//    @State var tabs: [IconItem] = []
//    @Binding var selected: IconItem
//    
//    init(selected: Binding<IconItem>, @ViewBuilder content: () -> Content) {
//        self._selected = selected
//        self.content = content()
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            BarView(tabs: tabs, selected: $selected)
//            
//            ZStack {
//                content
//            }
//            .padding(.vertical, 10)
//        }
////        .onPreferenceChange(TopTabPreferenceKey.self, perform: { value in
////            self.tabs = value
////        })
//    }
//}

struct BarView: View {
    
    let tabs: [IconItem]

    @Binding var selected: IconItem?
    //    @State private var sheetHeight: CGFloat = .zero
    
    private let color = ColorSettings()
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab, isSpace: tab == tabs.last)
                    .onTapGesture {
                        print(tab.text)
//                        click(tab: tab)
                    }
            }
        }
        .padding(20)
    }
}

extension BarView {
    
    private func tabView(tab: IconItem, isSpace: Bool) -> some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Button {
                selected = tab
            } label: {
                Image(systemName: tab.text)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
        }
    }
}

#Preview {
    return BarView(tabs: [.lists, .order, .more, .add], selected: .constant(.lists))
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}

