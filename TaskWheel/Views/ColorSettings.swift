import SwiftUI
import Observation

@Observable class ColorSettings {
    let background: Color = .seasaltJet
    let text: Color = .eerieSeasalt
    let accent: Color = .crayolaBlue
}

struct EmptyView: View {
    
    @State var color = ColorSettings()
    
    var body: some View {
        ZStack {
            Rectangle().fill(color.background).ignoresSafeArea()
            
            VStack {
                Text("hi my name is")
                    .foregroundStyle(color.text)
    
                Button(action: {
                    print("love")
                }, label: {
                    Image(systemName: "heart.fill")
                })
                .foregroundStyle(color.accent)
            }
            .font(.system(size: 30))
        }
    }
}

#Preview("light") {
    EmptyView()
}

#Preview("dark") {
    EmptyView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
