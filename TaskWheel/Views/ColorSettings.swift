import SwiftUI
import Observation

@Observable class ColorSettings {
    let background: Color = .seasaltJet
    let text: Color = .eerieSeasalt
    let accent: Color = .crayolaBlue
    let high: Color = .crayolaBlue
    let medium: Color = .mustard
    let low: Color = .asparagus
}

struct ColorView: View {
    
    @State var color = ColorSettings()
    
    var body: some View {
        ZStack {
            Rectangle().fill(color.background).ignoresSafeArea()
            
            HStack {
                Text("this is an empty view")
                    .foregroundStyle(color.text)
    
                Button(action: {
                    print("empty")
                }, label: {
                    Image(systemName: "circle.fill")
                })
                .foregroundStyle(color.accent)
            }
            .font(.system(size: 30))
        }
    }
}

#Preview("light") {
    ColorView()
}

#Preview("dark") {
    EmptyView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
