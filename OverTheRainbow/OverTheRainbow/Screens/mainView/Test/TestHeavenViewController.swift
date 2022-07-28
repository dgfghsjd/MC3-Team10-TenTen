//
//  TestLetterViewController.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/25.
//

import UIKit
// 애니메이션 테스트에 필요. 타 뷰 연결 후 삭제 예정.
class TestHeavenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
class TestSettingViewController: UIViewController {
    let service = DataAccessProvider.dataAccessConfig.getService()
    
    @IBAction func petRegister(_ sender: UIButton) {
        service.addPet(PetInputDto("이름", "종", Date(), 10.0))
        UserDefaults.standard.set(service.findAllPet().first?.id, forKey: "petID")
        UserDefaults.standard.synchronize()
    }
    @IBAction func petDelete(_ sender: UIButton) {
        // userdefault에서만 지움 
        // service.cleanRealm() // 꽃까지 날아감
        UserDefaults.standard.removeObject(forKey: "petID")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
class TestFlowerViewController: UIViewController {
    let service = DataAccessProvider.dataAccessConfig.getService()

    // 각자의 렘스튜디오에서 꽃 추가하고, flowerID를 아래에 써줘야 작동함
    @IBAction func selectFlower(_ sender: UIButton) {
        try? service.chooseFlower(petId: UserDefaults.standard.string(forKey: "petID") ?? "없음", flowerId: "62e0dfe1088386eabe3d56c8")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
