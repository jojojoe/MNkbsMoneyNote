//
//  MNkbsMainVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/3/16.
//

import UIKit
import SwifterSwift
import SnapKit
import SwiftyJSON
import ZKProgressHUD
// 废弃
class MNkbsMainVC: UIViewController {
    let topBar = UIView()
    let settingBtn = UIButton(type: .custom)
    let insightBtn = UIButton(type: .custom)
    
    let inputPreview = MNkbsInputPreview()
    let tagView = MNkbsInputTagView()
    let numberBar = MNkbsInputNumberBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#171717")
        setupCodeUI()
    }
    

     

}

extension MNkbsMainVC {
    func setupCodeUI() {

        view.addSubview(topBar)
        topBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        //

        topBar.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        settingBtn.backgroundColor = .lightGray
        settingBtn.setTitle("设置", for: .normal)
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        //
        
        topBar.addSubview(insightBtn)
        insightBtn.snp.makeConstraints {
            $0.right.equalTo(-12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        insightBtn.backgroundColor = .lightGray
        insightBtn.setTitle("分析", for: .normal)
        insightBtn.addTarget(self, action: #selector(insightBtnClick(sender:)), for: .touchUpInside)
        //
        setupInputPreview()
        setupInputNumberBar()
        setupInputTagView()
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
            $0.top.equalTo(topBar.snp.bottom).offset(6)
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
        numberBar.refreshDoneStatus(isEnable: false)
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

extension MNkbsMainVC {
    func inputNumber(item: MNkbsNumberItem) {
        if item.numberType == .number_done {
            saveCurrentRecordToDB()
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
        let systemDateStr: String = CLongLong(round(Date().unixTimestamp*1000)).string
        var tagJsonString: String = ""
        var tagList: [[String:String]] = []
        
        
        for tagItem in self.inputPreview.tagsList {
            let dict = tagItem.toDict()
            tagList.append(dict)
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
        let model = MoneyNoteModel(sysDate: systemDateStr, recorDate: recordDateStr, price: priceStr, remark: remark, tagJson: tagJsonString, tagModel: self.inputPreview.tagsList)
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

extension MNkbsMainVC {
    @objc func settingBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(MNkbsSettingVC())
    }
    @objc func insightBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(MNkbsNoteListVC())
    }
    
}


extension MNkbsMainVC {
    func showTagEditVC() {
        self.present(MNkbsTagEditVC(), animated: true, completion: nil)
    }
}

