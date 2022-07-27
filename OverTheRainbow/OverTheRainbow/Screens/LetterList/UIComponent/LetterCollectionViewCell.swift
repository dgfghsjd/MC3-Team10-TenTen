//
//  LetterCollectionViewCell.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/25.
//

import UIKit

final class LetterCollectionViewCell: UICollectionViewCell {
    static let identifier = "LetterCollectionViewCell"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    private var photoStampView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes:
                                                   UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        photoStampView.image = nil
    }
    func configUI() {
        backgroundColor = UIColor(named: "boxBarColor")
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    func render() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(photoStampView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17)
        ]
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateLabelConstraints = [
            dateLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 150),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 300)
        ]
        photoStampView.translatesAutoresizingMaskIntoConstraints = false
        let photoStampConstraints = [
            photoStampView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoStampView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 230),
            photoStampView.heightAnchor.constraint(equalToConstant: 100),
            photoStampView.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(photoStampConstraints)
    }
    // MARK: - func
    func setLetterData(with data: LetterModel) {
        dateLabel.text = data.date
        if let title = data.title {
            titleLabel.text = title
        }
        
        if let image = data.image {
            // FIXME: - 현재는 더미
            photoStampView.image = UIImage(systemName: "heart.fill")
//            photoStampView.heightAnchor.constraint(equalToConstant: 204)
        }
    }
}
