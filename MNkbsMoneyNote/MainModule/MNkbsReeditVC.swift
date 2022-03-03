//
//  MNkbsReeditVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/25.
//

import UIKit
import ZKProgressHUD

class MNkbsReeditVC: UIViewController {

    let topTitleLabel = UILabel()
    let backBtn = UIButton(type: .custom)
    
    let inputPreview = MNkbsInputPreview()
    let tagView = MNkbsInputTagView()
    let numberBar = MNkbsInputNumberBar()
    var okAddBlock: (()->Void)?
    let currentNoteItem: MoneyNoteModel?
    
    init(noteItem: MoneyNoteModel?) {
        currentNoteItem = noteItem
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#171717")
        setupView()
        setupInputPreview()
        setupInputNumberBar()
        setupInputTagView()
        
        // last
        setupCurrentNoteItemContent()
        addNotiAction()
    }
    
    func addNotiAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTagChangeStatus(object: )), name: NSNotification.Name(rawValue: "noti_tagChange"), object: nil)
        
    }
    @objc func updateTagChangeStatus(object: Any?) {
        DispatchQueue.main.async {
            self.tagView.loadData()
        }
    }

}

extension MNkbsReeditVC {
   
}

extension MNkbsReeditVC {
    func setupCurrentNoteItemContent() {
        if let item = currentNoteItem {
            inputPreview.fetchContentWith(noteItem: item)
            tagView.udpateCurrentSelectTagList(tagList: item.tagModelList)
            self.numberBar.refreshDoneStatus(isEnable: true)
        } else {
            self.numberBar.refreshDoneStatus(isEnable: false)
        }
        
    }
    
}

extension MNkbsReeditVC {
    func setupView() {
        
        topTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        topTitleLabel.text = "Edit"
        topTitleLabel.textColor = UIColor.white
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
            $0.width.greaterThanOrEqualTo(10)
        }
        //

        backBtn.setTitle("back", for: .normal)
        backBtn.setTitleColor(.white, for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.centerY.equalTo(topTitleLabel)
            $0.right.equalTo(-10)
            $0.width.equalTo(54)
            $0.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        //
        
    }
    
    
    func setupInputPreview() {
        inputPreview.shouldShowEqualStatusBlock = {
            [weak self] isShow in
            guard let `self` = self else {return}
            self.numberBar.refreshNumberBarEqual(isShow: isShow)
        }
        inputPreview.didUpdateCurrentTagsBlock = {
            [weak self] tagList in
            guard let `self` = self else {return}
            self.tagView.udpateCurrentSelectTagList(tagList: tagList)
        }
        inputPreview.isShowTagDeleteBtn = true
        view.addSubview(inputPreview)
        inputPreview.snp.makeConstraints {
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(130)
        }
    }
    
    func setupInputTagView() {
        
        tagView.selectTagBlock = {
            [weak self] selectTagList in
            guard let `self` = self else {return}
            self.inputPreview.updateTagCollection(tags: selectTagList)
        }
        tagView.editTagBtnClickBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.showTagEditVC()
            }
        }
        view.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(inputPreview.snp.bottom)
            $0.bottom.equalTo(numberBar.snp.top)
        }
    }
    
    func setupInputNumberBar() {
        
        view.addSubview(numberBar)
        numberBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(numberBar.viewHeight())
        }
        numberBar.numberBarClickBlock = {
            [weak self] numbItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.inputNumber(item: numbItem)
            }
        }
    }
}


extension MNkbsReeditVC {
    func showTagEditVC() {
        let tagEditVC = MNkbsTagEditVC()
         
        self.present(tagEditVC, animated: true, completion: nil)
    }
}


extension MNkbsReeditVC {
    @objc func backBtnClick(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension MNkbsReeditVC {
    func inputNumber(item: MNkbsNumberItem) {
        if item.numberType == .number_done {
            saveCurrentRecordToDB()
            backBtnClick(sender: backBtn)
            
            okAddBlock?()
        } else {
            self.inputPreview.inputNumber(item: item)
        }
        
        let priceStr: String = self.inputPreview.currentNumberStr
        if priceStr == "0" || priceStr == "0." || priceStr == "0.0" || priceStr == "0.00" {
            self.numberBar.refreshDoneStatus(isEnable: false)
        } else {
            self.numberBar.refreshDoneStatus(isEnable: true)
        }
    }
    
    func saveCurrentRecordToDB() {
        let priceStr: String = self.inputPreview.currentNumberStr
        let remark: String = self.inputPreview.remarkTextView.text
        let recordDateStr: String = CLongLong(round(self.inputPreview.datePicker.date.unixTimestamp*1000)).string
        //使用当前编辑的 note item 的唯一键值 systemDate
        let systemDateStr: String = self.currentNoteItem?.systemDate ?? CLongLong(round(Date().unixTimestamp*1000)).string
        var tagJsonString: String = ""
        var tagList: [[String:String]] = []
        var tagItemList_m: [MNkbsTagItem] = self.inputPreview.tagsList
        if self.inputPreview.tagsList.count == 0 {
            // 设置空标签
            let kongItem = MNkbsTagItem()
            let dict = kongItem.toDict()
            tagList.append(dict)
            tagItemList_m = [kongItem]
        } else {
            for tagItem in self.inputPreview.tagsList {
                let dict = tagItem.toDict()
                tagList.append(dict)
            }
        }
        
        
        tagJsonString = tagList.toString // array转string
        /*
         tagJsonString = JSON.init(parseJSON: tagJsonString).description // array通过 JSON 转string
         let arry = tagJsonString.toArray
         debugPrint(arry)
         do {
 //            let data = try JSON.init(arry).rawData()
             let data = try JSON.init(parseJSON: tagJsonString).rawData()
             let model = try JSONDecoder().decode([MNkbsTagItem].self, from: data)
             debugPrint(model)
         } catch {

         }
         */
        let model = MoneyNoteModel(sysDate: systemDateStr, recorDate: recordDateStr, price: priceStr, remark: remark, tagJson: tagJsonString, tagModel: tagItemList_m)
        MNDBManager.default.addMoneyNoteItem(model: model) {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                debugPrint("add complete")
                ZKProgressHUD.showSuccess()
                self.inputPreview.clearDefaultStatus()
            }
        }
    }
}
