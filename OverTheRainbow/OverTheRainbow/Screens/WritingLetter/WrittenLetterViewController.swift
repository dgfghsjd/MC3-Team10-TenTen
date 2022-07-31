//
//  WrittenLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//
//swiftlint:disable force_try
import UIKit

class WrittenLetterViewController: UIViewController {
    @IBOutlet weak var selectedLetterNavBar: UINavigationItem!
    @IBOutlet weak var selectedLetterImage: UIImageView!
    @IBOutlet weak var selectedLetterTitle: UILabel!
    
    @IBOutlet weak var selectedLetterContent: UITextView!
    
    @IBOutlet weak var selectedLetterDate: UILabel!
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()

    
    
    override func viewDidLoad() {
        let letter = try! service.findLetter("62e60b0440a87a9ab0637613")
        
        super.viewDidLoad()
        selectedLetterNavBar.title="편지 상세"
        selectedLetterTitle.text = letter.title
        selectedLetterContent.text = letter.content
        selectedLetterDate.text = letter.date
    }

}
