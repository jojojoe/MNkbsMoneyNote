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
    var collection: UICollectionView!
    var currentYearStr: String = ""
    var currentMonthStr: String = ""
    
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
        MNkbsInsightManager.default.loadAllRecordYearsMonths(completion: {
            [weak self] recordss in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.recordsList = recordss
                self.collection.reloadData()
            }
        })
        
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
        let year = bundle["year"] as? String ?? ""
        let months = bundle["month"] as? [String] ?? []
        let month = months[indexPath.item]
        
        let mS = monthDisplayName(monthIndexStr: month)
        cell.contentLab.text(mS)
        
        cell.selectBgV.isHidden = true
        if year == currentYearStr {
            if month == currentMonthStr {
                cell.selectBgV.isHidden = false
            }
        }
        
        return cell
    }
    
    func monthDisplayName(monthIndexStr: String) -> String {
        var monthS: String = ""
        let isC = isChZhong()
        
        if monthIndexStr == "0" {
            monthS = isC ? "一月" : "Jan."
        } else if monthIndexStr == "1" {
            monthS = isC ? "二月" : "Feb."
        } else if monthIndexStr == "2" {
            monthS = isC ? "三月" : "Mar."
        } else if monthIndexStr == "3" {
            monthS = isC ? "四月" : "Apr."
        } else if monthIndexStr == "4" {
            monthS = isC ? "五月" : "May."
        } else if monthIndexStr == "5" {
            monthS = isC ? "六月" : "Jun."
        } else if monthIndexStr == "6" {
            monthS = isC ? "七月" : "Jul."
        } else if monthIndexStr == "7" {
            monthS = isC ? "八月" : "Aug."
        } else if monthIndexStr == "8" {
            monthS = isC ? "九月" : "Sept."
        } else if monthIndexStr == "9" {
            monthS = isC ? "十月" : "Oct."
        } else if monthIndexStr == "10" {
            monthS = isC ? "十一月" : "Nov."
        } else if monthIndexStr == "11" {
            monthS = isC ? "十二月" : "Dec."
        }
        return monthS
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
//        let padding: CGFloat = 15
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
                self.currentYearStr = year ?? ""
                self.currentMonthStr = ""
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            }
            if year == currentYearStr {
                if currentMonthStr == "" {
                    view.selectBgV.isHidden = false
                } else {
                    view.selectBgV.isHidden = true
                }
            } else {
                view.selectBgV.isHidden = true
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
        currentYearStr = year
        currentMonthStr = monthStr
        self.collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}


class MNkbsMonthCell: UICollectionViewCell {
    let contentLab = UILabel()
    var selectBgV: UIView = UIView()
    
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
        selectBgV.adhere(toSuperview: contentView)
            .backgroundColor(UIColor.orange)
        selectBgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        selectBgV.isHidden = true
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
    let contentBgV = UIView()
    let selectBgV = UIView()
    
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
        
        
        contentBgV.adhere(toSuperview: self)
            .backgroundColor(.lightGray)
        contentBgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(100)
        }
        //
        selectBgV.adhere(toSuperview: contentBgV)
            .backgroundColor(UIColor.orange)
        selectBgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        selectBgV.isHidden = true
        //
        contentLab
            .adhere(toSuperview: contentBgV)
            .fontName(15, FONT_AvenirHeavy)
            .textAlignment(.center)
            .color(.black)
        contentLab.adjustsFontSizeToFitWidth = true
        contentLab.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        btn.adhere(toSuperview: contentBgV)
        btn.addTarget(self, action: #selector(btnClick(sender: )), for: .touchUpInside)
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
    }
    
    @objc func btnClick(sender: UIButton) {
        clickBlock?(yearStr)
    }
    
}



