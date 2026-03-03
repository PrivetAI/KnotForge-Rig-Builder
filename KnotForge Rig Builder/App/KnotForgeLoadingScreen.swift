import SwiftUI

struct KnotForgeLoadingScreen: View {
    @State private var dotCount = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            AppTheme.surfaceBg
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                HookIcon()
                    .stroke(AppTheme.accent, lineWidth: 2)
                    .frame(width: 60, height: 60)

                Text("KNOTFORGE: RIG BUILDER")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(AppTheme.frostWhite)
                    .tracking(2)

                HStack(spacing: 4) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(i < dotCount ? AppTheme.accent : AppTheme.slateBlue)
                            .frame(width: 8, height: 8)
                    }
                }
                .onReceive(timer) { _ in
                    dotCount = (dotCount + 1) % 4
                }
            }
        }
    }
}
