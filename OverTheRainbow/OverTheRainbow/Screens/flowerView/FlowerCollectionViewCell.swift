// collectionView에 들어갈 outlet label을 위한 뷰
import UIKit

class FlowerCollectionViewCell: UICollectionViewCell {
    // CollectionView의 outlet을 만든다.
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var flowerMeans: UILabel!
    @IBOutlet weak var flowerTitleLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UIView!
    @IBOutlet weak var boxLabel: UIView!
    // realm 데이터 연결
    let service = DataAccessProvider.dataAccessConfig.getService()
    var flowerID: String?
    
    var flowers: FlowerResultDto! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let flowers = flowers {
            flowerID = flowers.id
            flowerImageView.image = UIImage(named: flowers.imgUrl)
            flowerTitleLabel.text = flowers.name
            flowerMeans.text = flowers.meaning
        }
                backgroundLabel.layer.cornerRadius = 15.0
               boxLabel.layer.cornerRadius = 15.0
               boxLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
//    var flowers: FlowerData! {
//        didSet {
//            self.updateUI()
//        }
//    }
//    func updateUI() {
//        if let flowers = flowers {
//            flowerImageView.image = flowers.flowerImage
//            flowerTitleLabel.text = flowers.label
//            flowerMeans.text = flowers.means
//        }
//        backgroundLabel.layer.cornerRadius = 15.0
//        boxLabel.layer.cornerRadius = 15.0
//        boxLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//    }


    
}

