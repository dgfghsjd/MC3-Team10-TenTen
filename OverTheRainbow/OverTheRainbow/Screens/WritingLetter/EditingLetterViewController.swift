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
    let petID = "62e60ab040a87a9ab0637612"
//        let petID = UserDefaults.standard.string(forKey: "petID") ?? "없음"
    
    override func viewDidLoad() {
        let letter = try? service.findLetter("62e60b0440a87a9ab0637613")
        super.viewDidLoad()
        
        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        naavBarRightItem.setTitleTextAttributes(attributes, for: .normal)

        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = UIColor(named: "textColor")
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        editingLetterNavBar.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        galleryImageView.layer.cornerRadius = 10
//        galleryImageView.image = letter.imgUrl? as UIImage

        let largeSymbol = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let largeBoldButton = UIImage(systemName: "plus.square.dashed", withConfiguration: largeSymbol)

        btnChangeImage.setImage(largeBoldButton, for: .normal)
        btnChangeImage.tintColor = UIColor(named: "textColor")
        btnChangeImage.alpha = 0.2
        btnChangeImage.addTarget(self, action: #selector(changeImage), for: .touchUpInside)

        letterTitle.returnKeyType = .done
        letterTitle.text = letter?.title

        letterContent.text = letter?.content
        
        writtenDate.text = letter?.date
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
            let letter = LetterInput(title: letterTitle.text!, content: letterContent.text, image: galleryImageView.image)
            let letterID = try? service.addLetter(LetterInputDto(petId: petID, letter: letter))
            try? service.saveLetters(letterID!)
            dismiss(animated: true)
            print("작성을 완료했습니다.")
        }
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let first = UIAlertAction(title: "편지 삭제", style: .destructive) {
            action in print("1")
            self.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel){_ in}

        actionSheet.addAction(first)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
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
