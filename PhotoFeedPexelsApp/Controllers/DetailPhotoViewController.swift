import UIKit

final class DetailPhotoViewController: UIViewController, UIScrollViewDelegate {
    let photoPost: PhotoPost
    
    private let imageView: WebImageView = {
        WebImageView()
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.backgroundColor = .white
        
        return scrollView
    }()
    
    init(imagePost: PhotoPost) {
        self.photoPost = imagePost

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(photoPost.author)"
        
        setupScrollView()
        
        setZoomScale(for: scrollView.bounds.size)
        scrollView.zoomScale = scrollView.minimumZoomScale
        recentImage()
    }
    
    private func setupScrollView() {
        let imageHeight: CGFloat = photoPost.originalHeightPixels / UIScreen.main.scale
        let imageWidth: CGFloat = photoPost.originalWidthPixels / UIScreen.main.scale
        let fullImageUrlString: String = photoPost.fullPhotoUrlString
        
        imageView.frame = .init(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = imageView.bounds.size
        scrollView.delegate = self
        
        Task {
            do {
                try await imageView.set(imageURL: fullImageUrlString)

            } catch {
                print(error.localizedDescription)
            }
        }
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }
    
    private func setZoomScale(for scrollViewSize: CGSize) {
        let imageHeight: CGFloat = photoPost.originalHeightPixels / UIScreen.main.scale
        let imageWidth: CGFloat = photoPost.originalWidthPixels / UIScreen.main.scale
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        let widthScale: CGFloat = scrollViewSize.width / imageSize.width
        let heightScale: CGFloat = scrollViewSize.height / imageSize.height
        let minScale: CGFloat = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.0
    }
    
    private func recentImage() {
        let scrollViewSize: CGSize = scrollView.bounds.size
        let imageViewSize: CGSize = imageView.frame.size
        
        let horizontalSpace: CGFloat = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2.0 : 0
        let verticalSpace: CGFloat = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2.0 : 0
        
        let windowScene: UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window: UIWindow? = windowScene?.windows.first
        let bottomPadding: CGFloat = window?.safeAreaInsets.bottom ?? 0
        
        let navIndent: CGFloat = navigationController != nil ? navigationController!.navigationBar.bounds.height : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace - navIndent - bottomPadding,
                                               left: horizontalSpace,
                                               bottom: verticalSpace,
                                               right: horizontalSpace)
    }
}

// MARK: UIScrollViewDelegate

extension DetailPhotoViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recentImage()
    }
}
