//
//  LetterListViewController.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/18.
//

import UIKit
import SwiftUI

class LetterLitstMainViewController: BaseViewController {
    private var lists: [LetterResultDto] {
        let service = DataAccessProvider.dataAccessConfig.getService()
        
        let petID = "62e60ab040a87a9ab0637612"
//        let petID = UserDefaults.standard.string(forKey: "petID") ?? "없음"
        // swiftlint:disable:next force_try
        return try! service.findUnsentLetters(petID)
    }
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 16.0
        static let collectionVerticalSpacing: CGFloat = 17.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing
                                          * 2 - collectionVerticalSpacing) / 2
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        return flowLayout
    }()
    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LetterCollectionViewCell.self,
                                forCellWithReuseIdentifier: LetterCollectionViewCell.className)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func render () {
        view.addSubview(listCollectionView)
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let listCollectionViewConstraints = [
            listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            listCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 3),
            listCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 3),
            listCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 3),
//            listCollectionView.heightAnchor.constraint(equalToConstant: 10000)
        ]
        NSLayoutConstraint.activate(listCollectionViewConstraints)
    }
    override func configUI() {
        super.configUI()
    }
    override func setupNavigationBar() {
        super.setupNavigationBar()
    }
    private func pushDetailView() {
         let storyBoard = UIStoryboard(name: "WritingLetter", bundle: nil)
         guard let viewController = storyBoard.instantiateViewController(withIdentifier: "letterList") as?  WrittenLetterViewController else { return }
         self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension LetterLitstMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell =  collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.setLetterData(with: lists[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LetterLitstMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushDetailView()
    }
}
