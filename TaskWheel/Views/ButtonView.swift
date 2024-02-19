import SwiftUI

struct ButtonImageView: View {
    let image: String
    let color: Color
    let action: () -> Void
    
    init(image: String, color: Color = Color.primary, action: @escaping () -> Void) {
        self.image = image
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: image)
                .padding()
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color.seasalt)
                .background(color)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.09), radius: 5, x: 5, y: 5)
                .clipShape(Circle())
        })
    }
}

#Preview("image button", traits: .sizeThatFitsLayout) {
    ButtonImageView(image: "star", color: Color.crayolaBlue) {
        print("Button pressed!")
    }
}
