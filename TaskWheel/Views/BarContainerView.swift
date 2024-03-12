//import SwiftUI
//
//struct BarContainerView<Content: View>: View {
//    let content: Content
//    
//    @Binding var selected: IconItem?
//    
//    var padding: CGFloat
//    
//    init(
//        selected: Binding<IconItem?>,
//        padding: CGFloat = 20,
//        @ViewBuilder content: () -> Content
//    ) {
//        self._selected = selected
//        self.padding = padding
//        self.content = content()
//    }
//    
//    var body: some View {
//        HStack(spacing: 30) {
//            content
//        }
//        .padding(padding)
//        .frame(maxWidth: .infinity)
//    }
//}
//
//#Preview("bar") {
//    let mainTabs: [IconItem] = [.lists, .order, .more, .add]
//    
//    return BarContainerView(selected: .constant(.lists)) {
//        ForEach(mainTabs, id: \.self) { tab in
//            Icon(this: tab, isSpace: tab == mainTabs.last)
//        }
//    }
//}
//
