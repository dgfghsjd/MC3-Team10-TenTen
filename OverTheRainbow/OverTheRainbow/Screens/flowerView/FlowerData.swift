//
//  interest.swift
//  CarouselView
//
//  Created by 진영재 on 2022/07/19.
//

import UIKit

class  FlowerData {
    var label = "꽃"
    var means = " "
    var flowerImage: UIImage


    init(label: String, means: String, flowerImage: UIImage) {
        self.label = label
        self.flowerImage = flowerImage
        self.means = means
    }
    static func fetchFlower() -> [FlowerData] {
        return[
            FlowerData(label: "장미", means: "그리움", flowerImage: UIImage(named: "flower1")!),
            FlowerData(label: "산수유", means: "첫사랑", flowerImage: UIImage(named: "flower2")! ),
            FlowerData(label: "무궁화", means: "추억", flowerImage: UIImage(named: "flower3")! ),
            FlowerData(label: "연꽃", means: "행복", flowerImage: UIImage(named: "flower4")! ),
            FlowerData(label: "무궁화", means: "추억", flowerImage: UIImage(named: "flower3")!)
        ]
    }
}
