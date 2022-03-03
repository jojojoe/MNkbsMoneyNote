//
//  MNkbsInsightPaiHangView.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/6/3.
//

import UIKit
 

class MNkbsInsightPaiHangView: UIView {

    var collection: UICollectionView!
    var moreBtnClickBlock: (([MoneyNoteModel])->Void)?
    var insightPaiHangList: [MoneyNoteModel] = []
    var insightPaiHangList_Total: [MoneyNoteModel] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MNkbsInsightPaiHangView {
    
    func testMoneyNoteList() -> [MoneyNoteModel] {
        let timestamp = CLongLong(round(Date().unixTimestamp*1000)).string
        let tags1 = MNkbsTagItem(bgColor: "#FB7751", tagName: "吃饭", tagIndex: "0")
        let tags2 = MNkbsTagItem(bgColor: "#F07059", tagName: "购物", tagIndex: "1")
        let tags3 = MNkbsTagItem(bgColor: "#206259", tagName: "睡觉", tagIndex: "2")
        let tags1d = tags1.toDict()
        let tags2d = tags2.toDict()
        let tags3d = tags3.toDict()
        let tagList = [tags1, tags2, tags3]
        let tagListd = [tags1d, tags2d, tags3d]
        
        let model1 = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "11", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        let model2 = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "22", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        let model3 = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "33", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        let model4 = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "44", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        let model5 = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "55", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        let model6 = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "66", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        return [model1, model2, model3, model4, model5, model6]
    }
    
    func fetchPaiHangData(beginTime: Date, endTime: Date) {
        DispatchQueue.global().async {
            MNkbsInsightManager.default.fetchPaiHang(beginTime: beginTime, endTime: endTime) { noteList in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    let item = noteList.prefix(4)
                    self.insightPaiHangList = Array(item)
                    self.insightPaiHangList_Total = noteList
                    self.collection.reloadData()
                }
            }
        }
         
         
         
          
        
        /*
        let testList = testMoneyNoteList()
        
        let item = testList.prefix(5)
        self.insightPaiHangList = Array(item)
        self.insightPaiHangList_Total = testList
        self.collection.reloadData()
         */
    }
    
    
    
    
    
}

extension MNkbsInsightPaiHangView {
    
     
    func setupView() {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        nameLabel.text = "排行"
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
        collection.register(cellWithClass: MNkbsInsightPaiHangViewCell.self)
    }
    
    
}

extension MNkbsInsightPaiHangView {
    @objc func moreBtnClick(sender: UIButton) {
        moreBtnClickBlock?(insightPaiHangList_Total)
    }
    
}

extension MNkbsInsightPaiHangView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInsightPaiHangViewCell.self, for: indexPath)
        let item = insightPaiHangList[indexPath.item]
        
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
        return insightPaiHangList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsInsightPaiHangView: UICollectionViewDelegateFlowLayout {
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

extension MNkbsInsightPaiHangView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class MNkbsInsightPaiHangViewCell: UICollectionViewCell {
    
    let priceLabel = UILabel()
    let recordTimeLabel = UILabel()
    var collection: UICollectionView!
    var tagsList: [MNkbsTagItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTagsList(tagList: [MNkbsTagItem]) {
        self.tagsList = tagList
        collection.reloadData()
    }
    
    func setupView() {
        
        //
        recordTimeLabel.font = UIFont(name: "Avenir-Black", size: 15)
        recordTimeLabel.textColor = UIColor(hexString: "#FFFFFF")
        contentView.addSubview(recordTimeLabel)
        recordTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalTo(12)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.setContentHuggingPriority(.defaultLow, for: .horizontal)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(recordTimeLabel.snp.bottom).offset(0)
            $0.left.equalTo(12)
            $0.height.equalTo(44)
            $0.right.equalTo(-100)
        }
        collection.register(cellWithClass: MNkbsInputPreviewTagCell.self)
        
        
        //
        priceLabel.font = UIFont(name: "Avenir-Black", size: 20)
        priceLabel.textColor = UIColor(hexString: "#FFFFFF")
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-12)
            $0.left.greaterThanOrEqualTo(collection.snp.right).offset(10)
            $0.height.greaterThanOrEqualTo(1)
        }
    }
    
    
    
}


extension MNkbsInsightPaiHangViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInputPreviewTagCell.self, for: indexPath)
        let item = tagsList[indexPath.item]
        cell.contentImgV.backgroundColor = UIColor(hexString: item.bgColor)
        cell.tagNameLabel.text = item.tagName
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = false
        cell.deleteBtn.isHidden = true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsInsightPaiHangViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tag = tagsList[indexPath.item]
        
        let attri = NSAttributedString(string: tag.tagName, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12)])
        let size = attri.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil).size
        let cellWidth: CGFloat = size.width + 34
        
        return CGSize(width: cellWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
 
extension MNkbsInsightPaiHangViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

