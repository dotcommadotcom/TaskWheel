import SwiftUI

struct AddView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var textFieldText: String = ""
    @State private var height: CGFloat = 1
    @State private var isSaveClicked = false
    
    private let colorBackground: Color = .seasaltJet
    private let colorContrast: Color = .jetSeasalt
    private let colorAccent: Color = .crayolaBlue
    
    private let radiusTop: CGFloat = 25
    private let textFieldDefault: String = "What now?"
    private let sizeFont: CGFloat = 20
    private let paddingDefault: CGFloat = 20
    private let heightMinimum: CGFloat = 40
    private let heightButtonBar: CGFloat = 60 // 20 + 10 + 20 = 50 + alpha
    
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
                    .padding([.horizontal, .top], paddingDefault)
                    .padding(.bottom, paddingDefault / 2)
                    .lineLimit(nil)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: AddHeightPreference.self, value: proxy.size.height)
                        }
                    )
            }
            .onPreferenceChange(AddHeightPreference.self) { heightText in
                DispatchQueue.main.async {
                    self.height = max(heightText, heightMinimum)
                }
            }
            
            ZStack {
                Rectangle()
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
                    
                    Button(action: clickSaveButton, label: {
                        Image(systemName: "square.and.arrow.down")
                    })
                    .disabled(textFieldText.isEmpty)
                    .foregroundStyle(textFieldText.isEmpty ? .gray : colorContrast)
                }
                .foregroundStyle(colorContrast)
                .font(.system(size: sizeFont))
                .padding([.horizontal, .bottom], paddingDefault)
                .padding(.top, paddingDefault / 2)
            }
        }
        .accentColor(colorAccent)
    }
    
    private func clickSaveButton() {
        taskViewModel.addTask(title: textFieldText)
        isSaveClicked = true
        presentationMode.wrappedValue.dismiss()
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
        .environmentObject(TaskViewModel())
}

#Preview("short text", traits: .sizeThatFitsLayout) {
    @State var shortText = "Hello, World."
    return AddView(textFieldText: shortText)
        .environmentObject(TaskViewModel())

}

#Preview("medium text", traits: .sizeThatFitsLayout) {
    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    return AddView(textFieldText: mediumText)
        .environmentObject(TaskViewModel())

}

#Preview("long text", traits: .sizeThatFitsLayout) {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    return AddView(textFieldText: String(repeating: longText, count: 20))
        .environmentObject(TaskViewModel())

}
