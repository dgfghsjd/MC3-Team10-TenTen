//
//  WrittenLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit

class WrittenLetterViewController: UIViewController {
    @IBOutlet weak var selectedLetterNavBar: UINavigationItem!
    @IBOutlet weak var selectedLetterImage: UIImageView!
    @IBOutlet weak var selectedLetterTitle: UILabel!
    
    @IBOutlet weak var selectedLetterContent: UITextView!
    
    @IBOutlet weak var selectedLetterDate: UILabel!
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLetterNavBar.title="편지 상세"
    }

}
