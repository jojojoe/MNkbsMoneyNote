//
//  MNkbsSubscriptionVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/3/16.
//

import UIKit
 
 
struct BWdhaoSubscribeInfoItem {
    var title: String = ""
    var detail: String = ""
    var icon: String = ""
}


class MNkbsSubscriptionVC: UIViewController {

    
    var collection: UICollectionView!
    var collectionInfoList: [BWdhaoSubscribeInfoItem] = []
    
    let monthSbuBtn = BWdhSubscriBtn()
    let monthPriceOri: CGFloat = 6.99
    let yearSubBtn = BWdhSubscriBtn()
    let yearPriceOri: CGFloat = 29.99
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setupView()
        setupSubscriptionBtn()
        loadData()
    }
    

    func loadData() {
        
        let info1 = BWdhaoSubscribeInfoItem(title: "Media Insights".localized(), detail: "Find out your most popular media and see likers & commentors of the media.".localized(), icon: "info_icon_media")
        let info2 = BWdhaoSubscribeInfoItem(title: "Engagement Insights".localized(), detail: "See your best followers and worst followers.".localized(), icon: "info_icon_media")
        let info3 = BWdhaoSubscribeInfoItem(title: "Audience Insights".localized(), detail: "See your " + "ad" + "mire" + "rs a" + "nd what action" + "s they take to your media.", icon: "info_icon_media")
         
        
        collectionInfoList = [info1, info2, info3]
        collection.reloadData()
    }
    

}

extension MNkbsSubscriptionVC {
    func setupView() {
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: ""))
            .backgroundColor(UIColor.white)
//            .rx.tap
//            .subscribe(onNext:  {
//                [weak self] in
//                guard let `self` = self else {return}
//                if self.navigationController != nil {
//                    self.navigationController?.popViewController()
//                } else {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
//            .disposed(by: disposeBag)
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel
            .fontName(14, FONT_AvenirNextDemiBold)
            .color(UIColor.white)
            .text("Store")
            .adhere(toSuperview: self.view)
        topTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let restoreBtn = UIButton(type: .custom)
        restoreBtn
            .title("Restore")
            .font(18, FONT_AvenirNextDemiBold)
            .titleColor(UIColor.orange)
            .adhere(toSuperview: self.view)
        restoreBtn.contentHorizontalAlignment = .right
        restoreBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalTo(-24)
            $0.width.greaterThanOrEqualTo(60)
            $0.height.equalTo(44)
        }
        restoreBtn.addTarget(self, action: #selector(restoreAction(sender:)), for: .touchUpInside)
        
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = true
        collection.isPagingEnabled = true
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(30)
        }
        collection.register(cellWithClass: BWdhaoSubscribePreviewInfoCell.self)
        
        // bottom link
        let bottomLinkView = BWdhSubBottomLinkView()
        view.addSubview(bottomLinkView)
        bottomLinkView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview()
        }
        
        
        
    }
    
    func setupSubscriptionBtn() {
        let bottomBgView = UIView()
        view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(collection.snp.bottom)
        }
        
        //
        bottomBgView.addSubview(monthSbuBtn)
        monthSbuBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomBgView.snp.centerY).offset(-20)
            $0.width.equalTo(300)
            $0.height.equalTo(60)
        }
        monthSbuBtn.addTarget(self, action: #selector(monthSbuBtnClick(sender:)), for: .touchUpInside)
        let monthPriceFullStr = "XX / Month".localized().replacingOccurrences(of: "XX", with: "$\(monthPriceOri)")
        monthSbuBtn.priceLabel.text = monthPriceFullStr
        monthSbuBtn.infoLabel.text = "Subscribe for XX month".localized().replacingOccurrences(of: "XX", with: "1")
        
        
        //
        bottomBgView.addSubview(yearSubBtn)
        yearSubBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomBgView.snp.centerY).offset(20)
            $0.width.equalTo(300)
            $0.height.equalTo(60)
        }
        yearSubBtn.addTarget(self, action: #selector(yearSubBtnClick(sender:)), for: .touchUpInside)
        let yearPriceFullStr = "XX / Year".localized().replacingOccurrences(of: "XX", with: "$\(yearPriceOri)")
        yearSubBtn.priceLabel.text = yearPriceFullStr
        yearSubBtn.infoLabel.text = "Subscribe for XX months".localized().replacingOccurrences(of: "XX", with: "12")
        
    }
    
    func loadPrice() {
        PurchaseManager.default.purchaseInfo { [weak self] items in
            guard let `self` = self else { return }
            
            let monthItem = items.filter { $0.iapID == IAPType.month.rawValue }.first
            let currencyCode = monthItem?.priceLocale.currencySymbol ?? "$"
            let monthPrice = ((monthItem?.price.cgFloat ?? self.monthPriceOri) * 100.0).int
            let monthPriceStr = String(format: "%.2f", monthPrice.cgFloat / 100.0)
            let monthPriceFullStr = "XX / Month".localized().replacingOccurrences(of: "XX", with: "\(currencyCode)\(monthPriceStr)")
            //
            let yearItem = items.filter { $0.iapID == IAPType.year.rawValue }.first
            let yearPrice = ((yearItem?.price.cgFloat ?? self.yearPriceOri) * 100.0).int
            let yearPriceStr = String(format: "%.2f", yearPrice.cgFloat / 100.0)
            let yearPriceFullStr = "XX / Year".localized().replacingOccurrences(of: "XX", with: "\(currencyCode)\(yearPriceStr)")
            
            //
            self.monthSbuBtn.priceLabel.text = monthPriceFullStr
            self.yearSubBtn.priceLabel.text = yearPriceFullStr
            
            
        }
    }
    
}

extension MNkbsSubscriptionVC {
    func purchaseOrderIAP(iapType: IAPType) {
        PurchaseManager.default.order(iapType: iapType, source: "unknown", page: "", isInTest: false, success: {
            [weak self] in
            guard let `self` = self else {return}
            
            let status = PurchaseManager.default.inSubscription
            print("purchase status : \(status)")
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: PurchaseStatusNotificationKeys.success),
                object: nil,
                userInfo: nil
            )
            if self.navigationController != nil {
                self.navigationController?.popViewController()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}

extension MNkbsSubscriptionVC {
    @objc func yearSubBtnClick(sender: UIButton) {
        purchaseOrderIAP(iapType: .year)
    }
    
    @objc func monthSbuBtnClick(sender: UIButton) {
        purchaseOrderIAP(iapType: .month)
    }
    
    @objc func restoreAction(sender: UIButton) {
        HUD.show()
        PurchaseManager.default.restore {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                HUD.hide()
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: PurchaseStatusNotificationKeys.success),
                    object: nil,
                    userInfo: nil
                )
                if self.navigationController != nil {
                    self.navigationController?.popViewController()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension MNkbsSubscriptionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: BWdhaoSubscribePreviewInfoCell.self, for: indexPath)
        let item = collectionInfoList[indexPath.item]
        cell.contentImgV.image = UIImage(named: item.icon)
        cell.titleLabel.text = item.title
        cell.infoLabel.text = item.detail
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionInfoList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension MNkbsSubscriptionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.width
        let height: CGFloat = collectionView.bounds.height
        
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension MNkbsSubscriptionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class BWdhaoSubscribePreviewInfoCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        //
        titleLabel
            .fontName(16, FONT_AvenirHeavy)
            .color(UIColor.white)
            .textAlignment(.center)
            .numberOfLines(0)
            .adhere(toSuperview: contentView)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.greaterThanOrEqualTo(40)
            $0.left.equalTo(50)
        }
        //
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-20)
            $0.width.height.equalTo(50)
        }
        //
        infoLabel
            .fontName(16, FONT_AvenirHeavy)
            .color(UIColor.white)
            .textAlignment(.center)
            .numberOfLines(0)
            .adhere(toSuperview: contentView)
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.height.greaterThanOrEqualTo(40)
            $0.left.equalTo(50)
        }
    }
}



class BWdhSubscriBtn: UIButton {
    let selectStatusImgV = UIImageView()
    let priceLabel = UILabel()
    let infoLabel = UILabel()
    
    var isCurrentStatus: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSelectStatus(isSele: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelectStatus(isSele: Bool) {
        if isSele {
            layer.borderColor = UIColor.black.cgColor
            selectStatusImgV
                .backgroundColor(UIColor.black)
                .image("")
        } else {
            layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
            selectStatusImgV
                .backgroundColor(UIColor.lightGray)
                .image("")
        }
    }

    func setupView() {
        backgroundColor = UIColor.white
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 12
        //
        selectStatusImgV
            .image("")
            .backgroundColor(.lightGray)
            .adhere(toSuperview: self)
        selectStatusImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(30)
            $0.width.height.equalTo(20)
        }
        //
        priceLabel
            .fontName(16, FONT_AvenirHeavy)
            .color(UIColor.black)
            .adhere(toSuperview: self)
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-8)
            $0.left.equalTo(selectStatusImgV.snp.right).offset(24)
            $0.width.greaterThanOrEqualTo(100)
            $0.height.greaterThanOrEqualTo(20)
        }
        //
        infoLabel
            .fontName(12, FONT_AvenirHeavy)
            .color(UIColor.black)
            .adhere(toSuperview: self)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(3)
            $0.left.equalTo(selectStatusImgV.snp.right).offset(24)
            $0.width.greaterThanOrEqualTo(100)
            $0.height.greaterThanOrEqualTo(20)
        }
        
    }
    
}

class BWdhSubBottomLinkView: UIView {
    
    var purchaseBtnBlock: (()->Void)?
    var termsBtnBlock: (()->Void)?
    var privacyBtnBlock: (()->Void)?
    
    var purchaseBtn = UIButton(type: .custom)
    var termsBtn = UIButton(type: .custom)
    var privacyBtn = UIButton(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear

        purchaseBtn
            .title("Purchase Notice", .normal)
            .font(10, FONT_MONTSERRAT_REGULAR)
            .titleColor(UIColor.lightGray)
            .adhere(toSuperview: self)
        termsBtn
            .title("Terms of Use", .normal)
            .font(10, FONT_MONTSERRAT_REGULAR)
            .titleColor(UIColor.lightGray)
            .adhere(toSuperview: self)
        privacyBtn
            .title("Privacy Policy", .normal)
            .font(10, FONT_MONTSERRAT_REGULAR)
            .titleColor(UIColor.lightGray)
            .adhere(toSuperview: self)

        //
        
        purchaseBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.greaterThanOrEqualTo(40)
            $0.width.greaterThanOrEqualTo(50)
        }
        //
        let leftLine = UIView()
        leftLine.backgroundColor(UIColor.lightGray)
        addSubview(leftLine)
        leftLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(15)
            $0.centerY.equalTo(purchaseBtn.snp.centerY)
            $0.right.equalTo(purchaseBtn.snp.left).offset(-8)
        }
        //
        let rightLine = UIView()
        rightLine.backgroundColor(UIColor.lightGray)
        addSubview(rightLine)
        rightLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(15)
            $0.centerY.equalTo(purchaseBtn.snp.centerY)
            $0.left.equalTo(purchaseBtn.snp.right).offset(8)
        }
        //
        privacyBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(leftLine.snp.left).offset(-8)
            $0.height.greaterThanOrEqualTo(40)
            $0.width.greaterThanOrEqualTo(50)
        }
        //
        termsBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(rightLine.snp.right).offset(8)
            $0.height.greaterThanOrEqualTo(40)
            $0.width.greaterThanOrEqualTo(50)
        }
        
        termsBtn.addTarget(self, action: #selector(termsBtnClick(_:)), for: .touchUpInside)
        purchaseBtn.addTarget(self, action: #selector(purchaseBtnClick(_:)), for: .touchUpInside)
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(_:)), for: .touchUpInside)
        
    }
    
    @objc func purchaseBtnClick(_ sender: UIButton) {
        purchaseBtnBlock?()
    }
    
    @objc func termsBtnClick(_ sender: UIButton) {
        termsBtnBlock?()
    }
    
    @objc func privacyBtnClick(_ sender: UIButton) {
        privacyBtnBlock?()
    }
    
    
}


