import SwiftUI

struct SyncSpinner: View {
    @State var borderInit: Bool = false
    @State var spinArrow: Bool = false
    @State var dismissArrow: Bool = false
    @State var displayCheckmark: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            // Border
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: borderInit ? 10 : 64))
                .frame(width: 128, height: 128)
                .foregroundColor(borderInit ? .green : .black)
                .animation(.easeOut(duration: 3).speed(1.5))
                .onAppear() {
                    borderInit.toggle()
                }
            
            // Arrow Icon
            Image(systemName: "arrow.2.circlepath")
                .font(.largeTitle)
                .foregroundColor(.white)
                .rotationEffect(.degrees(spinArrow ? 360 : -360))
                .opacity(dismissArrow ? 0 : 1)
                .animation(.easeOut(duration: 2))
                .onAppear() {
                    spinArrow.toggle()
                    withAnimation(Animation.easeInOut(duration: 1).delay(1)) {
                        self.dismissArrow.toggle()
                    }
                }
            
            // Checkmark
            Path { path in
                path.move(to: CGPoint(x: 20, y: -40))
                path.addLine(to: CGPoint(x: 40, y: -20))
                path.addLine(to: CGPoint(x: 80, y: -60))
            }
            .trim(from: 0, to: displayCheckmark ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .foregroundColor(displayCheckmark ? .green : .black)
            .offset(x: 150, y: 420)
            .animation(.spring(.bouncy, blendDuration: 2).delay(2))
            .onAppear() {
                displayCheckmark.toggle()
            }
        }
            .background(.black)
    }
}
