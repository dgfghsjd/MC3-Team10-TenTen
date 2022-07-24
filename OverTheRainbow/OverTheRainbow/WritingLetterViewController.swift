//
//  WritingLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit

class WritingLetterViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var writingLetterNavBar: UINavigationItem!
    @IBOutlet weak var navBarRightItem: UIBarButtonItem!
    @IBOutlet weak var openGallery: UIImageView!
    @IBOutlet weak var letterTitle: UITextField!
    @IBOutlet weak var letterContent: UITextView!
    @IBOutlet weak var writingDate: UILabel!
    var button = UIButton(type: .system)
    let date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        writingLetterNavBar.title="편지 작성"

        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("취소", for: .normal)
        button.sizeToFit()
        writingLetterNavBar.leftBarButtonItem = UIBarButtonItem(customView: button)
        openGallery.backgroundColor=UIColor.red
        openGallery.layer.cornerRadius = 10

        letterTitle.placeholder = "제목을 작성해주세요"

        letterContent.delegate = self
        letterContent.text = "어떤 말을 전하고 싶나요?"
        letterContent.textColor = UIColor.lightGray

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        writingDate.text = dateFormatter.string(from: date)
        }
}

extension ViewController :  UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "일반 TextView 입니다."
            textView.textColor = UIColor.lightGray
        }
    }
}
