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
    var letterID: String! = ""
    
    var childVC: UIViewController?
    var letterHasChanged: Bool?
    
    override func viewDidLoad() {
        let letter = try! service.findLetter(letterID)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "textColor")
        super.viewDidLoad()
        selectedLetterNavBar.title="편지 상세"
        selectedLetterTitle.text = letter.title
        selectedLetterContent.text = letter.content
        selectedLetterImage.layer.cornerRadius = 10
        selectedLetterImage.contentMode = .scaleAspectFill
        load(url: letter.imgUrl!)
        selectedLetterDate.text = letter.date
        print(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if letterHasChanged == true {
            print(self.letterHasChanged)
        }
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.selectedLetterImage.image = image
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
            if let viewController = navigationController.viewControllers.first as? EditingLetterViewController {
                viewController.letterID = self.letterID
                viewController.parentVC = self
                try! service.unsaveLetters(letterID)
            }
        }
    }
}
