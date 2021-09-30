//
//  MNkbsTagFilterView.swift
//  MNkbsMoneyNote
//
//  Created by Joe on 2021/4/24.
//

import UIKit
 

class MNkbsTagFilterView: UIView {
    var contentHeight: CGFloat = 340
    let contentBgView = UIView()
    let backbtn = UIButton(type: .custom)
    let clearSelectBtn = UIButton(type: .custom)
    let bgbtn = UIButton(type: .custom)
    let tagView = MNkbsInputTagView()
    
    var selectTagFilterBlock: (([MNkbsTagItem])->Void)?
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

extension MNkbsTagFilterView {
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

extension MNkbsTagFilterView {
    
//    func loadData() {
//        MNDBManager.default.selectTagList { tagList in
//            DispatchQueue.main.async {
//                [weak self] in
//                guard let `self` = self else {return}
//                self.tagList = tagList
//                self.collection.reloadData()
//            }
//        }
//    }
    
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
        
        contentBgView.addSubview(clearSelectBtn)
        clearSelectBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentBgView.snp.bottom)
            $0.width.equalTo(44)
            $0.height.equalTo(30)
            $0.right.equalToSuperview().offset(-24)
        }
        clearSelectBtn.setTitle("clear", for: .normal)
        clearSelectBtn.addTarget(self, action: #selector(clearSelectBtnClick(sender:)), for: .touchUpInside)
        
        setupInputTagView()
        
    }
    
    
    func setupInputTagView() {
        
        tagView.selectTagBlock = {
            [weak self] selectTagList in
            guard let `self` = self else {return}
            self.selectTagFilterBlock?(selectTagList)
        }
        contentBgView.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(contentBgView.snp.top)
            $0.bottom.equalTo(contentBgView.snp.bottom).offset(-30)
        }
    }
    
}

extension MNkbsTagFilterView {
    @objc func backbtnClick(sender: UIButton) {
        showContentStatus(isShow: false)
        
    }
    @objc func clearSelectBtnClick(sender: UIButton) {
        tagView.clearCurrentSelectTagList()
        selectTagFilterBlock?([])
        
    }
    
    
    
}
