//
//  SettingViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/27.
//
// swiftlint:disable force_cast

import UIKit

enum UpdateMode: String {
    case add = "ADD"
    case update = "UPDATE"
}

class PetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    private let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    private var currentPetID = UserDefaults.standard.string(forKey: "petID")
    var pets = [PetResultDto]()
    var mode: UpdateMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: pets에 현재 UserDefaults 펫을 먼저 넣고 나머지 펫들을 append시키기
        updatePetList()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let updateButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showActionSheet))
        updateButton.tintColor = UIColor(named: "textColor")
        navItem.rightBarButtonItem = updateButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentPetID == nil {
            mode = .add
            self.performSegue(withIdentifier: "UpdatePetView", sender: self)
        }
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: "펫 설정하기", message: "", preferredStyle: .actionSheet)
        let addPet = UIAlertAction(title: "펫 추가하기", style: .default) { action in
            self.mode = .add
            self.performSegue(withIdentifier: "UpdatePetView", sender: self)
        }
        let updatePet = UIAlertAction(title: "현재 펫 수정하기", style: .default) { action in
            if self.currentPetID == nil {
                let alert = UIAlertController(title: "알림", message: "현재 펫이 없습니다.", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default)
                alert.addAction(confirm)
                self.present(alert, animated: true)
            } else {
                self.mode = .update
                self.performSegue(withIdentifier: "UpdatePetView", sender: self)
            }
        }
        let deletePet = UIAlertAction(title: "현재 펫 삭제하기", style: .default) { action in
            // TODO: UserDefaults에 있는 현재 Pet 삭제 후 그 다음 Pet을 UserDefaults로?
            do {
                if let removePetID = self.currentPetID {
                    if self.pets.count > 1 {
                        let nextPetID = self.pets[1].id
                        self.currentPetID = nextPetID
                        UserDefaults.standard.set(self.currentPetID, forKey: "petID")
                    } else {
                        self.currentPetID = nil
                        UserDefaults.standard.removeObject(forKey: "petID")
                    }
                    try self.service.deletePet(removePetID)
                } else {
                    let alert = UIAlertController(title: "알림", message: "현재 펫이 없습니다.", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            } catch {
                print("Error deleting pet : \(error)")
            }
            self.updatePetList()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
        }
        
        actionSheet.addAction(addPet)
        actionSheet.addAction(updatePet)
        actionSheet.addAction(deletePet)
        actionSheet.addAction(cancelAction)
        actionSheet.view.tintColor = UIColor(named: "textColor")
        
        present(actionSheet, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? UpdatePetViewController else {
            return
        }
        // TODO: UserDefaults에서 펫 ID 가져오기
        do {
            if mode == .add {
                destinationVC.currentPet = nil
            } else {
                destinationVC.currentPet = try service.findPet(id: UserDefaults.standard.string(forKey: "petID") ?? "")
            }
        } catch {
            print("Error finding pet : \(error)")
        }
        destinationVC.parentVC = self
    }
    
    func updatePetList() {
        currentPetID = UserDefaults.standard.string(forKey: "petID")
        pets = [PetResultDto]()
        
        if let currentPetID = self.currentPetID {
            do {
                try pets.append(service.findPet(id: currentPetID))
            } catch {
                print("Error finding pet : \(error)")
            }
        }
        let otherPets = service.findAllPet().filter {
            $0.id != currentPetID
        }
        for pet in otherPets {
            pets.append(pet)
        }
        collectionView.reloadData()
    }
    
    func updateCurrentPet(newPetID: String) {
        UserDefaults.standard.set(newPetID, forKey: "petID")
        currentPetID = newPetID
        
        updatePetList()
    }
}

// MARK: - DataSource, Delegate of CollectionView
extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as? PetCollectionViewCell else {
            return UICollectionViewCell()
        }
        let pet = pets[indexPath.row]
        
        if pet.id == UserDefaults.standard.string(forKey: "petID") {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "checkmark.circle")
            let fullString = NSMutableAttributedString(string: "\(pet.name) ")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            cell.nameLabel.attributedText = fullString
        } else {
            cell.nameLabel.text = pet.name
        }
        cell.weightLabel.text = String(pet.weight)
        cell.ageLabel.text = String(pet.age)
        cell.speciesLabel.text = pet.species
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPetID = pets[indexPath.row].id
        updateCurrentPet(newPetID: selectedPetID)
    }
}

// MARK: - Layout of CollectionView
extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 260
        
        return CGSize(width: width, height: height)
    }
}
