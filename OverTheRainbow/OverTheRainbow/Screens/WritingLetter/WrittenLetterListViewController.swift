//
//  WrittenLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit

class WrittenLetterListViewController: UIViewController {

    @IBOutlet weak var listNavBar: UINavigationItem!
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()

    override func viewDidLoad() {
        super.viewDidLoad()
        listNavBar.title = "리스트"
        // Do any additional setup after loading the view.
    }
    @IBAction func callLetter(_ sender: UIButton) {
        
    }
    
}
