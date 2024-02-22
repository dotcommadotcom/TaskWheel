import SwiftUI

struct UpdateView: View {
    private let colorBackground: Color = .seasaltJet 
    private let colorContrast: Color = .jetSeasalt
    private let colorAccent: Color = .crayolaBlue
    
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details."
    private let cornerRadius: CGFloat = 25
    private let sizePadding: CGFloat = 30
    private let heightMaximum: CGFloat = 500
    private let maxLineLimit: Int = 20
    private let sizeFont: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: sizePadding - 10) {
            Text("Navigation Bark with back button")
            Text("I am the title.")
                .font(.system(size: sizeFont * 2))
                .foregroundStyle(.primary)
            PropertiesUpdateView(imageName: "text.alignleft", text: "temp text")
            PropertiesUpdateView(imageName: "alarm", text: "date tbd")
            PropertiesUpdateView(imageName: "tag", text: "priority tbd")
            Spacer()
            Text("Complete Checkmark")
        }
        .padding(sizePadding)
        .font(.system(size: sizeFont))
        .foregroundStyle(colorContrast)
        .background(colorBackground)
        
    }
}

struct PropertiesUpdateView: View {
    
    let imageName: String
    let input: String
    
    private let sizePadding: CGFloat = 20
    
    init(imageName: String, text: String) {
        self.imageName = imageName
        self.input = text
    }
    
    var body: some View {
        HStack(spacing: sizePadding) {
            Button(action: {}, label: {
                Image(systemName: imageName)
            })
            .buttonStyle(BorderlessButtonStyle())
            
            Text(input)
                
            Spacer()
        }
    }
}

#Preview {
    UpdateView()
}
