//
//  MNkbsPaihangPreviewVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2022/2/28.
//

import UIKit

class MNkbsPaihangPreviewVC: UIViewController {

    var collection: UICollectionView!
    var paihangList: [MoneyNoteModel]
    init(paihangList: [MoneyNoteModel]) {
        self.paihangList = paihangList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        setupView()
    }
    

    
    
    

}

extension MNkbsPaihangPreviewVC {
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
            .text("构成")
            .color(UIColor.black)
            .fontName(16, "AvenirNext-DemiBold")
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
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


extension MNkbsPaihangPreviewVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}



extension MNkbsPaihangPreviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInsightPaiHangViewCell.self, for: indexPath)
        let item = paihangList[indexPath.item]
        
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
        return paihangList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsPaihangPreviewVC: UICollectionViewDelegateFlowLayout {
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

extension MNkbsPaihangPreviewVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

