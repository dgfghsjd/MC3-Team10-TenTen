//
//  WritingButton.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/28.
//

import UIKit

final class WritingButton: UIButton {
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.setImage(ImageLiterals.btnWriting, for: .normal)
        self.tintColor = UIColor(named: "textColor")
    }
}
