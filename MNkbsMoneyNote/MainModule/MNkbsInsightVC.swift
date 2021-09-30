//
//  MNkbsInsightVC.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/5/6.
//

import UIKit

class MNkbsInsightVC: UIViewController {

    let topTitleLabel = UILabel()
    let backBtn = UIButton(type: .custom)
    let bgContentV = UIView()
    let dateSelectBgView = UIView()
    let dateLabel = UILabel()
    let totalMoneyLabel = UILabel()
    let gouchengView = MNkbsInsightGouChengView()
    let paihangView = MNkbsInsightPaiHangView()
    let daysInsightChart = MNkbsInsightDaysChart()
    let yearMonthsInsightChart = MNkbsInsightMonthsChart()
    var currentYearMonth: String = "2021-06"
    var currentYear: String = "2021"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContentInsightView()
        updateData()
    }
    
    func updateData() {
        
        let (beginDate, endDate, numberOfDaysInMonth) = MNkbsInsightManager.default.processBeginDateAndEndDate(dateMonthString: currentYearMonth)
        debugPrint("numberOfDaysInMonth: \(numberOfDaysInMonth)")
        MNkbsInsightManager.default.fetchTotalPrice(beginTime: beginDate, endTime: endDate) { priceTotalStr in
            DispatchQueue.main.async {
                let symbol = MNkbsSettingManager.default.currentCurrencySymbol()
                self.totalMoneyLabel.text = "\(symbol.rawValue)\(priceTotalStr)"
            }
        }
        gouchengView.fetchGouChengData(beginTime: beginDate, endTime: endDate)
        
        paihangView.fetchPaiHangData(beginTime: beginDate, endTime: endDate)
        
        daysInsightChart.refreshData(yearMonthStr: currentYearMonth)
        
        yearMonthsInsightChart.refreshData(yearStr: currentYear)
    }
    

}

extension MNkbsInsightVC {
    func setupView() {
        view.backgroundColor = UIColor(hexString: "#202020")
        
        topTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        topTitleLabel.text = "Insight"
        topTitleLabel.textColor = UIColor.white
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.height.equalTo(44)
            $0.width.greaterThanOrEqualTo(10)
        }
        //

        backBtn.setTitle("back", for: .normal)
        backBtn.setTitleColor(.white, for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.centerY.equalTo(topTitleLabel)
            $0.left.equalTo(10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        //
        let bgContentScrollView = UIScrollView()
        view.addSubview(bgContentScrollView)
        bgContentScrollView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        //
        
        bgContentV.backgroundColor = UIColor(hexString: "#202020")
        bgContentScrollView.addSubview(bgContentV)
        bgContentV.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            $0.height.equalTo(1400)
        }
        //
        
        dateSelectBgView.backgroundColor = UIColor(hexString: "EAEAEA")
        dateSelectBgView.layer.cornerRadius = 4
        bgContentV.addSubview(dateSelectBgView)
        dateSelectBgView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.equalTo(20)
            $0.width.equalTo(150)
            $0.height.equalTo(44)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateSelectBgViewClick(gesture:)))
        dateSelectBgView.addGestureRecognizer(tap)
        
        //
        
        dateLabel.text = "2021年1月"
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .black
        dateSelectBgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalTo(10)
            $0.top.equalToSuperview()
        }
        //
        totalMoneyLabel.font = UIFont(name: "ArialRoundedMTBold", size: 24 )
        totalMoneyLabel.textColor = .white
        totalMoneyLabel.text = "$1000"
        bgContentV.addSubview(totalMoneyLabel)
        totalMoneyLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateSelectBgView)
            $0.right.equalTo(-20)
            $0.height.greaterThanOrEqualTo(10)
            $0.width.greaterThanOrEqualTo(1)
        }
        //
        
        
    }
    
    func setupContentInsightView() {
        
        bgContentV.addSubview(gouchengView)
        gouchengView.snp.makeConstraints {
            $0.top.equalTo(totalMoneyLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
        //
        bgContentV.addSubview(paihangView)
        paihangView.snp.makeConstraints {
            $0.top.equalTo(gouchengView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(390)
        }
        //
        
        bgContentV.addSubview(daysInsightChart)
        daysInsightChart.snp.makeConstraints {
            $0.top.equalTo(paihangView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(0)
            $0.height.equalTo(280)
        }
        
        //
        bgContentV.addSubview(yearMonthsInsightChart)
        yearMonthsInsightChart.snp.makeConstraints {
            $0.top.equalTo(daysInsightChart.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(0)
            $0.height.equalTo(280)
        }
        
        
        
    }
}

extension MNkbsInsightVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dateSelectBgViewClick(gesture: UITapGestureRecognizer) {
        //
        debugPrint("show time select")
    }
    
}









