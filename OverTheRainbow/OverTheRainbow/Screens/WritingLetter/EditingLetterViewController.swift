//
//  EditingLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/27.
//swiftlint:disable force_try

import UIKit
import PhotosUI



class EditingLetterViewController: UIViewController {
    @IBOutlet weak var editingLetterNavBar: UINavigationItem!
    @IBOutlet weak var navBarRightItem: UIBarButtonItem!
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var btnChangeImage: UIButton!
    @IBOutlet weak var letterTitle: UITextField!
    @IBOutlet weak var letterContent: UITextView!
    @IBOutlet weak var writtenDate: UILabel!
    
    var button = UIButton(type: .system)
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    let petID = UserDefaults.standard.string(forKey: "petID") ?? "없음"
    var letterID: String! = ""
    
    var parentController: UINavigationController?
    var parentVC: WrittenLetterViewController?
    
    override func viewDidLoad() {
        let editingLetter = try! service.findLetter(letterID)
        
        super.viewDidLoad()
        rightNavBarButtonSetting()
        leftNavBarButtonSetting()
        imageViewAndGalleryBtnSetting()
        
        load(url: editingLetter.imgUrl!)
        letterTitle.returnKeyType = .done
        galleryImageView.image = parentVC?.selectedLetterImage.image
        letterTitle.text = parentVC?.selectedLetterTitle.text
        letterContent.text = parentVC?.selectedLetterContent.text
        writtenDate.text = parentVC?.selectedLetterDate.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        parentVC?.letterHasChanged = checkLetterChanged()
        updateLetter()
    }
    
    @IBAction func doneEditingLetter(_ sender: UIBarButtonItem) {
        if checkCorrectlyEditted() {
            parentVC?.letterHasChanged = checkLetterChanged()
            updateLetter()
            dismiss(animated: true)
        }
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let first = UIAlertAction(title: "삭제하기", style: .destructive) { [self]_ in
            try? service.deleteLetter(petId: petID, letterId: letterID)
            self.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "돌아가기", style: .cancel){_ in}
        
        actionSheet.addAction(first)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.galleryImageView.image = image
                    }
                }
            }
        }
    }
    
    private func leftNavBarButtonSetting() {
        let customButton = UIButton()
        customButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        customButton.setTitle(" 취소", for: .normal)
        customButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        customButton.tintColor = UIColor(named: "textColor")
        customButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        editingLetterNavBar.leftBarButtonItem = UIBarButtonItem(customView: customButton)
    }
    
    private func rightNavBarButtonSetting() {
        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        navBarRightItem.setTitleTextAttributes(attributes, for: .normal)
    }

    private func imageViewAndGalleryBtnSetting(){
        galleryImageView.layer.cornerRadius = 10
        galleryImageView.contentMode = .scaleAspectFill
        
        let largeSymbol = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let largeBoldButton = UIImage(systemName: "plus.square.dashed", withConfiguration: largeSymbol)
        btnChangeImage.setImage(largeBoldButton, for: .normal)
        btnChangeImage.tintColor = UIColor(named: "textColor")
        btnChangeImage.alpha = 0.2
        btnChangeImage.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
    }
    
    func checkCorrectlyEditted() -> Bool {
        if letterTitle.text!.isEmpty || letterContent.text.isEmpty {
            let alret = UIAlertController(title: "오류", message: "빈 편지는 저장할 수 없습니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alret.addAction(confirm)
            present(alret, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func updateLetter() {
        parentVC?.selectedLetterTitle.text = letterTitle.text
        parentVC?.selectedLetterContent.text = letterContent.text
        parentVC?.selectedLetterImage.image = galleryImageView.image
    }
    
    func checkLetterChanged() -> Bool {
        if parentVC?.selectedLetterTitle.text != letterTitle.text || parentVC?.selectedLetterContent.text != letterContent.text || parentVC?.selectedLetterImage.image != galleryImageView.image {
            return true
        }
        return false
    }
    
}

@available(iOS 14, *)
extension EditingLetterViewController: PHPickerViewControllerDelegate {
    @objc func changeImage(sender: UIButton) {
        btnChangeImage = sender
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        view.endEditing(true) // 편지 작성하다가도 사진 불러오기 버튼 누르면 키보드 사라지도록 변경
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
                DispatchQueue.main.async {
                    self.galleryImageView.image = image as? UIImage
                    self.galleryImageView.contentMode = .scaleAspectFill
                    if (image) != nil {
                        self.btnChangeImage.setImage(UIImage(), for: .normal)
                    }
                }
            }
        }
    }
}
