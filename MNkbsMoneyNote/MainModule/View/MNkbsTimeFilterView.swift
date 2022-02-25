//
//  MNkbsTimeFilterView.swift
//  MNkbsMoneyNote
//
//  Created by Joe on 2021/4/24.
//

import UIKit

enum TimeFitlerType {
    case week
    case month
    case year
    case all
    case custom
}

class MNkbsTimeFilterView: UIView {

    let contentHeight: CGFloat = 200
    let contentBgView = UIView()
    let backbtn = UIButton(type: .custom)
    let bgbtn = UIButton(type: .custom)
    let weekBtn = UIButton(type: .custom)
    let monthBtn = UIButton(type: .custom)
    let yearBtn = UIButton(type: .custom)
    let allBtn = UIButton(type: .custom)
    
    var selectTimeFilterBlock: ((TimeFitlerType)->Void)?
    var isShowStatus: Bool = false
    var backBtnBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MNkbsTimeFilterView {
    func showContentStatus(isShow: Bool) {
        var offset: CGFloat = 0
        if isShow {
            self.alpha = 1
            offset = 0
        } else {
            offset = -contentHeight
        }
        self.contentBgView.snp.updateConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(offset)
            $0.height.equalTo(self.contentHeight)
        }
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            guard let `self` = self else {return}
            self.layoutIfNeeded()
        } completion: { (finished) in
            if finished {
                if !isShow {
                    self.alpha = 0
                }
                self.isShowStatus = isShow
                self.backBtnBlock?()
            }
        }

    }
    
    
    
}

extension MNkbsTimeFilterView {
    func setupView() {
        backgroundColor = .clear
        layer.masksToBounds = true
        //
        addSubview(bgbtn)
        bgbtn.backgroundColor = .clear
        bgbtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        bgbtn.addTarget(self, action: #selector(backbtnClick(sender:)), for: .touchUpInside)
        
        //
        addSubview(contentBgView)
        contentBgView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        contentBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(-contentHeight)
            $0.height.equalTo(contentHeight)
        }
        
        //
        contentBgView.addSubview(backbtn)
        backbtn.snp.makeConstraints {
            $0.bottom.equalTo(contentBgView.snp.bottom)
            $0.width.equalTo(44)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        backbtn.setTitle("back", for: .normal)
        backbtn.addTarget(self, action: #selector(backbtnClick(sender:)), for: .touchUpInside)
        
        //
        let padding: CGFloat = 20
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - (padding * 4)) / 3
        let cellHeight: CGFloat = 44
        contentBgView.addSubview(weekBtn)
        weekBtn.snp.makeConstraints {
            $0.top.equalTo(padding)
            $0.left.equalTo(padding)
            $0.width.equalTo(cellWidth)
            $0.height.equalTo(cellHeight)
        }
        weekBtn.setTitle("最近一周", for: .normal)
        weekBtn.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        weekBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#FFFFFF") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .normal)
        weekBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#F7BB48") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .selected)
        weekBtn.addTarget(self, action: #selector(weekbtnClick(sender:)), for: .touchUpInside)
        
        //
        contentBgView.addSubview(monthBtn)
        monthBtn.snp.makeConstraints {
            $0.top.equalTo(padding)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(cellWidth)
            $0.height.equalTo(cellHeight)
        }
        monthBtn.setTitle("最近一月", for: .normal)
        monthBtn.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        monthBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#FFFFFF") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .normal)
        monthBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#F7BB48") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .selected)
        monthBtn.addTarget(self, action: #selector(monthbtnClick(sender:)), for: .touchUpInside)
        
        //
        contentBgView.addSubview(yearBtn)
        yearBtn.snp.makeConstraints {
            $0.top.equalTo(padding)
            $0.right.equalTo(-padding)
            $0.width.equalTo(cellWidth)
            $0.height.equalTo(cellHeight)
        }
        yearBtn.setTitle("最近一年", for: .normal)
        yearBtn.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        yearBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#FFFFFF") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .normal)
        yearBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#F7BB48") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .selected)
        yearBtn.addTarget(self, action: #selector(yearbtnClick(sender:)), for: .touchUpInside)
        
        //
        contentBgView.addSubview(allBtn)
        allBtn.snp.makeConstraints {
            $0.top.equalTo(weekBtn.snp.bottom).offset(20)
            $0.left.equalTo(weekBtn)
            $0.width.equalTo(cellWidth)
            $0.height.equalTo(cellHeight)
        }
        allBtn.setTitle("全部", for: .normal)
        allBtn.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        allBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#FFFFFF") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .normal)
        allBtn.setBackgroundImage(UIImage(color: UIColor(hexString: "#F7BB48") ?? UIColor.white, size: CGSize(width: cellWidth, height: cellHeight)), for: .selected)
        allBtn.addTarget(self, action: #selector(allbtnClick(sender:)), for: .touchUpInside)
        //
         
        
    }
    
    
    
    
}

extension MNkbsTimeFilterView {
    @objc func backbtnClick(sender: UIButton) {
        showContentStatus(isShow: false)
        
    }
    @objc func weekbtnClick(sender: UIButton) {
        weekBtn.isSelected = true
        monthBtn.isSelected = false
        yearBtn.isSelected = false
        allBtn.isSelected = false
        selectTimeFilterBlock?(.week)
    }
    @objc func monthbtnClick(sender: UIButton) {
        monthBtn.isSelected = true
        weekBtn.isSelected = false
        yearBtn.isSelected = false
        allBtn.isSelected = false
        selectTimeFilterBlock?(.month)
    }
    @objc func yearbtnClick(sender: UIButton) {
        yearBtn.isSelected = true
        weekBtn.isSelected = false
        monthBtn.isSelected = false
        allBtn.isSelected = false
        selectTimeFilterBlock?(.year)
    }
    @objc func allbtnClick(sender: UIButton) {
        allBtn.isSelected = true
        weekBtn.isSelected = false
        yearBtn.isSelected = false
        monthBtn.isSelected = false
        selectTimeFilterBlock?(.all)
    }
}

