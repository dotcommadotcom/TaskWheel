//import SwiftUI
//
//struct ContentView: View {
//    @State var rotation: CGFloat = 0.0
//       
//       var body: some View {
//           VStack {
//               Wheel(rotation: $rotation)
//                   .frame(width: 200, height: 200)
//                   .rotationEffect(.radians(rotation))
//                   .animation(.easeInOut(duration: 1.5), value: rotation)
//               Button("Spin") {
//                   let randomAmount = Double(Int.random(in: 7..<15))
//                   rotation += randomAmount
//               }
//           }
//           .padding()
//       }
//   }
//}
//
//#Preview {
//    ContentView()
//}
//
//struct Wheel: View {
//    
//    @Binding var rotation: CGFloat
//    
//    let segments = ["Steve", "John", "Bill", "Dave", "Alan"]
//    
//    var body: some View {
//        GeometryReader { proxy in
//            ZStack {
//                ForEach(segments.indices, id: \.self) { index in
//                    ZStack {
//                        Circle()
//                            .inset(by: proxy.size.width / 4)
//                            .trim(from: CGFloat(index) * segmentSize, to: CGFloat(index + 1) * segmentSize)
//                            .stroke(Color.all[index], style: StrokeStyle(lineWidth: proxy.size.width / 2))
//                            .rotationEffect(.radians(.pi * segmentSize))
//                            .opacity(0.3)
//                        label(text: segments[index], index: CGFloat(index), offset: proxy.size.width / 4)
//                    }
//                }
//            }
//        }
//    }
//    
//    var segmentSize: CGFloat {
//        1 / CGFloat(segments.count)
//    }
//    
//    func rotation(index: CGFloat) -> CGFloat {
//        (.pi * (2 * segmentSize * (CGFloat(index + 1))))
//    }
//    
//    func label(text: String, index: CGFloat, offset: CGFloat) -> some View {
//        Text(text)
//            .rotationEffect(.radians(rotation(index: CGFloat(index))))
//            .offset(x: cos(rotation(index: index)) * offset, y: sin(rotation(index: index)) * offset)
//    }
//}
//
//extension Color {
//    
//    static var all: [Color] {
//        [Color.yellow, .green, .pink, .cyan, .mint, .orange, .teal, .indigo]
//    }
//}
