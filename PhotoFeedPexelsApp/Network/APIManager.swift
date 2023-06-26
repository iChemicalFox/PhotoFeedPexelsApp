import Foundation

final class APIManager {
    private let network = NetworkManager()
    
    func search(query: String, page: Int, perPage: Int) async throws -> SearchResponse? {
        let params = ["query": "\(query)", "page": "\(page)", "per_page": "\(perPage)"]
        let data = try await network.sendRequest(method: .search, params: params)
        
        return decodeJson(type: SearchResponse.self, from: data)
    }
}

// MARK: - Decode

extension APIManager {
    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }

        return response
    }
}

// MARK: - APIMethodsList

enum APIMethodsList: String {
    case search = "/search"
}
