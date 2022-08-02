//
//  LetterCollectionViewCell.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/25.
//  swiftlint:disable force_try

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
    private var isSavedLabel: UIImageView = {
        let savedIconView = UIImageView(frame: .zero)
        return savedIconView
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
        contentView.addSubview(isSavedLabel)
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
        isSavedLabel.translatesAutoresizingMaskIntoConstraints = false
        let isSavedLabelConstraints = [
            isSavedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            isSavedLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            isSavedLabel.heightAnchor.constraint(equalToConstant: 30),
            isSavedLabel.widthAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(photoStampConstraints)
        NSLayoutConstraint.activate(isSavedLabelConstraints)
    }
    // MARK: - func
    func setLetterData(with data: LetterResultDto) {
        dateLabel.text = data.date
        titleLabel.text = data.title
        
        if let image = data.imgUrl {
            // FIXME: - 현재는 더미
            if let data = try? Data(contentsOf: data.imgUrl!) {
                if let image = UIImage(data: data) {
                    photoStampView.image = image
                }
            }
        }
        print(data.status)
        if data.status == .saved {
            isSavedLabel.image = ImageLiterals.savedIcon
            isSavedLabel.tintColor = UIColor(named: "textColor")
//            self.tintColor
//            UIColor(named: "textColor")
        }
    }
    func updateLetterData(with letterID: String) {
        print("called")
        let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
        let letter = try! service.findLetter(letterID)
        let storyBoard = UIStoryboard(name: "WritingLetter", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "letterList") as?  WrittenLetterViewController else { return }
        if viewController.letterHasChanged == true {
            dateLabel.text = letter.date
            titleLabel.text = letter.title
            
            if let image = letter.imgUrl {
                // FIXME: - 현재는 더미
                photoStampView.image = UIImage(systemName: "heart.fill")
                photoStampView.image?.withTintColor(UIColor(named: "textColor") ?? .black)
    //            photoStampView.heightAnchor.constraint(equalToConstant: 204)
            }
            print(letter.status)
            if letter.status == .saved {
                isSavedLabel.image = ImageLiterals.savedIcon
                isSavedLabel.tintColor = UIColor(named: "textColor")
    //            self.tintColor
    //            UIColor(named: "textColor")
            }
        }
    }
}
