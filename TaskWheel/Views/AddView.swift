import SwiftUI

struct AddView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var titleInput: String = ""
    @State var detailsInput: String = ""
    @State private var sheetHeight: CGFloat = 50
    @State private var isDetailsHidden = true
    
    private let colorBackground: Color = .seasaltJet // .pink
    private let colorContrast: Color = .jetSeasalt
    private let colorAccent: Color = .crayolaBlue
    
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details."
    private let cornerRadius: CGFloat = 25
    private let paddingDefault: CGFloat = 30
    private let heightMaximum: CGFloat = 500
    private let maxLineLimit: Int = 20
    private let sizeFont: CGFloat = 20
    
    var body: some View {
        VStack(spacing: paddingDefault / 2) {
            TextField(textDefault, text: $titleInput, axis: .vertical)
                .lineLimit(maxLineLimit)
//                .preventTextFieldError()
            
            if !isDetailsHidden {
                TextField(detailDefault, text: $detailsInput, axis: .vertical)
                    .lineLimit(5)
                    .font(.system(size: sizeFont - 3))
            }
            
            HStack(spacing: paddingDefault) {
                Button(action: {
                    isDetailsHidden.toggle()
                }, label: {
                    Image(systemName: "text.alignleft")
                })
                .foregroundStyle(detailsInput.isEmpty ? colorContrast : colorAccent)
                
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
                .disabled(titleInput.isEmpty)
                .foregroundStyle(isTaskEmpty() ? .gray : colorContrast)
            }
            .buttonStyle(NoAnimationStyle())
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
        .textFieldStyle(StaticTextFieldStyle())
        
    }
    
    private func clickDetailsButton() {
        isDetailsHidden.toggle()
    }
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty
    }

    private func clickSaveButton() {
        taskViewModel.addTask(title: titleInput, details: detailsInput)
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

struct NoAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}

struct StaticTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
    }
}

#Preview("empty", traits: .sizeThatFitsLayout) {
    AddView()
        .environmentObject(TaskViewModel())
}

#Preview("short text", traits: .sizeThatFitsLayout) {
    AddView(titleInput: "Hello, World!")
        .environmentObject(TaskViewModel())
}

#Preview("medium text", traits: .sizeThatFitsLayout) {
    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    
    return AddView(titleInput: String(repeating: mediumText, count: 3))
        .environmentObject(TaskViewModel())
}

#Preview("long text", traits: .sizeThatFitsLayout) {
    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return AddView(titleInput: String(repeating: longText, count: 5),
                   detailsInput: String(repeating: longText, count: 3))
    .environmentObject(TaskViewModel())
}
