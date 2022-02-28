//
//  MNkbsInsightGouChengView.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/5/15.
//

import UIKit

class MNkbsInsightGouChengView: UIView {

    var collection: UICollectionView!
    var moreBtnClickBlock: (([MNkbsInsightItem])->Void)?
    var insightGouchengList: [MNkbsInsightItem] = []
    var insightGouchengList_Total: [MNkbsInsightItem] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MNkbsInsightGouChengView {
    func fetchGouChengData(beginTime: Date, endTime: Date) {
        /*
         
         MNkbsInsightManager.default.fetchGouCheng(beginTime: beginTime, endTime: endTime) { insightGouchengList in
             debugPrint("insightGouchengList = \(insightGouchengList)")
             DispatchQueue.main.async {
                 [weak self] in
                 guard let `self` = self else {return}
                 let item = insightGouchengList.prefix(5)
                 self.insightGouchengList = Array(item)
                 self.insightGouchengList_Total = insightGouchengList
                 self.collection.reloadData()
             }
         }
         
         */
        
        let test1 = MNkbsInsightItem(tagName: "Tag1", percentLine: 0.8, priceDouble: 111)
        let test2 = MNkbsInsightItem(tagName: "Tag2", percentLine: 0.6, priceDouble: 222)
        let test3 = MNkbsInsightItem(tagName: "Tag3", percentLine: 0.5, priceDouble: 333)
        let test4 = MNkbsInsightItem(tagName: "Tag4", percentLine: 0.3, priceDouble: 444)
        let test5 = MNkbsInsightItem(tagName: "Tag5", percentLine: 0.1, priceDouble: 555)
        let testList = [test1, test2, test3, test4, test5]
        
        
        self.insightGouchengList = testList
        self.insightGouchengList_Total = testList
        self.collection.reloadData()
    }
    
    
    
    
    
}

extension MNkbsInsightGouChengView {
    
     
    func setupView() {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        nameLabel.text = "构成"
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .left
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(10)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
        //
        let moreBtn = UIButton(type: .custom)
        moreBtn.setTitle("More", for: .normal)
        moreBtn.setTitleColor(.black, for: .normal)
        moreBtn.backgroundColor = .white
        moreBtn.layer.cornerRadius = 8
        addSubview(moreBtn)
        moreBtn.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalTo(nameLabel)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
        moreBtn.addTarget(self, action: #selector(moreBtnClick(sender:)), for: .touchUpInside)
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(moreBtn.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        collection.register(cellWithClass: MNkbsInsightGouChengViewCell.self)
    }
    
    
}

extension MNkbsInsightGouChengView {
    @objc func moreBtnClick(sender: UIButton) {
        moreBtnClickBlock?(insightGouchengList_Total)
    }
    
}

extension MNkbsInsightGouChengView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInsightGouChengViewCell.self, for: indexPath)
        let item = insightGouchengList[indexPath.item]
        cell.tagNameLabel.text = item.tagName
        
        let symbol = MNkbsSettingManager.default.currentCurrencySymbol()
        cell.priceLabel.text = "\(symbol.rawValue)\(item.priceDouble)"
        
        var priceStr = "\(item.priceDouble)"
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
        
        
        let percentWidth: CGFloat = cell.contentView.bounds.size.width * CGFloat(item.percentLine)
        cell.percentLineView.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(cell.tagNameLabel.snp.left)
            $0.height.equalTo(30)
            $0.width.equalTo(percentWidth)
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insightGouchengList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsInsightGouChengView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.size.width
        let h: CGFloat = 40
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension MNkbsInsightGouChengView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class MNkbsInsightGouChengViewCell: UICollectionViewCell {
    let tagNameLabel = UILabel()
    let percentLineView = UIView()
    let priceLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        percentLineView.backgroundColor = UIColor.orange
        contentView.addSubview(percentLineView)
        //
        tagNameLabel.font = UIFont(name: "Avenir-Black", size: 16)
        tagNameLabel.textColor = UIColor(hexString: "#FFFFFF")
        contentView.addSubview(tagNameLabel)
        //
        
        percentLineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(tagNameLabel.snp.left)
            $0.height.equalTo(30)
            $0.width.equalTo(100)
        }
        //
        
        tagNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(12)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        priceLabel.font = UIFont(name: "Avenir-Black", size: 16)
        priceLabel.textColor = UIColor(hexString: "#FFFFFF")
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-12)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
    }
    
    
    
}
