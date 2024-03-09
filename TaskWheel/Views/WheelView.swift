import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = -1
    @State var rotateBy: CGFloat = 0.0
    
    private var numSlices: Int { alphabet.count }
    private var sliceSize: CGFloat {
        return 360.0 / CGFloat(numSlices) // Angle in degrees
    }
    
    let alphabet = ["All the complications in the ", "Back to back long texts will look like this", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "This is going to be long", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            wheelCircleView()
            
            Icon(this: .ticker, size: 20)
                .shadow(radius: 3)
                .padding(.horizontal, -15)
            
            spinButton()
                .padding(25)
        }
    }
}
 
extension WheelView {
    
    private func wheelCircleView() -> some View {
        GeometryReader { geometry in
            let diameter: CGFloat = geometry.size.width * 2
            
            ZStack(alignment: .trailing) {
                ZStack {
                    Circle().fill(.gray.opacity(0.2))
                    
                    ForEach(alphabet.indices, id: \.self) { index in
                        WheelSegmentView(
                            text: alphabet[index],
                            index: index,
                            angle: angle(at: index),
                            textOffset: geometry.size.width - 25,
                            selectedIndex: $selected
                        )
                    }
                    .rotationEffect(.degrees(rotateBy))
                    .animation(.easeInOut(duration: 4), value: rotateBy)
                }
                .frame(width: diameter, height: diameter)
                .position(CGPoint(x: 0, y: geometry.size.height / 2))
            }
        }
    }
    
    private func spinButton() -> some View {
        Button {
            selected = Int.random(in: 0..<numSlices)

            let currentAngle = fmod(rotateBy, 360)
            let targetAngle = 360 - Double(selected) * 360.0 / Double(numSlices)
            let angleDifference = fmod(360 - currentAngle + targetAngle, 360)

            // Apply the rotation with animation
            withAnimation(.easeInOut(duration: 6)) {
                rotateBy += 360 * 5 + angleDifference
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
    
    private func angle(at index: Int) -> CGFloat {
        return sliceSize * CGFloat(index)
    }
    
    private func angleForLetter(at index: Int) -> Double {
        return Double(index) * 360.0 / Double(numSlices)
    }
    
}

struct WheelSegmentView: View {
    
    @State var text: String
    @State var index: Int
    @State var angle: CGFloat
    @State var textOffset: CGFloat
    @State var textWidth: CGFloat = 20
    
    @Binding var selectedIndex: Int
    
    var fontSize: CGFloat = 20
    
    var body: some View {
        let xOffset = cos(angle * .pi / 180.0) * (textOffset - textWidth / 2)
        let yOffset = sin(angle * .pi / 180.0) * (textOffset - textWidth / 2)
        
        Text(text)
            .lineLimit(1)
            .font(.system(size: fontSize))
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            textWidth = proxy.size.width
                        }
                }
            }
            .rotationEffect(.degrees(angle))
            .offset(x: xOffset, y: yOffset)
            .frame(maxWidth: 150)
            .fontWeight(selectedIndex == index ? .bold : .regular)
    }
}


#Preview {
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
