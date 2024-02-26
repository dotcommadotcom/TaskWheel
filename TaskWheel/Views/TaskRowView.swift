import SwiftUI

struct TaskRowView: View {
    
    let task: String
    
    var body: some View {
        HStack() {
            Button(action: {}, label: {
                Image(systemName: "checkmark.square")
            })
            
            Text(task)
            
            Spacer()
        }
    }
}

#Preview {
    TaskRowView(task: "hi")
}
