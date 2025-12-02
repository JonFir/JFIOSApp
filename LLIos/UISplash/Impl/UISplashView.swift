import SwiftUI
import UIComponents
import Resources

struct UISplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("header.title", bundle: .module)
                .textStyle(.title)
                .foregroundColor(ResourcesAsset.primaryRed.swiftUIColor)
            
            AnimatedDotsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .backgroundGradient()
    }
}

private struct AnimatedDotsView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.3)) { timeline in
            let currentDot = calculateCurrentDot(date: timeline.date)
            
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(ResourcesAsset.primaryRed.swiftUIColor)
                        .frame(width: 12, height: 12)
                        .opacity(currentDot == index ? 1.0 : 0.0)
                        .shadow(
                            color: ResourcesAsset.shadowRed.swiftUIColor.opacity(currentDot == index ? 1.0 : 0.0),
                            radius: 10
                        )
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentDot)
        }
    }
    
    private func calculateCurrentDot(date: Date) -> Int {
        let interval = date.timeIntervalSinceReferenceDate
        let cycle = Int(interval / 0.3) % 4
        return cycle < 3 ? cycle : -1
    }
}

#Preview {
    UISplashView()
}
