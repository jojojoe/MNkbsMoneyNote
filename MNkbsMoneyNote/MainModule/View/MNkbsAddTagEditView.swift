//
//  MNkbsAddTagEditView.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/7/12.
//

import UIKit

class MNkbsAddTagEditView: UIView {

    var collection: UICollectionView!
    var bgBtnClickBlock: (()->Void)?
    var saveTagDoneBtnClickBlock: ((_ tagName: String, _ colorStr: String)->Void)?
    let bgColorView = UIView()
    let tagNameLabel = UILabel()

    var currentBgColorStr: String = "#000000"
    let contentBgView = UIView()
    let topLayoutLine1 = UIView()
    let topLayoutLine2 = UIView()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registKeyboradNotification()
        setupView()
    }
    
    func registKeyboradNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        let top = topLayoutLine1.frame.minY
        
        let bottom = topLayoutLine2.frame.maxY
        let safeHeight = bottom - top
        let topHeight = safeHeight - keyboardHeight
        
        let topContentBg = (topHeight) / 2
        contentBgView.snp.remakeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topContentBg - 80)
        }
        
        
        print(keyboardHeight)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(keyboardHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MNkbsAddTagEditView {
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let bgBtn = UIButton(type: .custom)
        addSubview(bgBtn)
        bgBtn.addTarget(self, action: #selector(bgBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        
        contentBgView.backgroundColor = UIColor.white
        addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(90)
        }
        contentBgView.layer.cornerRadius = 20
        //

        bgColorView.backgroundColor = UIColor(hexString: currentBgColorStr)
        contentBgView.addSubview(bgColorView)
        bgColorView.snp.makeConstraints {
            $0.width.height.equalTo(normalCellWidth() + 20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(25)
        }
        bgColorView.layer.cornerRadius = (normalCellWidth() + 20) / 2
        //
        
        tagNameLabel.numberOfLines = 2
        tagNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tagNameLabel.text = "Tag..."
        tagNameLabel.minimumScaleFactor = 0.8
        tagNameLabel.textAlignment = .center
        tagNameLabel.textColor = UIColor.white
        tagNameLabel.adjustsFontSizeToFitWidth = true
        bgColorView.addSubview(tagNameLabel)
        tagNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalTo(12)
        }
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        contentBgView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(contentBgView.snp.centerY).offset(5)
            
        }
        collection.register(cellWithClass: MNkbsAddTagEditViewCell.self)
        //

        topLayoutLine1.backgroundColor = .clear
        addSubview(topLayoutLine1)
        topLayoutLine1.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(1)
        }
        //
        
        topLayoutLine2.backgroundColor = .clear
        addSubview(topLayoutLine2)
        topLayoutLine2.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(1)
        }
        
    }
    
    func padding() -> CGFloat {
        let padding: CGFloat = 16
        return padding
    }
    
    func normalCellWidth() -> CGFloat {
        let numberWidth: CGFloat = (UIScreen.main.bounds.width - (padding() * 6)) / 5
        return numberWidth
    }
    
    @objc func bgBtnClick(sender: UIButton) {
        
        bgBtnClickBlock?()
    }
    
//    @objc func hideButtonClick(button: UIButton) {
//        self.contentTextFeid.resignFirstResponder()
//        saveTagItem()
//    }
    
    func selectBgColor(indexPath: IndexPath) {
        let colorStr = MNkbsBgColorManager.default.colorList[indexPath.item]
        currentBgColorStr = colorStr
        bgColorView.backgroundColor = UIColor(hexString: colorStr)
    }
    
    func updateContentTagLabel(tagStr: String?) {
        tagNameLabel.text = tagStr
    }
    
//    func saveTagItem() {
//        
//        if let tagName = tagNameLabel.text, tagNameLabel.text != "" {
//            saveTagDoneBtnClickBlock?(tagName, currentBgColorStr)
//        } else {
//            bgBtnClickBlock?()
//        }
//         
//        
//    }
}

extension MNkbsAddTagEditView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsAddTagEditViewCell.self, for: indexPath)
        let colorStr = MNkbsBgColorManager.default.colorList[indexPath.item]
        cell.contentImgV.backgroundColor = UIColor(hexString: colorStr)
        cell.contentImgV.layer.cornerRadius = cell.bounds.size.width / 2
        if colorStr.contains("FFFFFF") {
            cell.contentImgV.layer.borderWidth = 1
            cell.contentImgV.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        } else {
            cell.contentImgV.layer.borderWidth = 0
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return MNkbsBgColorManager.default.colorList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsAddTagEditView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: normalCellWidth(), height: normalCellWidth())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension MNkbsAddTagEditView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectBgColor(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    
}



 

class MNkbsAddTagEditViewCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}

