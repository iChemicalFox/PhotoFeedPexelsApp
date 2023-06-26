import UIKit

final class PhotoFeedTableViewController: UITableViewController {
    private let imageFeedModel = PhotoFeedModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var currentPage: Int = 1
    private let perPage: Int = 10
    private let photoQuery: String = "people"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Photo Feed for Lowkey's guys", comment: "")
        
        tableView.register(PhotoPostTableViewCell.self, forCellReuseIdentifier: "ImagePostTableViewCell")
        tableView.separatorStyle = .none
        
        Task {
            do {
                showActivityIndicator()
                try await imageFeedModel.searchPhotos(with: photoQuery, page: currentPage, perPage: perPage)
                tableView.reloadData()
                removeActivityIndicator()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        addRefreshControl()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostTableViewCell", for: indexPath) as? PhotoPostTableViewCell else {
            return UITableViewCell()
        }
        
        let imagePost = imageFeedModel.imagePosts[indexPath.row]
        
        cell.authorLabel.text = imagePost.author
        Task {
            do {
                try await cell.postImageView.set(imageURL: imagePost.postPhotoUrlString)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageFeedModel.imagePosts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imagePost: PhotoPost = imageFeedModel.imagePosts[indexPath.row]
        let viewController = DetailPhotoViewController(imagePost: imagePost)
        
        show(viewController, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalPages = imageFeedModel.totalResults / perPage
        
        if indexPath.row == imageFeedModel.imagePosts.count - 2, currentPage < totalPages {
            Task {
                do {
                    try await loadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoHeight: CGFloat = imageFeedModel.imagePosts[indexPath.row].originalHeightPixels / UIScreen.main.scale
        let photoWidth: CGFloat = imageFeedModel.imagePosts[indexPath.row].originalWidthPixels / UIScreen.main.scale
        let ratio: CGFloat = photoWidth / photoHeight
        let maxHeight: CGFloat = CellContains.maxHeight
        
        if ratio >= 1 {
            let scaledPhotoWidth: CGFloat = UIScreen.main.bounds.width - CellContains.contentIndent * 2
            let scaledPhotoHeight: CGFloat = scaledPhotoWidth / ratio
            let height: CGFloat = scaledPhotoHeight + CellContains.labelHeight + CellContains.bottomIndent + CellContains.topIndent + CellContains.indentBetweenLabelAndImage + CellContains.contentIndent * 2
            
            return height
        }
        
        return maxHeight
    }
    
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: Refresh and load data
    
    @objc func loadData() async throws {
        try await imageFeedModel.searchPhotos(with: photoQuery, page: currentPage + 1, perPage: perPage)
        tableView.reloadData()
        currentPage += 1
    }
    
    @objc func refreshData() {
        currentPage = 1
        
        imageFeedModel.clearResult()
        
        Task {
            do {
                try await imageFeedModel.searchPhotos(with: photoQuery, page: currentPage, perPage: perPage)
                tableView.reloadData()
                refreshControl?.endRefreshing()
                removeActivityIndicator()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: Activity indicator

extension PhotoFeedTableViewController {
    private func showActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.color = .systemBlue
        
        let middleYPoint: CGFloat = UIScreen.main.bounds.width / 2 - activityIndicator.frame.width / 2
        activityIndicator.frame = CGRect(x: middleYPoint,
                                         y: 50,
                                         width: activityIndicator.frame.width,
                                         height: activityIndicator.frame.height)
        
        activityIndicator.startAnimating()
    }
    
    private func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
}
