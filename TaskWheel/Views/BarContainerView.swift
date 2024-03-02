import SwiftUI

struct BarContainerView<Content: View>: View {
    let content: Content
    
    @Binding var selected: IconItem?
    
    var padding: CGFloat
    
    init(selected: Binding<IconItem?>, padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self._selected = selected
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 30) {
            content
        }
        .padding(padding)
        .frame(maxWidth: .infinity)
    }
}

struct BarIconView: View {
    let icon: IconItem
    let isSpace: Bool
    var size: CGFloat = 25
    
    var body: some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Image(systemName: icon.text)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: icon == .save ? size + 4 : size)
        }
    }
}

#Preview("container") {
    let mainTabs: [IconItem] = [.lists, .order, .more, .add]
    
    return BarContainerView(selected: .constant(.lists)) {
        ForEach(mainTabs, id: \.self) { tab in
            BarIconView(icon: tab, isSpace: tab == mainTabs.last)
        }
    }
}

#Preview("icon") {
    BarIconView(icon: .lists, isSpace: false)
}

