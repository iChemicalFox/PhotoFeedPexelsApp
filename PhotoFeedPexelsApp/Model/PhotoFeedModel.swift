import Foundation

final class PhotoFeedModel {
    private let api = APIManager()
    var imagePosts = [PhotoPost]()
    var page: Int = 0
    var totalResults: Int = 0
    
    func searchPhotos(with query: String, page: Int, perPage: Int) async throws {
        let searchResponse = try await api.search(query: query, page: page, perPage: perPage)
        
        guard let searchResponse = searchResponse else { return }
        
        self.page = searchResponse.page
        self.totalResults = searchResponse.totalResults
        
        let photos = searchResponse.photos
        
        photos.forEach{ photoItem in
            self.imagePosts.append(PhotoPost(id: photoItem.id,
                                             author: photoItem.photographer,
                                             postPhotoUrlString: photoItem.src.large,
                                             fullPhotoUrlString: photoItem.src.original,
                                             originalHeightPixels: photoItem.height,
                                             originalWidthPixels: photoItem.width))
        }
    }
    
    func clearResult() {
        imagePosts = []
    }
}
