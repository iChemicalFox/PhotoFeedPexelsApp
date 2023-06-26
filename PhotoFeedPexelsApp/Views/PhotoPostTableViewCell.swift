import UIKit

final class PhotoPostTableViewCell: UITableViewCell {
    let postImageView: WebImageView = {
        WebImageView()
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorLabel.text = nil
        postImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: CellContains.contentIndent, left: CellContains.contentIndent, bottom: CellContains.contentIndent, right: CellContains.contentIndent))
        
        let contentViewWidth: CGFloat = contentView.frame.width
        let contentViewHeight: CGFloat = contentView.frame.height
        
        authorLabel.frame = CGRect(x: CellContains.sideIndent,
                                   y: CellContains.topIndent,
                                   width: contentViewWidth - CellContains.sideIndent * 2,
                                   height: CellContains.labelHeight)
        
        postImageView.contentMode = .scaleAspectFit
        
        postImageView.frame = CGRect(x: 0,
                                     y: authorLabel.frame.maxY + CellContains.indentBetweenLabelAndImage,
                                     width: contentViewWidth,
                                     height: contentViewHeight - authorLabel.frame.height - CellContains.indentBetweenLabelAndImage - CellContains.topIndent - CellContains.bottomIndent)
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(authorLabel)
        contentView.addSubview(postImageView)

        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        contentView.layer.shadowRadius = 2
    }
}
