import SwiftUI

struct TaskRowView: View {
    
    let task: String
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                
            } label: {
                Image(systemName: "checkmark.square")
            }
            .font(.system(size: 25))
            
            Text(task)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
        }
        .padding()
        .font(.system(size: 23))
    }
}

#Preview("main") {
    MainView()
}

#Preview {
    TaskRowView(task: "hi")
}
