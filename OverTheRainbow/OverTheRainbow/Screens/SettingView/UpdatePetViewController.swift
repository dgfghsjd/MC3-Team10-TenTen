//
//  UpdatePetViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/27.
//

import UIKit

//enum UpdateMode: String {
//    case update = "UPDATE"
//    case add = "ADD"
//}

class UpdatePetViewController: UIViewController {

    var currentPet: PetResultDto?
    var parentVC: UIViewController?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    private let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirmBtnPressed))
        cancelButton.tintColor = UIColor(named: "textColor")
        confirmButton.tintColor = UIColor(named: "textColor")

        navigationBar.topItem?.leftBarButtonItem = cancelButton
        navigationBar.topItem?.rightBarButtonItem = confirmButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentPet = currentPet {
            nameTextField.placeholder = currentPet.name
            speciesTextField.placeholder = currentPet.species
            ageTextField.placeholder = String(currentPet.age)
            weightTextField.placeholder = String(currentPet.weight)
        }
    }

    @objc func cancelBtnPressed() {
        self.dismiss(animated: true)
    }

    @objc func confirmBtnPressed() {
        // TODO: Pet Model 업데이트
        
        if currentPet == nil {
            // add mode
            if let name = nameTextField.text, let species = speciesTextField.text, let age = ageTextField.text, let weight = weightTextField.text {
                service.addPet(PetInputDto(name, species, Date(), Double(weight)!))
            }
        } else {
            // update mode
        }

        if let name = nameTextField.text, let species = speciesTextField.text, let birth = ageTextField.text, let weight = weightTextField.text {
//            let myPet = Pet(name: name, species: species, birth: birth, weight: weight)
        }
        self.dismiss(animated: true) {
            print("dismiss")
            guard let vc = self.parentVC as? SettingViewController else { return }
            vc.updatePetList()
        }
    }
}
