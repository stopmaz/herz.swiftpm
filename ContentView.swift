import SwiftUI

struct ContentView: View {
    @State private var isBeating = false
    @State private var animatedText = ""
    @State private var color: Color = .pink
    @State private var shouldAnimate = true

    let text = "Only my heart beats for you, Linda"
    let animationDuration: Double = 0.1
    let delayBeforeRepeat: Double = 5.0

    var body: some View {
        VStack {
            
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.pink)
                .scaleEffect(isBeating ? 1.2 : 1.0)
                .shadow(color: .pink.opacity(0.6), radius: isBeating ? 20 : 0)
                .animation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true),
                    value: isBeating
                )
                .onAppear {
                    isBeating = true
                    startTextAnimation()
                }

            
            Text(animatedText)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
                .padding(.top, 20)
        }
        .padding()
    }

    
    func startTextAnimation() {
        animatedText = ""
        color = .pink

        for (index, letter) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * animationDuration) {
                withAnimation(.easeIn(duration: animationDuration)) {
                    animatedText.append(letter)
                    let progress = Double(index) / Double(text.count)
                    color = Color.pink.interpolate(to: .gray, progress: progress)
                }
            }
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.count) * animationDuration + delayBeforeRepeat) {
            if shouldAnimate {
                startTextAnimation()
            }
        }
    }
}

extension Color {
    
    func interpolate(to color: Color, progress: Double) -> Color {
        let fromComponents = UIColor(self).cgColor.components!
        let toComponents = UIColor(color).cgColor.components!
        
        let r = fromComponents[0] + (toComponents[0] - fromComponents[0]) * CGFloat(progress)
        let g = fromComponents[1] + (toComponents[1] - fromComponents[1]) * CGFloat(progress)
        let b = fromComponents[2] + (toComponents[2] - fromComponents[2]) * CGFloat(progress)
        
        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
