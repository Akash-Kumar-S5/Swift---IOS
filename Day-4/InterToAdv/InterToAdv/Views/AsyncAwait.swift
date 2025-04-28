import SwiftUI

struct UrlAsyncPreview: View {
    @State private var rawJSON: String = "Loading…"
    
    var body: some View {
        ScrollView {
            Text(rawJSON)
                .padding()
        }
        .task {
            await loadAndPrint()
        }
    }
    //URLSession.shared
            //    •    What it is: A shared singleton session using the default configuration.
            //    •    When to use: Simple one-off requests where you don’t need custom behavior.
    
    //default config for nornal session storage with cookie storage
        //        *    Persistent disk-based cache (respecting HTTP cache headers)
        //        •    Cookie storage in HTTPCookieStorage.shared
        //        •    Credential storage in the shared URLCredentialStorage
    
    //epharmal config for privacy since it stores all the data inside ram and when the session gets over the data is erased...
            //    •    No on-disk cache (all caches kept in memory and discarded when the session is invalidated)
            //    •    No persistent cookies (cookies only live in RAM during the session)
            //    •    No disk-based credentials
    
    //background
    
    private func loadAndPrint() async {
        let request = UrlGetRequest()
        do {
            let (data, response) = try await URLSession(configuration: .default).data(for: request)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                print("HTTP error:", (response as? HTTPURLResponse)?.statusCode ?? -1)
                rawJSON = "HTTP error"
                return
            }
            let jsonString = String(decoding: data, as: UTF8.self)
            print("Raw response:\n", jsonString)
            rawJSON = jsonString
        } catch {
            print("Request failed:", error)
            rawJSON = "Request failed: \(error.localizedDescription)"
        }
    }
}

#Preview {
    UrlAsyncPreview()
}

