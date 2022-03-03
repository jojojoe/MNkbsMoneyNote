//
//  MNkbsSettingVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/3/16.
//

import UIKit

class MNkbsSettingVC: UIViewController {

    let backBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        setupView()
    }
    

    func setupView() {
        
        backBtn
            .image(UIImage(named: "all_close_black"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
    }
    

}

extension MNkbsSettingVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
