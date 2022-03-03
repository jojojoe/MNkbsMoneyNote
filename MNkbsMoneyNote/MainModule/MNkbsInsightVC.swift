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
    var gouchengView: MNkbsInsightGouChengView! // = MNkbsInsightGouChengView()
    var paihangView: MNkbsInsightPaiHangView! //= MNkbsInsightPaiHangView()
    var daysInsightChart: MNkbsInsightDaysChart! // = MNkbsInsightDaysChart()
    var yearMonthsInsightChart: MNkbsInsightMonthsChart! // = MNkbsInsightMonthsChart()
    var currentYearMonth: String = "2021-06"
    var currentYear: String = "2021"
    var isCurrentShowYearChart: Bool = false
    
    let calendarView = MNkbsYearMonthSelectView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#202020")
        self.setupDefaultData()
        self.setupView()
//        self.setupContentInsightView()
//        self.setupYearMonthSelectView()
//        self.updateShowYearChartStatus(isShow: false)
//        
//        self.updateData()
         
//        DispatchQueue.global().async {
//            [weak self] in
//            guard let `self` = self else {return}
//            self.updateData()
//        }
        
        
    }
    
    func setupDefaultData() {
        let date = Date.today()
        let yearDateStr = date.string(withFormat: "yyyy")
        let monthDateStr = date.string(withFormat: "yyyy-MM")
        currentYear = yearDateStr
        currentYearMonth = monthDateStr
        isCurrentShowYearChart = false
        
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
        
        if isCurrentShowYearChart {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.yearMonthsInsightChart.refreshData(yearStr: self.currentYear)
            }

        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.daysInsightChart.refreshData(yearMonthStr: self.currentYearMonth)
            }
            

        }
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
            $0.height.equalTo(1000)
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
        
        dateLabel.text = "\(currentYearMonth)"
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
        totalMoneyLabel.text = ""
        bgContentV.addSubview(totalMoneyLabel)
        totalMoneyLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateSelectBgView)
            $0.right.equalTo(-20)
            $0.height.greaterThanOrEqualTo(10)
            $0.width.greaterThanOrEqualTo(1)
        }
        //
    }
    
    func showMoreGouchengPreview(list: [MNkbsInsightItem]) {
        let vc = MNkbsGouchengPreviewVC(gouchengList: list)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMorePaihangPreview(list: [MoneyNoteModel]) {
        let vc = MNkbsPaihangPreviewVC(paihangList: list)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupContentInsightView() {
        gouchengView = MNkbsInsightGouChengView()
        bgContentV.addSubview(gouchengView)
        gouchengView.snp.makeConstraints {
            $0.top.equalTo(totalMoneyLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(260)
        }
        gouchengView.moreBtnClickBlock = {
            [weak self] lis in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showMoreGouchengPreview(list: lis)
            }
        }
        //
        paihangView = MNkbsInsightPaiHangView()
        bgContentV.addSubview(paihangView)
        paihangView.snp.makeConstraints {
            $0.top.equalTo(gouchengView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(310)
        }
        paihangView.moreBtnClickBlock = {
            [weak self] lis in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showMorePaihangPreview(list: lis)
            }
        }
        //
        daysInsightChart = MNkbsInsightDaysChart()
        bgContentV.addSubview(daysInsightChart)
        daysInsightChart.snp.makeConstraints {
            $0.top.equalTo(paihangView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(0)
            $0.height.equalTo(280)
        }
        
        //
        yearMonthsInsightChart = MNkbsInsightMonthsChart()
        bgContentV.addSubview(yearMonthsInsightChart)
        yearMonthsInsightChart.snp.makeConstraints {
            $0.top.equalTo(paihangView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(0)
            $0.height.equalTo(280)
        }
    }
    
    func updateShowYearChartStatus(isShow: Bool) {
        isCurrentShowYearChart = isShow
        daysInsightChart.isHidden = isCurrentShowYearChart
        yearMonthsInsightChart.isHidden = !isCurrentShowYearChart
    }
}

extension MNkbsInsightVC {
    
    func setupYearMonthSelectView() {
        
        calendarView.alpha = 0
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showYearMonthSelectView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.calendarView.alpha = 1
        }
        
        calendarView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.calendarView.alpha = 0
            } completion: { finished in
                if finished {
                     
                }
            }
        }
        
        calendarView.selectClickBlock = {
            [weak self] yearStrm, monthStrm in
            guard let `self` = self else {return}
            debugPrint("yearStr - \(yearStrm)")
            debugPrint("monthStr - \(monthStrm ?? "")")
            if let monthStrm_m = monthStrm {
                self.currentYearMonth = self.yearMonthStr(year: yearStrm, monthIndexStr: monthStrm_m)
                self.updateShowYearChartStatus(isShow: false)
            } else {
                self.currentYearMonth = yearStrm
                self.updateShowYearChartStatus(isShow: false)
            }
            
            self.currentYear = yearStrm
            
            DispatchQueue.main.async {
                
                self.updateData()
            }
            
        }
        
    }
    
    func yearMonthStr(year: String, monthIndexStr: String) -> String {
        var ymStr: String = "\(year)-01"
        if monthIndexStr == "0" {
            ymStr = "\(year)-01"
        } else if monthIndexStr == "1" {
            ymStr = "\(year)-02"
        } else if monthIndexStr == "2" {
            ymStr = "\(year)-03"
        } else if monthIndexStr == "3" {
            ymStr = "\(year)-04"
        } else if monthIndexStr == "4" {
            ymStr = "\(year)-05"
        } else if monthIndexStr == "5" {
            ymStr = "\(year)-06"
        } else if monthIndexStr == "6" {
            ymStr = "\(year)-07"
        } else if monthIndexStr == "7" {
            ymStr = "\(year)-08"
        } else if monthIndexStr == "8" {
            ymStr = "\(year)-09"
        } else if monthIndexStr == "9" {
            ymStr = "\(year)-10"
        } else if monthIndexStr == "10" {
            ymStr = "\(year)-11"
        } else if monthIndexStr == "11" {
            ymStr = "\(year)-12"
        }
        return ymStr
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
        showYearMonthSelectView()
        debugPrint("show time select")
    }
    
}









