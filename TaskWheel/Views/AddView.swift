import SwiftUI

struct AddView: View {
    @State var height: CGFloat = 0
    @State var textFieldText: String = ""
    
    let colorBackground: Color = Color.seasaltJet
    let colorContrast: Color = Color.jetSeasalt
    let colorAccent: Color = Color.crayolaBlue
    
    let radiusTop: CGFloat = 25
    let textFieldDefault: String = "What now?"
    let sizeFont: CGFloat = 20
    let paddingDefault: CGFloat = 20
    let heightMinimum: CGFloat = 40
    let heightButtonBar: CGFloat = 60 // 20 + 10 + 20 = 50 + alpha
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                UnevenRoundedRectangle()
                    .fill(colorBackground)
                    .shadow(color: .black.opacity(0.09), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, y: -5)
                    .frame(height: height)
                    .clipShape(.rect(topLeadingRadius: radiusTop, topTrailingRadius: radiusTop))

                TextField(text: $textFieldText, prompt: Text(textFieldDefault).foregroundStyle(colorContrast.opacity(0.6)), axis: .vertical) {}
                    .font(.system(size: sizeFont))
                    .padding(.horizontal, paddingDefault).padding(.top, paddingDefault).padding(.bottom, paddingDefault / 2)
                    .lineLimit(nil)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: AddHeightPreference.self, value: proxy.size.height)
                        }
                    )
            }
            .onPreferenceChange(AddHeightPreference.self, perform: { value in
                DispatchQueue.main.async {
                    self.height = value < heightMinimum ? heightMinimum : value
                }
            })
            
            ZStack {
                Rectangle()
                    .fill(.placeholder)
                    .fill(colorBackground)
                    .frame(height: heightButtonBar)
                
                HStack(spacing: 20) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "text.alignleft")
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "alarm")
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "tag")
                    })
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "square.and.arrow.down")
                    })
                }
                .foregroundStyle(colorContrast)
                .font(.system(size: sizeFont))
                .padding(.horizontal, paddingDefault).padding(.top, paddingDefault / 2).padding(.bottom, paddingDefault)
            }
        }
        .accentColor(colorAccent)
    }
}

struct AddHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview("empty", traits: .sizeThatFitsLayout) {
    return AddView()
}

#Preview("short text", traits: .sizeThatFitsLayout) {
    @State var shortText = "Hello, World."
    return AddView(textFieldText: shortText)
}

#Preview("medium text", traits: .sizeThatFitsLayout) {
    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    return AddView(textFieldText: mediumText)
}

#Preview("long text", traits: .sizeThatFitsLayout) {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    return AddView(textFieldText: String(repeating: longText, count: 20))
}
