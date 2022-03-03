//
//  MNkbsNoteListVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/19.
//

import UIKit
import ZKProgressHUD

class MNkbsNoteListVC: UIViewController {
    let settingBtn = UIButton(type: .custom)
    let topTitleLabel = UILabel()
    let insightBtn = UIButton(type: .custom)
    let addNewRecordBtn = UIButton(type: .custom)
    let topEditBar = UIView()
    let timeFilterBgView = UIView()
    let timeFilterLabel = UILabel()
    let timeFilterIconV = UIImageView(image: UIImage(named: ""))
    let tagFilterBgView = UIView()
    let tagFilterLabel = UILabel()
    let tagFilterIconV = UIImageView(image: UIImage(named: ""))
    let moneyLabel = UILabel()
    var collection: UICollectionView!
    let nothingAlertBgV = UIView()
    var noteList: [MoneyNoteModel] = []
    //
    let timeFilterView = MNkbsTimeFilterView()
    let tagFilterView = MNkbsTagFilterView()
    var currentTimeType: TimeFitlerType = .week
    var currentTagsNameList: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#202020")
        view.clipsToBounds = true
        setupDefaultConfig()
        setupView()
        setupCollection()
        setupTimeFilterView()
        setupTagFilterView()
        fetchCurrentNoteItemList()
        setupNothingAlertV()
        
        
        
    }
    
    
     

}

extension MNkbsNoteListVC {
    func setupDefaultConfig() {
        loadTimerFilterUserDefaults()
    }
    
    func loadTimerFilterUserDefaults() {
        let typeInt = UserDefaults.standard.integer(forKey: "timeFilterType")
        currentTimeType = TimeFitlerType(rawValue: typeInt) ?? .week
        
    }
    func updateTimerFitlerType(type: TimeFitlerType) {
        UserDefaults.standard.set(type.rawValue, forKey: "timeFilterType")
        updateTopTimeFilterLabel()
    }
    
    func updateTopTimeFilterLabel() {
        var timeFitlerName = "Week"
        switch currentTimeType {
        case .week:
            timeFitlerName = "Week"
        case .month:
            timeFitlerName = "Month"
        case .year:
            timeFitlerName = "Year"
        case .all:
            timeFitlerName = "All"
        default:
            timeFitlerName = "All"
        }
        timeFilterLabel.text(timeFitlerName)
    }
}

extension MNkbsNoteListVC {
    func setupView() {
        
        view.addSubview(settingBtn)
        settingBtn.backgroundColor = .lightGray
        settingBtn.setImage(UIImage(named: ""), for: .normal)
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        //

        topTitleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        topTitleLabel.textColor = .white
        topTitleLabel.text = "明细"
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(settingBtn)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(10)
            $0.width.greaterThanOrEqualTo(10)
        }
        //
        
        view.addSubview(insightBtn)
        insightBtn.backgroundColor = .lightGray
        insightBtn.setImage(UIImage(named: ""), for: .normal)
        insightBtn.addTarget(self, action: #selector(insightBtnClick(sender:)), for: .touchUpInside)
        insightBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        //

        view.addSubview(topEditBar)
        topEditBar.backgroundColor = UIColor.white
        topEditBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.height.equalTo(44)
        }
        //

        topEditBar.addSubview(timeFilterBgView)
        timeFilterBgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
            $0.height.equalToSuperview()
            $0.width.equalTo(100)
        }
        //
        timeFilterLabel.text = "最近一周"
        timeFilterLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        timeFilterLabel.textColor = UIColor.black
        timeFilterLabel.textAlignment = .center
        timeFilterBgView.addSubview(timeFilterLabel)
        timeFilterLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(-20)
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        //
        
        timeFilterIconV.backgroundColor = UIColor.black
        timeFilterBgView.addSubview(timeFilterIconV)
        timeFilterIconV.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(5)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(0)
        }
        let timeFilterTapGes = UITapGestureRecognizer(target: self, action: #selector(timeFilterTapGesClick(gesture:)))
        timeFilterBgView.addGestureRecognizer(timeFilterTapGes)
        
        //
        
        topEditBar.addSubview(tagFilterBgView)
        tagFilterBgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(timeFilterBgView.snp.right).offset(24)
            $0.height.equalToSuperview()
            $0.width.equalTo(100)
        }
        //
        
        tagFilterLabel.text = "标签筛选"
        tagFilterLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tagFilterLabel.textColor = UIColor.black
        tagFilterLabel.textAlignment = .center
        tagFilterBgView.addSubview(tagFilterLabel)
        tagFilterLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(-20)
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        //
        tagFilterIconV.backgroundColor = UIColor.black
        tagFilterBgView.addSubview(tagFilterIconV)
        tagFilterIconV.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(5)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(0)
        }
        let tagFilterTapGes = UITapGestureRecognizer(target: self, action: #selector(tagFilterTapGesClick(gesture:)))
        tagFilterBgView.addGestureRecognizer(tagFilterTapGes)
        //
        
        moneyLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        moneyLabel.textAlignment = .right
        moneyLabel.adjustsFontSizeToFitWidth = true
        moneyLabel.text = "$1000"
        moneyLabel.textColor = .black
        topEditBar.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.height.greaterThanOrEqualTo(20)
            $0.width.lessThanOrEqualTo(120)
        }
        
    }
    
    func setupCollection() {
        
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
            $0.top.equalTo(topEditBar.snp.bottom)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: MNkbsNoteListCell.self)
        
        //
        addNewRecordBtn.adhere(toSuperview: view)
            .backgroundColor(.black)
        addNewRecordBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(30)
        }
        addNewRecordBtn.addTarget(self, action: #selector(addNewRecordBtnClick(sender: )), for: .touchUpInside)
    }
    
    func setupTimeFilterView() {
        view.addSubview(timeFilterView)
        timeFilterView.showBtnSelectStatus(timeType: currentTimeType)
        timeFilterView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(topEditBar.snp.bottom)
        }
        timeFilterView.alpha = 0
        timeFilterView.selectTimeFilterBlock = {
            [weak self] timeFilterType in
            guard let `self` = self else {return}
            debugPrint(timeFilterType)
            self.filterTimeNoteList(timetype: timeFilterType)
            self.updateTimerFitlerType(type: timeFilterType)
        }
        timeFilterView.backBtnBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if self.timeFilterView.isShowStatus {
                    self.timeFilterIconV.backgroundColor = UIColor.orange
                } else {
                    self.timeFilterIconV.backgroundColor = UIColor.black
                }
                
            }
        }
    }
    
    func setupTagFilterView() {
        
        view.addSubview(tagFilterView)
        tagFilterView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(topEditBar.snp.bottom)
        }
        tagFilterView.alpha = 0
        tagFilterView.selectTagFilterBlock = {
            [weak self] tagList in
            guard let `self` = self else {return}
            debugPrint(tagList)
            self.filterTagNoteList(tagList: tagList)
            
        }
        tagFilterView.backBtnBlock = {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if self.tagFilterView.isShowStatus {
                    self.tagFilterIconV.backgroundColor = UIColor.orange
                } else {
                    self.tagFilterIconV.backgroundColor = UIColor.black
                }
                
            }
        }
        
    }
    
    func setupNothingAlertV() {
        nothingAlertBgV.isHidden = true
        nothingAlertBgV.adhere(toSuperview: view)
            .isUserInteractionEnabled(true)
            .backgroundColor(UIColor.white.withAlphaComponent(0.3))
        nothingAlertBgV.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(topEditBar.snp.top)
        }
        let nothingTap = UITapGestureRecognizer()
        nothingTap.addTarget(self, action: #selector(nothingTapClick(sender: )))
        nothingAlertBgV.addGestureRecognizer(nothingTap)
        //
        let nothingIconIV = UIImageView()
        nothingIconIV.adhere(toSuperview: nothingAlertBgV)
            .image("")
            .backgroundColor(UIColor.lightGray)
        nothingIconIV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.width.height.equalTo(100)
        }
        
        //
        let notingLabel = UILabel()
        notingLabel.adhere(toSuperview: nothingAlertBgV)
            .text("Please Record")
            .textAlignment(.center)
            .numberOfLines(2)
            .fontName(18, "GillSans")
            .color(.black)
        notingLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().offset(50)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        
    }
    
    func updateNothingAlertStatus() {
        if noteList.count >= 1 {
            nothingAlertBgV.isHidden = true
        } else {
            nothingAlertBgV.isHidden = false
        }
    }
    
}

extension MNkbsNoteListVC {
    @objc func settingBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(MNkbsSettingVC())
    }
    
    @objc func insightBtnClick(sender: UIButton) {
        debugPrint("show 统计view")
        if noteList.count >= 1 {
            let vc = MNkbsInsightVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            ZKProgressHUD.showMessage("First record", maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 1, completion: nil)
        }
        
    }
    @objc func timeFilterTapGesClick(gesture: UIGestureRecognizer) {
        if tagFilterView.isShowStatus == true {
            tagFilterView.showContentStatus(isShow: false)
        }
        timeFilterView.showContentStatus(isShow: !timeFilterView.isShowStatus)
    }
    @objc func tagFilterTapGesClick(gesture: UIGestureRecognizer) {
        if timeFilterView.isShowStatus == true {
            timeFilterView.showContentStatus(isShow: false)
        }
        tagFilterView.showContentStatus(isShow: !tagFilterView.isShowStatus)
    }
    @objc func addNewRecordBtnClick(sender: UIButton) {
        showNoteEditVC(item: nil)
    }
    
    @objc func nothingTapClick(sender: UIButton) {
        showNoteEditVC(item: nil)
    }
}

extension MNkbsNoteListVC {
//    func loadNoteListData() {
////        MNDBManager.default.selectAllMoneyNoteItem {
////            [weak self] noteList in
////            guard let `self` = self else {return}
////            DispatchQueue.main.async {
////                self.noteList = noteList
////                self.collection.reloadData()
////                self.updateTotalPrice()
////                self.updateNothingAlertStatus()
////            }
////        }
//
//        //
////        let item1 = defauModelItem()
////        let item2 = defauModelItem()
////        let item3 = defauModelItem()
////        let item4 = defauModelItem()
////        let item5 = defauModelItem()
////        let item6 = defauModelItem()
////        self.noteList = [item1, item2, item3, item4, item5, item6]
//
//
//
//    }
    
    func updateTotalPrice() {
        var value: Double = 0
        for item in self.noteList {
            value += item.priceStr.double() ?? 0
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
        
        self.moneyLabel.text = MNkbsSettingManager.default.currentCurrencySymbol().rawValue + valueStr
        
    }
    
}

extension MNkbsNoteListVC {
    func defauModelItem() -> MoneyNoteModel {
        let timestamp = CLongLong(round(Date().unixTimestamp*1000)).string
        let tags1 = MNkbsTagItem(bgColor: "#FB7751", tagName: "吃饭", tagIndex: "0")
        let tags2 = MNkbsTagItem(bgColor: "#F07059", tagName: "购物", tagIndex: "1")
        let tags3 = MNkbsTagItem(bgColor: "#206259", tagName: "睡觉", tagIndex: "2")
        let tags1d = MNkbsTagItem(bgColor: "#FB7751", tagName: "吃饭", tagIndex: "0").toDict()
        let tags2d = MNkbsTagItem(bgColor: "#F07059", tagName: "购物", tagIndex: "1").toDict()
        let tags3d = MNkbsTagItem(bgColor: "#206259", tagName: "睡觉", tagIndex: "2").toDict()
        let tagList = [tags1, tags2, tags3]
        let tagListd = [tags1d, tags2d, tags3d]
        
        let model = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "13.3", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        return model
    }
    
    func showNoteEditVC(item: MoneyNoteModel?) {
        let reeditVC = MNkbsReeditVC(noteItem: item)
        reeditVC.okAddBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.fetchCurrentNoteItemList()
        }
        self.present(reeditVC, animated: true, completion: nil)
        
    }
    
}

extension MNkbsNoteListVC {
    func filterTimeNoteList(timetype: TimeFitlerType) {
        currentTimeType = timetype
        //
        fetchCurrentNoteItemList()
    }
    func filterTagNoteList(tagList: [MNkbsTagItem]) {
        let tagNameList = tagList.compactMap { (item) -> String in
            item.tagName
        }
        currentTagsNameList = tagNameList
        //
        fetchCurrentNoteItemList()
    }
    
    func fetchCurrentNoteItemList() {
        
        MNDBManager.default.filterNote(tagNameList: currentTagsNameList, timeType: currentTimeType) {
            [weak self] noteList in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.noteList = noteList
                self.collection.reloadData()
                self.updateTotalPrice()
                self.updateNothingAlertStatus()
            }
        }
    }
}

extension MNkbsNoteListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsNoteListCell.self, for: indexPath)
        //
        let item = noteList[indexPath.item]
        let notePreivew = MNkbsInputPreview()
        notePreivew.isShowTagDeleteBtn = false
        notePreivew.fetchContentWith(noteItem: item, isEnableEditing: false)
        cell.contentView.removeSubviews()
        cell.contentView.addSubview(notePreivew)
        notePreivew.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsNoteListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension MNkbsNoteListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = noteList[indexPath.item]
        showNoteEditVC(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class MNkbsNoteListCell: UICollectionViewCell {
//    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        contentImgV.contentMode = .scaleAspectFill
//        contentImgV.clipsToBounds = true
//        contentView.addSubview(contentImgV)
//        contentImgV.snp.makeConstraints {
//            $0.top.right.bottom.left.equalToSuperview()
//        }
        
        
    }
}
 
