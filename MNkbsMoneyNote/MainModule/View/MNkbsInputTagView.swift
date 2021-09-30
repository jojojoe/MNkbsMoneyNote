//
//  MNkbsInputTagView.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/13.
//

import UIKit

class MNkbsInputTagView: UIView {

    var collection: UICollectionView!
    var tagList: [MNkbsTagItem] =  []
    var currentSelectTagList: [MNkbsTagItem] =  []
    var selectTagBlock: (([MNkbsTagItem])->Void)?
    var editTagBtnClickBlock: (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        
        
        MNDBManager.default.selectTagList { tagList in
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.tagList = tagList
                self.collection.reloadData()
            }
        }
        
        
    }

}

extension MNkbsInputTagView {
    func clearCurrentSelectTagList() {
        currentSelectTagList = []
        collection.reloadData()
        
    }
    
    func udpateCurrentSelectTagList(tagList: [MNkbsTagItem]) {
        currentSelectTagList = tagList
        collection.reloadData()
    }
}

extension MNkbsInputTagView {
    func setupView() {
        //
        
        //
        let tagEditBtn = UIButton(type: .custom)
        addSubview(tagEditBtn)
        tagEditBtn.setTitle("Edit Tag", for: .normal)
        tagEditBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        tagEditBtn.setTitleColor(.black, for: .normal)
        tagEditBtn.backgroundColor = UIColor.white
        tagEditBtn.layer.cornerRadius = 8
        tagEditBtn.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.right.equalTo(-10)
            $0.height.equalTo(36)
            $0.width.equalTo(100)
        }
        tagEditBtn.addTarget(self, action: #selector(tagEditBtnClick(sender:)), for: .touchUpInside)
        //
        let nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.text = "选择标签:"
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalTo(tagEditBtn)
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
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(40)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: MNkbsInputTagCell.self)
    }
    
    func padding() -> CGFloat {
        let padding: CGFloat = 16
        return padding
    }
    
    func normalCellWidth() -> CGFloat {
        let numberWidth: CGFloat = (UIScreen.main.bounds.width - (padding() * 6)) / 5
        return numberWidth
    }
    
    
    @objc func tagEditBtnClick(sender: UIButton) {
        editTagBtnClickBlock?()
    }
    
    
}

extension MNkbsInputTagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInputTagCell.self, for: indexPath)
        cell.selectView.isHidden = true
        let item = tagList[indexPath.item]
        cell.contentImgV.backgroundColor = UIColor(hexString: item.bgColor)
        cell.tagNameLabel.text = item.tagName
        cell.contentView.layer.cornerRadius = cell.bounds.size.width / 2
        cell.selectView.layer.cornerRadius = cell.bounds.size.width / 2
        cell.contentView.layer.masksToBounds = true
        let hasC = currentSelectTagList.contains(where: {
            $0.tagName == item.tagName
        })
        if hasC {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsInputTagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: normalCellWidth(), height: normalCellWidth())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding(), left: padding(), bottom: padding(), right: padding())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding()
    }
    
}

extension MNkbsInputTagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = tagList[indexPath.item]
        let hasC = currentSelectTagList.contains(where: {
            $0.tagName == item.tagName
        })
        if hasC {
            currentSelectTagList.removeFirst {
                $0.tagName == item.tagName
            }
        } else {
            currentSelectTagList.append(item)
        }
        selectTagBlock?(currentSelectTagList)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class MNkbsInputTagCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let tagNameLabel = UILabel()
    let selectView = UIView()
    
    
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
        //
        tagNameLabel.numberOfLines = 2
        tagNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tagNameLabel.minimumScaleFactor = 0.8
        tagNameLabel.textAlignment = .center
        tagNameLabel.textColor = UIColor.white
        tagNameLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(tagNameLabel)
        tagNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalTo(12)
        }
        
        //
        selectView.isHidden = true
        selectView.layer.borderWidth = 2
        selectView.layer.borderColor = UIColor(hexString: "#FFFFFF")?.cgColor
        selectView.backgroundColor = .clear
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
    }
    
    
}

 
