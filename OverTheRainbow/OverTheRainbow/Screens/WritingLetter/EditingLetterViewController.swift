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
    @IBOutlet weak var naavBarRightItem: UIBarButtonItem!
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var btnChangeImage: UIButton!
    @IBOutlet weak var letterTitle: UITextField!
    @IBOutlet weak var letterContent: UITextView!
    @IBOutlet weak var writtenDate: UILabel!
    var button = UIButton(type: .system)
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    let petID = "62e7ddbc686583a6c967db26"
    //        let petID = UserDefaults.standard.string(forKey: "petID") ?? "없음"
    var letterID: String! = ""
    
    var parentController: UINavigationController?
    var parentVC: WrittenLetterViewController?
    
    override func viewDidLoad() {
        let editingLetter = try! service.findLetter(letterID)
        try! service.unsaveLetters(letterID)
        super.viewDidLoad()
        
        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        naavBarRightItem.setTitleTextAttributes(attributes, for: .normal)
        
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = UIColor(named: "textColor")
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        editingLetterNavBar.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        galleryImageView.layer.cornerRadius = 10
        galleryImageView.contentMode = .scaleAspectFill
        load(url: editingLetter.imgUrl!)
        
        let largeSymbol = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let largeBoldButton = UIImage(systemName: "plus.square.dashed", withConfiguration: largeSymbol)
        
        btnChangeImage.setImage(largeBoldButton, for: .normal)
        btnChangeImage.tintColor = UIColor(named: "textColor")
        btnChangeImage.alpha = 0.2
        btnChangeImage.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        
        letterTitle.returnKeyType = .done
        letterTitle.text = editingLetter.title
        
        letterContent.text = editingLetter.content
        
        writtenDate.text = editingLetter.date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateLetter()
    }
    
    @IBAction func doneeditingLetter(_ sender: UIBarButtonItem) {
        if letterTitle.text!.isEmpty {
            print("제목을 입력하지 않으셨습니다.")
            let alret = UIAlertController(title: "오류", message: "제목을 입력하지 않으셨습니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alret.addAction(confirm)
            present(alret, animated: true, completion: nil)
        }
        else if letterContent.textColor == UIColor.lightGray {
            print("내용을 입력하지 않으셨습니다.")
            let alret = UIAlertController(title: "오류", message: "내용을 입력하지 않으셨습니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alret.addAction(confirm)
            present(alret, animated: true, completion: nil)
        }
        else {
            parentVC?.letterHasChanged = checkLetterChanged()
            let letter = LetterUpdateDto(id: self.letterID, title: letterTitle.text!, content: letterContent.text, image: galleryImageView.image)
            try? service.updateLetter(petId: petID, dto: letter)
            try? service.saveLetters(letter.id)
            dismiss(animated: true)
        }
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let first = UIAlertAction(title: "삭제하기", style: .destructive) { [self]_ in
            try? service.deleteLetter(petId: petID, letterId: letterID)
            self.dismiss(animated: true)
        }
        
        let second = UIAlertAction(title: "돌아가기", style: .default) { [self]_ in
            try? service.saveLetters(letterID)
            self.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel){_ in}
        
        actionSheet.addAction(second)
        actionSheet.addAction(first)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.galleryImageView.image = image                    }
                }
            }
        }
    }
    
    func updateLetter() {
        parentVC?.selectedLetterTitle.text = letterTitle.text
        parentVC?.selectedLetterContent.text = letterContent.text
        parentVC?.selectedLetterImage.image = galleryImageView.image
    }
    
    func checkLetterChanged() -> Bool {
        if parentVC?.selectedLetterTitle.text != letterTitle.text ||
            parentVC?.selectedLetterContent.text != letterContent.text ||
            parentVC?.selectedLetterImage.image != galleryImageView.image {
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
        //        dismissKeyboard() // 편지 작성하다가도 사진 불러오기 버튼 누르면 키보드 사라지도록 변경
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
