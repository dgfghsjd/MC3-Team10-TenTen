//
//  MainViewController.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/19.
//

import UIKit

class MainViewController: UIViewController {
    var numberOfLetters: Int = 0
    var pickedFlowerIndex: Int?
    var didFlowerToday: Bool = false

    @IBOutlet weak var flowerBoxView: FlowerBoxView!
    @IBOutlet weak var letterBoxView: LetterBoxView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!

    @IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        quoteLabel.text = quotes[Int.random(in: 0...4)]
        
        [guideLabel, quoteLabel].forEach {
            $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        }
    }

    // 네비바 감추고 보이기 레퍼런스: https://stackoverflow.com/a/29953818/6183323
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // random: testing
        flowerBoxView.updatePreview(flowerIndex: Int.random(in: 0...4), didFlowerToday: didFlowerToday)
        letterBoxView.updatePreview(numberOfLetter: Int.random(in: 0...100))
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

#if DEBUG
// mockupdata

struct Flower {
    let title: String
    let image: UIImage
    let floriography: String
}
let flowers = [
    Flower(title: "꽃1", image: UIImage(systemName: "sun.min")!, floriography: "꽃말1, 꽃말"),
    Flower(title: "꽃2", image: UIImage(systemName: "sun.dust")!, floriography: "꽃말2, 꽃말"),
    Flower(title: "꽃3", image: UIImage(systemName: "sun.haze")!, floriography: "꽃말3, 꽃말"),
    Flower(title: "꽃4", image: UIImage(systemName: "sun.min.fill")!, floriography: "꽃말4, 꽃말"),
    Flower(title: "꽃5", image: UIImage(systemName: "sun.dust.fill")!, floriography: "꽃말5, 꽃말")
]
let quotes: [String] = [
    "상처를 치료해줄 사람 어디 없나.\n가만히 놔두다간 끊임없이 덧나.",
    "위로1",
    "위로2",
    "투두1",
    "오늘 하늘은 어떤 모양인가요?\n잠시 걸으며 공기의 냄새를 맡아보아요."
]

#endif
