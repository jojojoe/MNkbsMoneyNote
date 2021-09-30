//
//  MNkbsTagEditVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/7/9.
//

import UIKit
import NoticeObserveKit


class MNkbsTagEditVC: UIViewController {
    private var pool = Notice.ObserverPool()
    var collection: UICollectionView!
    let tagAddEditView = MNkbsAddTagEditView()
    var tagList: [MNkbsTagItem] = []
    
    var contentTextFeid = UITextField()
    var toolView = UIView()
    var hideButton = UIButton()

    
    var dragingTagItem: MNkbsTagItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAddTagEditView()
        loadData()
        setupDropAlert()
    }
    
    func loadData() {
        
        MNDBManager.default.selectTagList(completionBlock: { [weak self] itemList in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                
                self.tagList = itemList
                
                // test
                self.tagList = MNkbsTagManager.default.testtagList()
                
                self.collection.reloadData()
            }
        })
        
    }
    
    func refreshData() {
        loadData()
    }
    
    func setupView() {
        let topBanner = UIView()
        topBanner.backgroundColor = UIColor.darkGray
        view.addSubview(topBanner)
        topBanner.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
//        let backBtn = UIButton(type: .custom)
//        backBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
//        topBanner.addSubview(backBtn)
//        backBtn.setTitleColor(.white, for: .normal)
//        backBtn.setTitle("Back", for: .normal)
//        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
//        backBtn.snp.makeConstraints {
//            $0.left.equalTo(10)
//            $0.centerY.equalToSuperview()
//            $0.width.height.equalTo(44)
//        }
        //
        let topTitleLabel = UILabel()
        topTitleLabel.textColor = .white
        topTitleLabel.text = "Edit Tag"
        topTitleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        topBanner.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let doneBtn = UIButton(type: .custom)
        doneBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        topBanner.addSubview(doneBtn)
        doneBtn.setTitleColor(.white, for: .normal)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.addTarget(self, action: #selector(doneBtnClick(sender:)), for: .touchUpInside)
        doneBtn.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(cellWithClass: MNkbsEditTagCell.self)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.dragDelegate = self
        collection.dropDelegate = self
        //示集合视图是否支持应用程序之间的拖放
        collection.dragInteractionEnabled = true
        view.addSubview(collection)
        collection.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    func setupDropAlert() {
        
        let hasShow = UserDefaults.standard.bool(forKey: "user_hasShowDropAlert")
        if hasShow == true {
            return
        }
        
        let dropAlertBgV = UIView()
        dropAlertBgV
            .backgroundColor(UIColor.black.withAlphaComponent(0.8))
            .adhere(toSuperview: view)
        dropAlertBgV.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }
        //
        let dropAlertLabel = UILabel()
        dropAlertLabel
            .fontName(20, FONT_AvenirNextBold)
            .color(.white)
            .numberOfLines(0)
            .text("长按标签拖动更改排序")
            .textAlignment(.left)
            .adhere(toSuperview: dropAlertBgV)
        dropAlertLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(24)
            $0.right.equalTo(90)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        //
        let dropAlertCloseBtn = UIButton(type: .custom)
        dropAlertCloseBtn
            .title("I know")
            .titleColor(UIColor.black)
            .backgroundColor(UIColor.white)
            .font(14, FONT_AvenirNextBold)
            .adhere(toSuperview: dropAlertBgV)
        dropAlertCloseBtn.layer.cornerRadius = 8
        dropAlertCloseBtn.layer.masksToBounds = true
        dropAlertCloseBtn.snp.makeConstraints {
            $0.right.equalTo(-12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        dropAlertCloseBtn.addTarget(self, action: #selector(dropAlertCloseBtnClick(sender:)), for: .touchUpInside)
    }
     
    @objc func dropAlertCloseBtnClick(sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "user_hasShowDropAlert")
        sender.superview?.removeFromSuperview()
    }
    
    @objc func hideButtonClick(button: UIButton) {
        self.contentTextFeid.resignFirstResponder()
        self.tagAddEditView.isHidden = true
        
        if let tag = self.contentTextFeid.text {
            let tag_m = tag.replacingOccurrences(of: " ", with: "")
            if tag_m == "" {
                return
            }
            
            MNDBManager.default.addMoneyTag(tagName: tag, tagColor: tagAddEditView.currentBgColorStr, tagIndex: "0") {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.refreshData()
                }
            }
        }
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doneBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        saveUpdateTagIndex()
        
        
    }
    
    func saveUpdateTagIndex() {
        
        for (index, tagItem) in tagList.enumerated() {
            MNDBManager.default.addMoneyTag(tagName: tagItem.tagName, tagColor: tagItem.bgColor, tagIndex: index.string) {
                
            }
        }
        Notice.Center.default.post(name: Notice.Names.mn_noti_TagRefresh, with: nil)
    }
    
    func addNewTagItemClick() {
        
        view.addSubview(toolView)
        contentTextFeid.becomeFirstResponder()
        
        tagAddEditView.isHidden = false
        tagAddEditView.bgBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.tagAddEditView.isHidden = true
            self.contentTextFeid.resignFirstResponder()
        }
         
    }
    
    
    
}

extension MNkbsTagEditVC {
    func padding() -> CGFloat {
        let padding: CGFloat = 16
        return padding
    }
    
    func normalCellWidth() -> CGFloat {
        let numberWidth: CGFloat = (UIScreen.main.bounds.width - (padding() * 6)) / 5
        return numberWidth
    }
    
    func tagDeleteAction(tag: MNkbsTagItem) {
        
        showAlert(title: "确定删除该标签吗", message: nil, buttonTitles: ["Cancel", "OK"], highlightedButtonIndex: 0) { btnIndex in
            if btnIndex == 1 {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    MNDBManager.default.deleteMoneyTag(tagName: tag.tagName) {
                        DispatchQueue.main.async {
                            self.refreshData()
                        }
                    }
                }
            }
        }
    }
}

extension MNkbsTagEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MNkbsEditTagCell.self, for: indexPath)
        if indexPath.item == 0 {
            cell.contentImgV.backgroundColor = UIColor.darkGray
            cell.tagNameLabel.text = "添加"
            cell.deletebtn.isHidden = true
            cell.tagItem = nil
        } else {
            let item = tagList[indexPath.item - 1]
            cell.contentImgV.backgroundColor = UIColor(hexString: item.bgColor)
            cell.tagNameLabel.text = item.tagName
            cell.tagItem = item
            cell.deletebtn.isHidden = false
            cell.deletebtnClickBlock = {
                [weak self] tag in
                guard let `self` = self else {return}
                if let tagIt = tag {
                    DispatchQueue.main.async {
                        self.tagDeleteAction(tag: tagIt)
                    }
                }
            }
        }
        cell.contentImgV.layer.cornerRadius = cell.bounds.width / 2
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count + 1
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsTagEditVC: UICollectionViewDelegateFlowLayout {
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

extension MNkbsTagEditVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            addNewTagItemClick()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

extension MNkbsTagEditVC: UICollectionViewDropDelegate {
    ///处理拖动放下后如何处理
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        switch coordinator.proposal.operation {
        case .move:
            let items = coordinator.items
            if let item = items.first, let sourceIndexPath = item.sourceIndexPath {
                //执行批量更新
                collectionView.performBatchUpdates({
                    self.tagList.remove(at: sourceIndexPath.item - 1)
                    self.tagList.insert(item.dragItem.localObject as! MNkbsTagItem, at: destinationIndexPath.item - 1)

                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                //将项目动画化到视图层次结构中的任意位置
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
            break
        case .copy:
            //执行批量更新
            collectionView.performBatchUpdates({
                var indexPaths = [IndexPath]()
                for (index, item) in coordinator.items.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    
                    self.tagList.insert(item.dragItem.localObject as! MNkbsTagItem, at: indexPath.item - 1)
                
                    indexPaths.append(indexPath)
                }
                collectionView.insertItems(at: indexPaths)
            })
            break
        default:
            return
        }
    }
    ///处理拖动过程中
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard destinationIndexPath?.item != 0 else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        if session.localDragSession != nil {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
}
//MARK: - UICollectionViewDragDelegate
extension MNkbsTagEditVC: UICollectionViewDragDelegate {
    ///处理首次拖动时，是否响应
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.item != 0 else {
            return []
        }
        let item = tagList[indexPath.item - 1]

        let tagName = item.tagName
        
        let itemProvider = NSItemProvider(object: tagName as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
}

extension MNkbsTagEditVC {
    
    
    func setupAddTagEditView() {

        tagAddEditView.isHidden = true
        view.addSubview(tagAddEditView)
        tagAddEditView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        view.addSubview(toolView)
        toolView.backgroundColor = UIColor(hexString: "#AFAFAF")
        toolView.frame = CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: 40)
        
        //
        hideButton.setImage(UIImage(named: ""), for: .normal)
        hideButton.setTitle("Done", for: .normal)
        hideButton.setTitleColor(UIColor.systemBlue, for: .normal)
        hideButton.backgroundColor = UIColor.init(hexString: "#1D1D1D")
        hideButton.addTarget(self, action: #selector(hideButtonClick(button:)), for: .touchUpInside)
        toolView.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        //
        contentTextFeid.delegate = self
        contentTextFeid.textAlignment = .center
        contentTextFeid.borderStyle = .roundedRect
        contentTextFeid.textColor = .black
        contentTextFeid.backgroundColor = .white
        contentTextFeid.inputAccessoryView = toolView
        contentTextFeid.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        toolView.addSubview(contentTextFeid)
        
        contentTextFeid.placeholder = "标签..."
        contentTextFeid.clearButtonMode = .whileEditing
        contentTextFeid.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(24)
            $0.right.equalTo(hideButton.snp.left).offset(-16)
            $0.height.equalTo(36)
        }
        
        contentTextFeid.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        self.tagAddEditView.updateContentTagLabel(tagStr: sender.text)
    }
    
}


extension MNkbsTagEditVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        debugPrint("textFieldDidEndEditing")
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            
        } else {
//            TaskDelay.default.taskDelay(afterTime: 0.8) {[weak self] in
//                guard let `self` = self else {return}
//            }
        }
        debugPrint("shouldChangeCharactersIn")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        hideButtonClick(button: hideButton)
        
        return true
    }
    
    
}





class MNkbsEditTagCell: UICollectionViewCell {
    let contentBgView = UIView()
    let contentImgV = UIImageView()
    let tagNameLabel = UILabel()
    let deletebtn = UIButton()
    var deletebtnClickBlock: ((MNkbsTagItem?)->Void)?
    var tagItem: MNkbsTagItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(contentBgView)
        contentBgView.backgroundColor = .clear
        contentBgView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentBgView.addSubview(contentImgV)
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
        contentBgView.addSubview(tagNameLabel)
        tagNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalTo(12)
        }
        
        //
        contentBgView.addSubview(deletebtn)
        deletebtn.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        deletebtn.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        deletebtn.addTarget(self, action: #selector(deletebtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func deletebtnClick(sender: UIButton) {
        deletebtnClickBlock?(tagItem)
    }
    
}
