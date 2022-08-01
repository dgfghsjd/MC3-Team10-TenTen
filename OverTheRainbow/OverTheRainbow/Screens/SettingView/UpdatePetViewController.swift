//
//  UpdatePetViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/27.
//

import UIKit

class UpdatePetViewController: UIViewController {
    
    private let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    var currentPet: PetResultDto?
    var parentVC: UIViewController?
    private var selectedDate = Date()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBAction func datePicked(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }

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
            if let name = nameTextField.text, let species = speciesTextField.text, let weight = weightTextField.text {
                let newPetID = service.addPet(PetInputDto(name, species, selectedDate, Double(weight)!))
                UserDefaults.standard.set(newPetID, forKey: "petID")
            }
        } else {
            // update mode
            // TODO: Realm update pet 추가
            if let name = nameTextField.text, let species = speciesTextField.text, let weight = weightTextField.text {
                let updatedPet = PetUpdateDto(id: currentPet!.id, name: name, species: species, birth: selectedDate, weight: Double(weight)!)
                do {
                    try service.updatePet(updatedPet)
                } catch {
                    print("Error updating pet : \(error)")
                }
            }
        }
        self.dismiss(animated: true) {
            guard let vc = self.parentVC as? SettingViewController else { return }
            vc.updatePetList()
        }
    }
}
