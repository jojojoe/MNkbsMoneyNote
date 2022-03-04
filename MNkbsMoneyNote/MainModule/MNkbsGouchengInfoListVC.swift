//
//  MNkbsGouchengInfoListVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2022/3/4.
//

import UIKit

class MNkbsGouchengInfoListVC: UIViewController {
    var gouchengItem: MNkbsInsightItem
    var beginTime: Date
    var endTime: Date
    var collection: UICollectionView!
    
    var gouchengPaihangList: [MoneyNoteModel] = []
    
    init(gouchengItem: MNkbsInsightItem, beginTime: Date, endTime: Date) {
        self.gouchengItem = gouchengItem
        self.beginTime = beginTime
        self.endTime = endTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#202020")
        loadData()
        setupView()
    }

    

}

extension MNkbsGouchengInfoListVC {
    
    func loadData() {
        MNkbsInsightManager.default.fetchGouChengPaihangInfoNote(tagName: gouchengItem.tagName, beginTime: beginTime, endTime: endTime) {[weak self] noteList in
            guard let `self` = self else {return}
            
            DispatchQueue.main.async {
                self.gouchengPaihangList = noteList
                self.collection.reloadData()
            }
        }
    }
    
    func setupView() {
        let backBtn = UIButton()
        backBtn.adhere(toSuperview: view)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(6)
            $0.width.height.equalTo(44)
        }
        //
        let topTitleLabel = UILabel()
        topTitleLabel.adhere(toSuperview: view)
            .text(gouchengItem.tagName)
            .fontName(16, "AvenirNext-DemiBold")
            .color(UIColor.white)
            
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let symbol = MNkbsSettingManager.default.currentCurrencySymbol()
        
        
        var priceStr = "\(gouchengItem.priceDouble)"
        if priceStr.contains(".") {
            let strings = priceStr.components(separatedBy: ".")
            let lastStr = strings.last
            if let lastStrInt = lastStr?.int, lastStrInt > 0 {
                //带有小数
            } else {
                priceStr = strings.first ?? priceStr
            }
        }
        let priceSymbolStr: String = "\(symbol.rawValue)\(priceStr)"
        //
        let topPriceLabel = UILabel()
        topPriceLabel.adhere(toSuperview: view)
            .text(priceSymbolStr)
            .fontName(16, "AvenirNext-DemiBold")
            .color(UIColor.white)
        topPriceLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        collection.register(cellWithClass: MNkbsInsightPaiHangViewCell.self)
        
        
    }
 
}


extension MNkbsGouchengInfoListVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


extension MNkbsGouchengInfoListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInsightPaiHangViewCell.self, for: indexPath)
        let item = gouchengPaihangList[indexPath.item]
        
        let dateString = MNkbsInsightManager.default.processMoneyNoteItemRecordTimeToString(noteItemRecordDate: item.recordDate)
        cell.recordTimeLabel.text = dateString
        //
        cell.updateTagsList(tagList: item.tagModelList)
        //
        let symbol = MNkbsSettingManager.default.currentCurrencySymbol()
        cell.priceLabel.text = "\(symbol.rawValue)\(item.priceStr)"
        
        var priceStr = "\(item.priceStr)"
        if priceStr.contains(".") {
            let strings = priceStr.components(separatedBy: ".")
            let lastStr = strings.last
            if let lastStrInt = lastStr?.int, lastStrInt > 0 {
                //带有小数
            } else {
                priceStr = strings.first ?? priceStr
            }
            cell.priceLabel.text = "\(symbol.rawValue)\(priceStr)"
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gouchengPaihangList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsGouchengInfoListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.size.width
        let h: CGFloat = 62
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
}

extension MNkbsGouchengInfoListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}






