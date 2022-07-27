// collectionView 안에 들어갈 인자를 넣는 뷰
// 데이터를 받아오는 뷰
import UIKit

class FlowerViewController: UIViewController {
    @IBOutlet weak var takeFlowerlabel: UIBarButtonItem!
    @IBAction func takeAFlower(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        print(flowerData[roundedIndex].label, flowerData[roundedIndex].means )
        print("\(offsetPoint)뷰가 리로드 될때 x 시작점입니다.")
    }
    @IBOutlet weak var pagerContorl: UIPageControl!
    // 데이터를 인스턴스로 받아온다.
    @IBOutlet weak var collectionView: UICollectionView!
    var flowerData = FlowerData.fetchFlower()
    var currentIndex: CGFloat = 0.0
    var previousCellIndex = 0
    var nextCellIndex = 0
    var roundedIndex = 1
    var offsetPoint = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 셀의 사이즈 설정
        let cellWidth = floor(210)
        let cellHeight = floor(522)
        let insetX = (view.bounds.width - cellWidth) / 2.0 // 90
        // minimumLineSpacing, itemSize 메소드를 사용하기 위해서 다운캐스팅
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout!.itemSize = CGSize(width: cellWidth, height: cellHeight) // 셀의 사이즈
        layout!.minimumLineSpacing = 37      // 옆셀과의 거리
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 104, right: insetX)
        // 컨텐츠의 여백 길이를 설정함으로 옆의 셀이 얼마나 나올지를 보여준다.
        // 컬렉션 뷰에게 데이터 소스를 제공해 주는 메소드
        // collectiomView의 dataSource는 이 class임을 알려주는
        // 문장이다.
        collectionView.dataSource = self
        collectionView.delegate = self
        pagerContorl.numberOfPages = flowerData.count - 1
        pagerContorl.currentPage = 0
    }
    
    // 컬렉션뷰에 필요한 데이터 및 뷰를 제공하기 위한 기능을 정의한 프로토콜입니다.
    // 기존 객체를 수정하지 않고 프로토콜을 구현하기 위해
    // extension 사용
}


extension FlowerViewController: UICollectionViewDataSource {
    // collrctionView의 색션 갯수를 return
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // 한 색션에 몇가지 아이템이 있는지 return
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flowerData.count
    }
    //셀에 대입되었던 자료들은 for each 처럼 배분해주는 함수? 등록해 놓은 데이터를 재사용하는 방식.
    //등록해두었던 셀을 빼서 쓰는것
    func collectionView
    (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath)
        as? FlowerCollectionViewCell
        let flower = flowerData[indexPath.item]
        cell!.flowers = flower
        return cell!
    }
}
// 델리게이트 사용을 위해서 익스텐션 설정
extension FlowerViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewWillEndDragging
    (_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
     targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout!.itemSize.width + layout!.minimumLineSpacing
        // targetContentOffset
        // 스크롤 동작이 정지할 때 예상되는 오프셋입니다.
        var offset = targetContentOffset.pointee // 움직인 x 좌표값을 받기위해 설정
        let index = (offset.x + scrollView.contentInset.left ) / cellWidthIncludingSpacing
        // 움직인 크기가 cellWidthIncludingSpacing을 넘어가면 index 변경
        if index > currentIndex {
            currentIndex += 1
        } else if index < currentIndex {
            if currentIndex != 0 {
                currentIndex -= 1
            }
        }
        // 얼마나 넘어갈지 알려주는 명령어인데 왜 내가 설정한 만큼만 넘어가지않는건데ㅠㅠㅠ
        offset = CGPoint(x: currentIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0)
        // 스크롤을 햇을때 정지할 offset
        targetContentOffset.pointee = offset
        offsetPoint = targetContentOffset.pointee.x
    }
    // 스크롤이 되었을때 동작하는 함수
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 위에와 같이 하나의 스크린 크기
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let offsetX = collectionView.contentOffset.x
        let index = (offsetX + collectionView.contentInset.left) / cellWidthIncludeSpacing
         roundedIndex = Int(round(index))
        
        print("roundedIndex\(roundedIndex)")
        print("previousCellIndex\(previousCellIndex)")
        print("nextCellIndex\(nextCellIndex)")
        print(offsetPoint)
        //
        //
        pagerContorl.currentPage = roundedIndex
        
        // 줌 하는 현재 셀
                let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) {
            zoomFocusCell(cell: cell, isFocus: true)
        }
        //
        // 줌 아웃되는 이전 셀
        let preIndexPath = IndexPath(item: previousCellIndex, section: 0)
        if let preCell = collectionView.cellForItem(at: preIndexPath) {
            zoomFocusCell(cell: preCell, isFocus: false)
        }
        previousCellIndex = indexPath.item - 1
        //
        // 줌 아웃되는 다음셀
        let nextIndexPath = IndexPath(item: nextCellIndex, section: 0)
        if let nextCell = collectionView.cellForItem(at: nextIndexPath) {
            zoomFocusCell(cell: nextCell, isFocus: false)
        }
        nextCellIndex = indexPath.item + 1
    }
    // 줌하는 커스텀 함수
    private func zoomFocusCell(cell: UICollectionViewCell, isFocus: Bool ) {
        UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            if isFocus {
                cell.transform = .identity
            } else {
                cell.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
        }, completion: nil)
    }
}
