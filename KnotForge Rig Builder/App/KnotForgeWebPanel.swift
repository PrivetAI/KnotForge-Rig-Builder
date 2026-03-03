import SwiftUI
import WebKit

struct KnotForgeWebPanel: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        }
        let knotforgeDisplayPage = WKWebView(frame: .zero, configuration: config)
        knotforgeDisplayPage.scrollView.bounces = true
        knotforgeDisplayPage.allowsBackForwardNavigationGestures = true
        if let url = URL(string: urlString) {
            knotforgeDisplayPage.load(URLRequest(url: url))
        }
        return knotforgeDisplayPage
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
