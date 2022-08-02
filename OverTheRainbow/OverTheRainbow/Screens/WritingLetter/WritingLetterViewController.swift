//
//  WritingLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit
import Photos
import PhotosUI

class WritingLetterViewController: UIViewController {
    
    @IBOutlet weak var writingLetterNavigationBar: UINavigationBar!
    @IBOutlet var navBarRightButton: UIBarButtonItem!
    @IBOutlet var navBarLeftButton: UIBarButtonItem!
    
    @IBOutlet weak var openGallery: UIImageView!
    @IBOutlet weak var letterTitle: UITextField!
    @IBOutlet weak var letterContent: UITextView!
    @IBOutlet weak var writingDate: UILabel!
    @IBOutlet weak var selectPicture: UIButton!
    
    let date = Date()
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    let petID = UserDefaults.standard.string(forKey: "petID") ?? "없음"
    var parentVC: LetterLitstMainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writingLetterNavigationBar.tintColor = UIColor(named: "boxBarColor")
        leftNavBarButtonSetting()
        rightNavBarButtonSetting()
        
        imageViewAndGalleryBtnSetting()
        
        letterTitle.placeholder = "제목을 작성해주세요"
        letterTitle.delegate = self
        letterTitle.returnKeyType = .done
        
        letterContent.delegate = self
        letterContent.text = "어떤 말을 전하고 싶나요?"
        letterContent.textColor = UIColor.lightGray
        
        dateLabelSetting()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func callingActionSheet(_ sender: UIBarButtonItem) {
        showActionSheet()
    }
    
    
    @IBAction func doneWritingLetter(_ sender: UIBarButtonItem) {
        if checkWrittenCorrectly() {
            let letter = LetterInput(title: letterTitle.text!, content: letterContent.text, image: openGallery.image)
            let letterID = try? service.addLetter(LetterInputDto(petId: petID, letter: letter))
            try? service.saveLetters(letterID!)
            parentVC?.setLists()
            dismiss(animated: true)
        }
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let first = UIAlertAction(title: "임시 저장", style: .default) { [self]_ in
            if checkWrittenCorrectly() {
                let letter = LetterInput(title: letterTitle.text!, content: letterContent.text, image: openGallery.image)
                try? service.addLetter(LetterInputDto(petId: petID, letter: letter))
                self.dismiss(animated: true)
            }
        }
        let second = UIAlertAction(title: "작성 취소", style: .destructive) { [self]_ in
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "돌아가기", style: .cancel){_ in}
        
        actionSheet.addAction(first)
        actionSheet.addAction(second)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func leftNavBarButtonSetting() {
        let customButton = UIButton()
        customButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        customButton.setTitle(" 취소", for: .normal)
        customButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        customButton.tintColor = UIColor(named: "textColor")
        customButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        writingLetterNavigationBar.items?[0].leftBarButtonItem = UIBarButtonItem(customView: customButton)
    }
    
    private func rightNavBarButtonSetting() {
        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        navBarRightButton.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func dateLabelSetting() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        writingDate.text = dateFormatter.string(from: date)
    }

    private func imageViewAndGalleryBtnSetting(){
        let largeSymbol = UIImage.SymbolConfiguration(pointSize: 86, weight: .bold, scale: .large)
        let largeBoldButton = UIImage(systemName: "plus.square.dashed", withConfiguration: largeSymbol)
        selectPicture.setImage(largeBoldButton, for: .normal)
        selectPicture.tintColor = UIColor(named: "textColor")
        selectPicture.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        openGallery.layer.cornerRadius = 10
    }

    private func checkWrittenCorrectly() -> Bool {
        if openGallery.image == nil {
            let alert = UIAlertController(title: "오류", message: "사진을 입력하지 않으셨습니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
            return false
        }
        else if letterTitle.text!.isEmpty {
            let alret = UIAlertController(title: "오류", message: "제목을 입력하지 않으셨습니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alret.addAction(confirm)
            present(alret, animated: true, completion: nil)
            return false
        }
        else if letterContent.textColor == UIColor.lightGray {
            let alret = UIAlertController(title: "오류", message: "내용을 입력하지 않으셨습니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alret.addAction(confirm)
            present(alret, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension WritingLetterViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    } // 텍스트 뷰에 포커스 잡히면 원래 있던 글자가 placeholder 처럼 작동
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "어떤 말을 전하고 싶나요?"
            textView.textColor = UIColor.lightGray
        }
    } // 텍스트 뷰가 비어있으면 placeholder 유지
}

extension WritingLetterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.letterTitle {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

@available(iOS 14, *)
extension WritingLetterViewController: PHPickerViewControllerDelegate {
    @objc func pickImage(sender: UIButton) {
        selectPicture = sender
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        view.endEditing(true)// 편지 작성하다가도 사진 불러오기 버튼 누르면 키보드 사라지도록 변경
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
                DispatchQueue.main.async {
                    self.openGallery.image = image as? UIImage
                    self.openGallery.contentMode = .scaleAspectFill
                    if (image) != nil {
                        self.selectPicture.setImage(UIImage(), for: .normal)
                    }
                }
            }
        }
    }
}
