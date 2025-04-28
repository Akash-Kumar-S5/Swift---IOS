import SwiftUI

struct UrlPreview: View {
    @State private var rawJSON: String = "Loading…"

    var body: some View {
        ScrollView {
            Text(rawJSON)
                .padding()
                .font(.system(.body, design: .monospaced))
        }
        .onAppear {
            fetchAndDisplay()
        }
    }

    private func fetchAndDisplay() {
        let request = UrlGetRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                rawJSON = "🛑 Network error: \(error.localizedDescription)"
                return
            }
            
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                rawJSON = "🛑 HTTP error: status code \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                return
            }
            
            guard let data = data,
                  let jsonString = String(data: data, encoding: .utf8) else {
                      rawJSON = "🛑 No data or invalid encoding"
                return
            }
            
            rawJSON = jsonString
//            updateUI(jsonString)
        }
        .resume()
    }
    
}

func UrlGetRequest() -> URLRequest {
    guard let url = URL(string: "https://dummyjson.com/products") else {
        fatalError("Invalid URL")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    return request
}

#Preview {
    UrlPreview()
}
