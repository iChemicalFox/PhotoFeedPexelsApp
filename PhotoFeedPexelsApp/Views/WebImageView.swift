import UIKit

final class WebImageView: UIImageView {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func set(imageURL: String) async throws {
        guard let url = URL(string: imageURL) else { return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)

            return
        }
        
        showActivityIndicator()
        
        let (data, response) = try await URLSession.shared.data(from: url)
        image = UIImage(data: data)
        handleLoadedImage(data: data, response: response)
        removeActivityIndicator()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}

// MARK: Activity indicator

extension WebImageView {
    private func showActivityIndicator() {
        addSubview(activityIndicator)
        
        activityIndicator.color = .systemBlue
        activityIndicator.transform = .init(scaleX: 1, y: 1)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: activityIndicator,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0))
        
        activityIndicator.startAnimating()
    }
    
    private func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
}

