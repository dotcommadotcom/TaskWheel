import SwiftUI

struct AddView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var textInput: String = ""
    @State private var sheetHeight: CGFloat = 50
    @State private var isSaveClicked = false
    
    private let colorBackground: Color = .seasaltJet // .pink
    private let colorContrast: Color = .jetSeasalt
    
    private let textDefault: String = "What now?"
    private let cornerRadius: CGFloat = 25
    private let paddingDefault: CGFloat = 20
    private let heightMaximum: CGFloat = 500
    private let maxLineLimit: Int = 20
    private let sizeFont: CGFloat = 20
    
    var body: some View {
        VStack(spacing: paddingDefault) {
            TextField(textDefault, text: $textInput, axis: .vertical)
                .lineLimit(maxLineLimit)
                .preventTextFieldError()
            
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
                .disabled(textInput.isEmpty)
                .foregroundStyle(textInput.isEmpty ? .gray : colorContrast)
            }
        }
        .padding(paddingDefault)
        .font(.system(size: sizeFont))
        .foregroundStyle(colorContrast)
        .presentationBackground(colorBackground)
        .presentationCornerRadius(cornerRadius)
        .presentationDragIndicator(.hidden)
        .fixedSize(horizontal: false, vertical: true)
        .presentationDetents([.height(sheetHeight)])
        .modifier(GetHeightModifier(height: $sheetHeight))
    }
    
    private func clickSaveButton() {
        taskViewModel.addTask(title: textInput)
        isSaveClicked = true
        presentationMode.wrappedValue.dismiss()
    }
}

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat
    private let heightMaximum: CGFloat = 500

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = max(geo.size.height, 50)
                }
                return Color.clear
            }
        )
    }
}

#Preview("empty") {
    AddView()
        .environmentObject(TaskViewModel())
}

#Preview("single line") {
    AddView(textInput: "Hello, World!")
        .environmentObject(TaskViewModel())
}

#Preview("multiple lines") {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return AddView(textInput: String(repeating: longText, count: 5))
        .environmentObject(TaskViewModel())
}
