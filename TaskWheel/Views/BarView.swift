import SwiftUI

struct BarView: View {

    @Binding var selected: IconItem?
    
    let tabs: [IconItem]
    
    var size: CGFloat = 25
    private let color = ColorSettings()
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab, isSpace: tab == tabs.last, size: size)
            }
        }
        .padding(20)
    }
}

extension BarView {
    
    private func tabView(tab: IconItem, isSpace: Bool, size: CGFloat) -> some View {
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
                    .frame(width: size, height: tab == .save ? size + 4 : size)
            }
        }
    }
}

#Preview {
    return BarView(selected: .constant(nil), tabs: [.lists, .order, .more, .add])
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}

