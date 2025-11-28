import SwiftUI
import UIComponents

struct UISplashView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .backgroundGradient()
    }
}
