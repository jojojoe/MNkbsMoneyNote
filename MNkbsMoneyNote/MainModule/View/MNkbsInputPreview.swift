//
//  MNkbsInputPreview.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/7.
//

import UIKit



class MNkbsInputPreview: UIView {

    var collection: UICollectionView!
    var tagsList: [MNkbsTagItem] = []
    let numberLabel = UILabel()
    var numberList: [NumberType] = []
    var shouldShowEqualStatusBlock: ((Bool)->Void)?
    var currentNumberStr: String = ""
    let remarkTextView = UITextView()
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#F7BB48")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MNkbsInputPreview {
    func clearDefaultStatus() {
        datePicker.date = Date()
        updateTagCollection(tags: [])
        updateNumber(numberItems: [.number_0])
        remarkTextView.text = ""
        
    }
    
    func fetchContentWith(noteItem: MoneyNoteModel, isEnableEditing: Bool = true) {
        
        let numbers = MNkbsNumberManager.default.processStringToNumType(valueStr: noteItem.priceStr)
        self.updateNumber(numberItems: numbers)
        //
        tagsList = noteItem.tagModelList
        collection.reloadData()
        //
        remarkTextView.text = noteItem.remarkStr
        //
        let timestamp = noteItem.recordDate    
        //CLongLong(round(Date().unixTimestamp*1000)).string
        let dou = Double(timestamp) ?? 0
        let timeInterStr = String(dou / 1000)
        //
        if let interval = TimeInterval.init(timeInterStr) {
            let recordDate = Date(timeIntervalSince1970: interval)
            datePicker.date = recordDate
        }
        if isEnableEditing {
            remarkTextView.isUserInteractionEnabled = true
            datePicker.isUserInteractionEnabled = true
        } else {
            remarkTextView.isUserInteractionEnabled = false
            datePicker.isUserInteractionEnabled = false
        }
                
        
    }
}

extension MNkbsInputPreview {
    func updateTagCollection(tags: [MNkbsTagItem]) {
        tagsList = tags
        collection.reloadData()
        if tags.count >= 1 {
            collection.scrollToItem(at: IndexPath(item: tags.count - 1, section: 0), at: .right, animated: true)
        }
        
    }
    
    func inputNumber(item: MNkbsNumberItem) {
        
        if item.numberType == .number_delete {
            numberList.removeLast()
            if numberList.count == 0 {
                numberList.append(.number_0)
            }
            checkShowEqualStatus()
            updateNumber(numberItems: numberList)
        }
        if item.numberType == .number_add {
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_add {
                numberList.removeLast()
            }
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_sub {
                numberList.removeLast()
            }
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_point {
                numberList.removeLast()
                
            }
            if numberList.contains(.number_add) || numberList.contains(.number_sub) {
                // 等号功能
                equalFuncAction()
                numberList.append(item.numberType)
                checkShowEqualStatus()
                updateNumber(numberItems: numberList)
                return
            } else {
                numberList.append(item.numberType)
                checkShowEqualStatus()
                updateNumber(numberItems: numberList)
                return
            }
        }
        if item.numberType == .number_sub {
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_add {
                numberList.removeLast()
            }
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_sub {
                numberList.removeLast()
            }
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_point {
                numberList.removeLast()
                numberList.append(item.numberType)
                checkShowEqualStatus()
                updateNumber(numberItems: numberList)
                return
            }
            if numberList.contains(.number_add) || numberList.contains(.number_sub) {
                // 等号功能
                equalFuncAction()
                numberList.append(item.numberType)
                checkShowEqualStatus()
                updateNumber(numberItems: numberList)
                return
            } else {
                numberList.append(item.numberType)
                checkShowEqualStatus()
                updateNumber(numberItems: numberList)
                return
            }
        }
        if item.numberType == .number_equal {
            // 等号功能
            equalFuncAction()
            checkShowEqualStatus()
        }
        //TODO: 不能超过10位
        if numberList.count >= 16 {
            return
        }
        if item.numberType == .number_0 {
            if numberList.count == 1, numberList[numberList.count - 1] == .number_0 {
                return
            }
            if numberList.count >= 2, numberList[numberList.count - 1] == .number_0 {
                if numberList[numberList.count - 2] == .number_sub || numberList[numberList.count - 2] == .number_add {
                    return
                }
            }
            if numberList.count >= 4, numberList[numberList.count - 3] == .number_point {
                return
            }
            numberList.append(item.numberType)
            updateNumber(numberItems: numberList)
            return
        }
        let numb1_9: [NumberType] = [.number_1, .number_2, .number_3, .number_4, .number_5, .number_6, .number_7, .number_8, .number_9]
        if numb1_9.contains(item.numberType) {
            if numberList.count == 1, numberList[numberList.count - 1] == .number_0 {
                numberList.removeFirst()
                numberList.append(item.numberType)
                updateNumber(numberItems: numberList)
                return
            }
            if numberList.count >= 4 && numberList[numberList.count - 3] == .number_point && numb1_9.contains(numberList[numberList.count - 1]) {
                return
            }
            numberList.append(item.numberType)
            updateNumber(numberItems: numberList)
            return
        }
        if item.numberType == .number_point {
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_point {
                return
            }
            if numberList.count >= 1, numberList[numberList.count - 1] == .number_add || numberList[numberList.count - 1] == .number_sub {
                numberList.append(.number_0)
                numberList.append(item.numberType)
                updateNumber(numberItems: numberList)
                return
            }
            if numberList.count >= 3, numberList[numberList.count - 2] == .number_point {
                return
            }
            if numberList.count >= 4, numberList[numberList.count - 3] == .number_point {
                return
            }
            numberList.append(item.numberType)
            updateNumber(numberItems: numberList)
            return
        }
    }
    
    func equalFuncAction() {
        // 开始计算
        var value: Double = 0
        
        if currentNumberStr.contains("+") {
            let numbs = currentNumberStr.components(separatedBy: "+")
            let val1 = numbs.first?.double() ?? 0
            let val2 = numbs.last?.double() ?? 0
            value = val1 + val2
            
        } else if currentNumberStr.contains("-") {
            let numbs = currentNumberStr.components(separatedBy: "-")
            let val1 = numbs.first?.double() ?? 0
            let val2 = numbs.last?.double() ?? 0
            value = val1 - val2
            if value < 0 {
                value = 0
            }
        }
        
        // 计算完成后 重新赋值 numberList
        var valueStr = String(format: "%.2f", value)
        let values = valueStr.components(separatedBy: ".")
        let totalLastValue = values.last?.float() ?? 0
        if totalLastValue > 0 {
            
        } else {
            valueStr = Int(value).string
        }
        //
        let typeList = MNkbsNumberManager.default.processStringToNumType(valueStr: valueStr)
        updateNumber(numberItems: typeList)
        
    }
    
    func checkShowEqualStatus() {
        if numberList.contains(.number_add) || numberList.contains(.number_sub) {
            shouldShowEqualStatusBlock?(true)
        } else {
            shouldShowEqualStatusBlock?(false)
        }
        
    }
    
    
    func updateNumber(numberItems: [NumberType]) {
        let currencySymbol = "\(MNkbsSettingManager.default.currentCurrencySymbol().rawValue)"
        
        let numStr = MNkbsNumberManager.default.processItemsNumber(numberItems: numberItems)
         
        self.numberList = numberItems
        currentNumberStr = numStr
        numberLabel.text = currencySymbol + numStr
    }
}

extension MNkbsInputPreview {
    func setupView() {
        let topBgView = UIView()
        topBgView.backgroundColor = UIColor(hexString: "#FFECCC")
        topBgView.layer.cornerRadius = 8
        addSubview(topBgView)
        topBgView.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
        //
        numberList = [.number_0]
        updateNumber(numberItems: numberList)
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 38)
        numberLabel.textColor = UIColor.black
        topBgView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.left.equalTo(10)
            $0.height.greaterThanOrEqualTo(60)
            $0.right.equalTo(-120)
        }
        //
        remarkTextView.returnKeyType = .done
        remarkTextView.delegate = self
        remarkTextView.textColor = UIColor.darkGray
        remarkTextView.font = UIFont(name: "AvenirNext-Medium", size: 13)
        remarkTextView.placeholder = "备注..."
        topBgView.addSubview(remarkTextView)
        remarkTextView.snp.makeConstraints {
            $0.left.equalTo(numberLabel.snp.right).offset(10)
            $0.top.equalTo(numberLabel)
            $0.height.equalToSuperview()
            $0.right.equalTo(0)
        }
        //
        let tagLabel = UILabel()
        tagLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        tagLabel.textColor = UIColor.lightGray
        tagLabel.text = "标签"
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(topBgView.snp.bottom).offset(10)
            $0.left.equalTo(topBgView)
            $0.width.greaterThanOrEqualTo(20)
            $0.height.greaterThanOrEqualTo(44)
        }
        //
        
        datePicker.tintColor = .black
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar.init(identifier: .gregorian)
        addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.centerY.equalTo(tagLabel)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
            
        }
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
            $0.centerY.equalTo(tagLabel)
            $0.left.equalTo(tagLabel.snp.right).offset(6)
            $0.height.equalTo(44)
            $0.right.equalTo(-135)
        }
        collection.register(cellWithClass: MNkbsInputPreviewTagCell.self)
        //
        
    }
    
    
}

extension MNkbsInputPreview: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsInputPreviewTagCell.self, for: indexPath)
        let item = tagsList[indexPath.item]
        cell.contentImgV.backgroundColor = UIColor(hexString: item.bgColor)
        cell.tagNameLabel.text = item.tagName
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsInputPreview: UICollectionViewDelegateFlowLayout {
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

extension MNkbsInputPreview: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

extension MNkbsInputPreview: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            if let contentText = textView.text {
                
            }
            return false
        }
        
        return true
    }
    
}



class MNkbsInputPreviewTagCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let tagNameLabel = UILabel()
    
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
        //
        tagNameLabel.numberOfLines = 1
        tagNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        tagNameLabel.minimumScaleFactor = 0.8
        tagNameLabel.textAlignment = .center
        tagNameLabel.textColor = UIColor.white
        tagNameLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(tagNameLabel)
        tagNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(0)
            $0.left.equalTo(28)
            $0.right.equalTo(-6)
            $0.top.equalTo(0)
        }
        
    }
}


