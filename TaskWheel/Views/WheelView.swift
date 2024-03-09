import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = 0
    @State var rotateBy: Double = 0.0
    
    private let tickerSize: CGFloat = 20
    private var sliceSize: CGFloat { 1 / CGFloat(alphabet.count) }
    
    let alphabet = ["All the complications in the ", "Back to back long texts will look like this", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "This is going to be long", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            wheelCircleView()
            
            spinButton()
                .padding(25)
        }
    }
}
 
extension WheelView {
    
    private func wheelCircleView() -> some View {
        GeometryReader { geometry in
            let diameter: CGFloat = geometry.size.width * 2 - tickerSize / 2
            
            HStack {
                ZStack {
                    Circle().fill(.lowBackground)
                    
                    ForEach(alphabet.indices, id: \.self) { index in
                        WheelSegmentView(
                            text: alphabet[index],
                            index: index,
                            size: sliceSize,
                            textOffset: geometry.size.width - 25
                        )
                    }
                    .rotationEffect(.degrees(rotateBy))
                    .animation(.easeInOut(duration: 4), value: rotateBy)
                }
                .frame(width: diameter, height: diameter)
                .position(CGPoint(x: 0, y: geometry.size.height / 2))
                
                
                Icon(this: .ticker, size: tickerSize)
                    .shadow(radius: 3)
            }
        }
    }
    
    private func spinButton() -> some View {
        Button {
            let randomIndex = Int.random(in: 0..<alphabet.count)
            let angleDifference = angleForLetter(at: randomIndex) - rotateBy
            withAnimation(.linear(duration: 2)) {
                rotateBy += 360 * 5 + Double(Int.random(in: 10..<360))
            }
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
    
    private func angleForLetter(at index: Int) -> Double {
        let anglePerLetter = 360.0 / Double(alphabet.count)
        return -Double(index) * anglePerLetter
    }
    
}

//struct CircleWheelView: View {
//    
////    @Binding var rotation: CGFloat
//    
//    
//    
//    var body: some View {
//        
//    }
//    
//    
//    
//    func rotation(index: Int) -> CGFloat {
//        (.pi * (2 * sliceSize * (CGFloat(index + 1))))
//    }
//}

struct WheelSegmentView: View {
    
    @State var text: String
    @State var index: Int
    @State var size: CGFloat
    @State var textOffset: CGFloat
    @State private var textWidth: CGFloat = 0
    
    var fontSize: CGFloat = 20
    
    var body: some View {
        let width = textWidth
        let angle = .pi * (2 * size * (CGFloat(index + 1)))
        let xOffset = cos(angle) * (textOffset - width / 2)
        let yOffset = sin(angle) * (textOffset - width / 2)
        
        Text(text)
            .lineLimit(1)
            .font(.system(size: fontSize)) // font size should change according to number of slices
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            textWidth = proxy.size.width
                        }
                }
            }
            .rotationEffect(.radians(angle))
            .offset(x: xOffset, y: yOffset)
            .frame(maxWidth: 150)
    }
}


#Preview {
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
