import SwiftUI


struct TitleView: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 25, weight: .bold))
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview("main") {
    MainView()
}

#Preview {
    TitleView(title: "sample task list")
}
