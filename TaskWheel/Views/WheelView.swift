import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            CircleWheelView()
            
            spinButton()
                .padding(25)
        }
    }
    
    private func spinButton() -> some View {
        Button {
            print("spinning")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.accent)
                
                Text("Spin").foregroundStyle(.textAlt)
                    .padding(8)
                    .padding(.horizontal, 8)
            }
            .frame(height: 30)
            .fixedSize()
        }
    }
    
}

struct CircleWheelView: View {
    
//    @Binding var rotation: CGFloat
    
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "This is going to be long", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        GeometryReader { geometry in
            let tickerSize: CGFloat = 20
            let diameter: CGFloat = geometry.size.width * 2 - tickerSize / 2
            let thisOffset = geometry.size.width / 1.5
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            
            HStack {
                ZStack {
                    Circle().fill(.lowBackground)
                        
                    ForEach(alphabet.indices, id: \.self) { index in
//                        let width = textWidth(alphabet[index], font: .system(size: 20))
                        let angle = rotation(index: index)
                        let xOffset = cos(angle) * (thisOffset + 30 / 2) // Adjusting offset based on text width
                        let yOffset = sin(angle) * (thisOffset + 30 / 2)
                        
                        Text(alphabet[index])
                            .rotationEffect(.radians(angle))
                            .offset(x: xOffset, y: yOffset)
                    }
                }
                .frame(width: diameter, height: diameter)
                .position(CGPoint(x: 0, y: geometry.size.height / 2))
                
                
                Icon(this: .ticker, size: tickerSize)
                    .shadow(radius: 3)
            }
        }
    }
    
    var sliceSize: CGFloat {
        1 / CGFloat(alphabet.count)
    }
    
    func rotation(index: Int) -> CGFloat {
        (.pi * (2 * sliceSize * (CGFloat(index + 1))))
    }
    
    func textWidth(_ text: String, font: Font) -> CGFloat {
        let attributedString = NSAttributedString(string: text, attributes: [.font: font])
        let size = attributedString.size()
        return size.width
    }
}


#Preview {
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
