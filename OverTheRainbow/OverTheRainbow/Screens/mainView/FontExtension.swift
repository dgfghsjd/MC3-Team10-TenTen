//
//  FontExtension.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/20.
//

import UIKit

// ref: https://stackoverflow.com/a/62687023/6183323
extension UIFont {
    static func preferredFont(forTextStyle: TextStyle, weight: Weight) -> UIFont {
        // Get the style's default pointSize
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: forTextStyle, compatibleWith: traits)

        // Get the font at the default size and preferred weight
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)

        // Setup the font to be auto-scalable
        let metrics = UIFontMetrics(forTextStyle: forTextStyle)
        return metrics.scaledFont(for: font)
    }

    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
