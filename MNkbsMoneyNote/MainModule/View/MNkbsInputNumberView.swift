//
//  MNkbsInputNumberBar.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/10.
//

import UIKit


class MNkbsInputNumberBar: UIView {
    var numberBarClickBlock: ((MNkbsNumberItem)->Void)?
    var numCell_equal: MNkbsNumberCell?
    var numCell_done: MNkbsNumberCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupNumberView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MNkbsInputNumberBar {
    func refreshNumberBarEqual(isShow: Bool) {
        showEqualCellStatus(isShow: isShow)
    }
    
    
}

extension MNkbsInputNumberBar {
    func showEqualCellStatus(isShow: Bool) {
        numCell_equal?.isHidden = !isShow
        
    }
    
    func refreshDoneStatus(isEnable: Bool) {
        if isEnable {
            numCell_done?.numLabel.textColor = UIColor.black
            numCell_done?.isUserInteractionEnabled = true
        } else {
            numCell_done?.numLabel.textColor = UIColor.lightGray
            numCell_done?.isUserInteractionEnabled = false
        }
        
    }
    
    
}


extension MNkbsInputNumberBar {
    func setupView() {
        backgroundColor = UIColor(hexString: "#F7BB48")
       
    }
    
    func padding() -> CGFloat {
        let padding: CGFloat = 16
        return padding
    }
    
    func normalCellWidth() -> CGFloat {
        let numberWidth: CGFloat = (UIScreen.main.bounds.width - (padding() * 5)) / 4
        return numberWidth
    }
    
    func normalCellHeight() -> CGFloat {
        let numberHeight: CGFloat = normalCellWidth() * (5.0/8.0)
        return numberHeight
    }
    
    func viewHeight() -> CGFloat {
        let height = normalCellHeight() * 4 + padding() * 5
        return height
    }
    
    func numberCell(item: MNkbsNumberItem) -> MNkbsNumberCell {
        let cell = MNkbsNumberCell(frame: CGRect.zero, numberItem: item)
        cell.numberClickBlock = {
            [weak self] numberItem in
            guard let `self` = self else {return}
            self.numberBarClickBlock?(numberItem)
        }
        addSubview(cell)
        return cell
    }
    func setupNumberView() {
        //
        let numCell_point = numberCell(item:  MNkbsNumberManager.default.number_point)
        numCell_point.snp.makeConstraints {
            $0.bottom.equalTo(-padding())
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(padding())
            
        }
        //
        let numCell_0 = numberCell(item:  MNkbsNumberManager.default.number_0)
        numCell_0.snp.makeConstraints {
            $0.bottom.equalTo(numCell_point.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_point.snp.right).offset(padding())
        }
        //
        let numCell_delete = numberCell(item:  MNkbsNumberManager.default.number_delete)
        numCell_delete.snp.makeConstraints {
            $0.bottom.equalTo(numCell_0.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_0.snp.right).offset(padding())
        }
        //
        let numCell_1 = numberCell(item:  MNkbsNumberManager.default.number_1)
        numCell_1.snp.makeConstraints {
            $0.bottom.equalTo(numCell_point.snp.top).offset(-padding())
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_point.snp.left)
        }
        //
        let numCell_2 = numberCell(item:  MNkbsNumberManager.default.number_2)
        numCell_2.snp.makeConstraints {
            $0.bottom.equalTo(numCell_1.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_1.snp.right).offset(padding())
        }
        //
        let numCell_3 = numberCell(item:  MNkbsNumberManager.default.number_3)
        numCell_3.snp.makeConstraints {
            $0.bottom.equalTo(numCell_1.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_2.snp.right).offset(padding())
        }
        //
        let numCell_4 = numberCell(item:  MNkbsNumberManager.default.number_4)
        numCell_4.snp.makeConstraints {
            $0.bottom.equalTo(numCell_1.snp.top).offset(-padding())
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_1.snp.left)
        }
        //
        let numCell_5 = numberCell(item:  MNkbsNumberManager.default.number_5)
        numCell_5.snp.makeConstraints {
            $0.bottom.equalTo(numCell_4.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_4.snp.right).offset(padding())
        }
        //
        let numCell_6 = numberCell(item:  MNkbsNumberManager.default.number_6)
        numCell_6.snp.makeConstraints {
            $0.bottom.equalTo(numCell_4.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_5.snp.right).offset(padding())
        }
        //
        let numCell_7 = numberCell(item:  MNkbsNumberManager.default.number_7)
        numCell_7.snp.makeConstraints {
            $0.bottom.equalTo(numCell_4.snp.top).offset(-padding())
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_4.snp.left)
        }
        //
        let numCell_8 = numberCell(item:  MNkbsNumberManager.default.number_8)
        numCell_8.snp.makeConstraints {
            $0.bottom.equalTo(numCell_7.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_7.snp.right).offset(padding())
        }
        //
        let numCell_9 = numberCell(item:  MNkbsNumberManager.default.number_9)
        numCell_9.snp.makeConstraints {
            $0.bottom.equalTo(numCell_7.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_8.snp.right).offset(padding())
        }
        
        //
        let numCell_add = numberCell(item: MNkbsNumberManager.default.number_add)
        numCell_add.snp.makeConstraints {
            $0.bottom.equalTo(numCell_7.snp.bottom)
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_9.snp.right).offset(padding())
        }
        //
        let numCell_sub = numberCell(item: MNkbsNumberManager.default.number_sub)
        numCell_sub.snp.makeConstraints {
            $0.top.equalTo(numCell_add.snp.bottom).offset(padding())
            $0.width.equalTo((normalCellWidth()))
            $0.height.equalTo(normalCellHeight())
            $0.left.equalTo(numCell_add.snp.left)
        }
        
        //
        numCell_done = numberCell(item:  MNkbsNumberManager.default.number_done)
        numCell_done?.snp.makeConstraints {
            $0.top.equalTo(numCell_sub.snp.bottom).offset(padding())
            $0.width.equalTo((normalCellWidth()))
//            $0.height.equalTo(normalCellHeight())
            $0.bottom.equalTo(numCell_point.snp.bottom)
            $0.left.equalTo(numCell_add.snp.left)
        }
        //
        numCell_equal = numberCell(item:  MNkbsNumberManager.default.number_equal)
        numCell_equal?.snp.makeConstraints {
            $0.left.right.bottom.top.equalTo(numCell_done!)
        }
        showEqualCellStatus(isShow: false)
        
    }
    
    
}






class MNkbsNumberCell: UIView {
    
    let bgImgV = UIImageView()
    let numLabel = UILabel()
    let overlayerBtn = UIButton(type: .custom)
    var numberClickBlock: ((MNkbsNumberItem)->Void)?
    var numberItem: MNkbsNumberItem
    
    
    init(frame: CGRect, numberItem: MNkbsNumberItem) {
        self.numberItem = numberItem
        super.init(frame: frame)
        setupView()
        updateContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent() {
        numLabel.text = numberItem.displayName
    }
    
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        //
        addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        numLabel.textColor = UIColor(hexString: "#3C3039")
        numLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        numLabel.textAlignment = .center
        numLabel.adjustsFontSizeToFitWidth = true
        addSubview(numLabel)
        numLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalTo(5)
            $0.left.equalTo(5)
        }
        //
        addSubview(overlayerBtn)
        overlayerBtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        overlayerBtn.addTarget(self, action: #selector(overlayerBtnTouchDown(sender:)), for: .touchDown)
        overlayerBtn.addTarget(self, action: #selector(overlayerBtnTouchUpInside(sender:)), for: .touchUpInside)
        
    }
    
    
    @objc func overlayerBtnTouchDown(sender: UIButton) {
        
    }
    
    @objc func overlayerBtnTouchUpInside(sender: UIButton) {
        numberClickBlock?(numberItem)
    }
    
}
