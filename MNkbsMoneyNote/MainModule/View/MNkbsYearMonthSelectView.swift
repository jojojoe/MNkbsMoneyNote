//
//  MNkbsYearMonthSelectView.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2022/2/28.
//

import UIKit

class MNkbsYearMonthSelectView: UIView {
    var backBtnClickBlock: (()->Void)?
    var selectClickBlock: ((String, String?)->Void)?
    var recordsList: [[String : Any]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        loadData()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    func loadData() {
        let recordsList =  MNkbsInsightManager.default.loadAllRecordYearsMonths()
        self.recordsList = recordsList
    }
    
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        let contentV = UIView()
        contentV
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: self)
        contentV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-470)
        }
        //
        var collection: UICollectionView!
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        contentV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.bottom.right.left.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        collection.register(cellWithClass: MNkbsMonthCell.self)
        collection.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: MNkbsYearHearder.self)
        
    }
    
    
     
}
     
  


extension MNkbsYearMonthSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsMonthCell.self, for: indexPath)
        
        let bundle = recordsList[indexPath.section]
        let months = bundle["month"] as? [String] ?? []
        let month = months[indexPath.item]
        cell.contentLab.text(month)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let boundle = recordsList[section]
        let months = boundle["month"] as? [String] ?? []
        return months.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recordsList.count
    }
    
}

extension MNkbsYearMonthSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 15
        let width: CGFloat = (collectionView.width - padding * 5 - 1) / 4
        let height: CGFloat = 44
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 15
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 15
        return padding
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 15
        return padding
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let padding: CGFloat = 15
        return CGSize(width: UIScreen.width, height: 44)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: MNkbsYearHearder.self, for: indexPath)
            
            let bundle = recordsList[indexPath.section]
            let year = bundle["year"] as? String
            view.contentLab.text(year)
            view.yearStr = year ?? ""
            view.clickBlock = {
                [weak self] theYear in
                guard let `self` = self else {return}
                self.selectClickBlock?(theYear, nil)
            }
            
            return view
        }
        return UICollectionReusableView()
    }
    
    
}

extension MNkbsYearMonthSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bundle = recordsList[indexPath.section]
        let year = bundle["year"] as? String ?? ""
        let months = bundle["month"] as? [String] ?? []
        let monthStr = months[indexPath.item]
        selectClickBlock?(year, monthStr)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}


class MNkbsMonthCell: UICollectionViewCell {
    let contentLab = UILabel()
    var monthStr: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        contentView.backgroundColor(.lightGray)
        
        //
        contentLab
            .adhere(toSuperview: contentView)
            .fontName(15, FONT_AvenirHeavy)
            .textAlignment(.center)
            .color(.black)
        contentLab.adjustsFontSizeToFitWidth = true
        contentLab.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalToSuperview()
        }
        //
        
        
    }
}

class MNkbsYearHearder: UICollectionReusableView {
    
    var yearStr: String = ""
    let contentLab = UILabel()
    let btn = UIButton()
    var clickBlock: ((String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        //self.backgroundColor(.darkGray)
        
        //
        contentLab
            .backgroundColor(.lightGray)
            .adhere(toSuperview: self)
            .fontName(15, FONT_AvenirHeavy)
            .textAlignment(.center)
            .color(.black)
        contentLab.adjustsFontSizeToFitWidth = true
        contentLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.greaterThanOrEqualTo(100)
        }
        
        //
        btn.adhere(toSuperview: self)
        btn.addTarget(self, action: #selector(btnClick(sender: )), for: .touchUpInside)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
    }
    
    @objc func btnClick(sender: UIButton) {
        clickBlock?(yearStr)
    }
    
}



