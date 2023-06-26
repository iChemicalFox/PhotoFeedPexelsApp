import Foundation

struct SearchResponse: Decodable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let photos: [Photos]
}

struct Photos: Decodable {
    let id: Int
    let width: CGFloat
    let height: CGFloat
    let photographer: String
    let src: Source
}

struct Source: Decodable {
    let original: String
    let large: String
}


