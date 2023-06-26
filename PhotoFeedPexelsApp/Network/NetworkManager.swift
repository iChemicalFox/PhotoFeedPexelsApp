import Foundation

protocol Networking {
    func sendRequest(method: APIMethodsList, params: [String: String]) async throws -> Data
}

final class NetworkManager: Networking {
    func sendRequest(method: APIMethodsList, params: [String : String]) async throws -> Data {
        let token = "7LOz72XArd4RTp9ywll75Oa88TSCWEJwTJY2xkPMosKSt3zbKsnGZ6fE" // 🤫
        
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30 // 30 sec
        let session = URLSession(configuration: configuration)
        
        let url = self.url(from: method, params: params)
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let (data, _) = try await session.data(for: request)
        
        return data
    }
       
    private func url(from method: APIMethodsList, params: [String: String]) -> URL {
        let basePath: String = "https://api.pexels.com/"
        let version: String = "v1"
        
        return URL(string: basePath)!
            .appendingPathComponent(version)
            .appendingPathComponent(method.rawValue)
            .appending(queryItems: params.map { URLQueryItem(name: $0, value: $1) })
    }
}
