//
//  MNkbsInsightDaysChart.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/6/3.
//

import UIKit
import AAInfographics

class MNkbsInsightDaysChart: UIView {

    var aaChartView = AAChartView()
    
    var monthDayItems: [MNkbsInsightChartMonthItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshData(yearMonthStr: String) {
        DispatchQueue.global().async {
            MNkbsInsightManager.default.fetchInsightDaysMoney(dateMonthString: yearMonthStr) { monthDayItems in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.monthDayItems = monthDayItems
                    self.refreshChartWithChartConfiguration()
                }
            }
        }
        
        
    }

}

extension MNkbsInsightDaysChart {
    func setupView() {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        nameLabel.text = "月花费统计图:"
        nameLabel.textColor = .white
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(5)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        aaChartView.isClearBackgroundColor = false
        aaChartView.scrollEnabled = true
        aaChartView.delegate = self as AAChartViewDelegate
        addSubview(aaChartView)
        aaChartView.translatesAutoresizingMaskIntoConstraints = false
        aaChartView.scrollView.contentInsetAdjustmentBehavior = .never
        drawChartWithChartConfiguration()
        aaChartView.snp.makeConstraints {
            $0.top.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    
}

extension MNkbsInsightDaysChart {
    
    
    func drawChartWithChartConfiguration() {
        let chartConfiguration = chartConfigurationWithSelectedChartType(.column)
         
        if (chartConfiguration is AAChartModel) {
            let aaChartModel = chartConfiguration as! AAChartModel
            aaChartModel.touchEventEnabled = true
            aaChartView.aa_drawChartWithChartModel(aaChartModel)
        } else if (chartConfiguration is AAOptions) {
            let aaOptions = chartConfiguration as! AAOptions
            aaOptions.touchEventEnabled = true
            aaChartView.aa_drawChartWithChartOptions(aaOptions)
        }
    }
    
    func refreshChartWithChartConfiguration() {
        
        let chartConfiguration = chartConfigurationWithSelectedChartType(.column)
         
        if (chartConfiguration is AAChartModel) {
            let aaChartModel = chartConfiguration as! AAChartModel
            aaChartModel.touchEventEnabled = true
            aaChartView.aa_refreshChartWholeContentWithChartModel(aaChartModel)
        } else if (chartConfiguration is AAOptions) {
            let aaOptions = chartConfiguration as! AAOptions
            aaOptions.touchEventEnabled = true
            aaChartView.aa_refreshChartWholeContentWithChartOptions(aaOptions)
        }
        
        //
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let nowMonthString = formatter.string(from: Date())
        formatter.dateFormat = "dd"
        let nowDayString = formatter.string(from: Date())
//        aaChartView.aa_showTheSeriesElementContentWithSeriesElementIndex(nowDayString.int ?? 0)
//        aaChartView.aa_updateXAxisExtremes(min: 100, max: 200)
    }
    
    
    func chartConfigurationWithSelectedChartType(_ selectedChartType: AAChartType) -> Any? {
 
        let gradientColorDic = AAGradientColor.linearGradient(
            direction: .toBottom,
            startColor: "#00BFFF",
            endColor: "#00FA9A"//颜色字符串设置支持十六进制类型和 rgba 类型
        )
        
        var xList: [String] = []
        xList = monthDayItems.compactMap {
            return $0.xInfoStr
        }
        
        
        let aaChartModel = AAChartModel()
            .chartType(.column)
            .stacking(.normal)
            .dataLabelsEnabled(false)
            .colorsTheme([gradientColorDic])
            .scrollablePlotArea(AAScrollablePlotArea()
                .minWidth(1000)
                .scrollPositionX(0))
            .series(configureY_SeriesDataArray())
            .tooltipEnabled(false)
            .categories(xList)
            .legendEnabled(false)
            
        return aaChartModel
    }
    
    func configureY_SeriesDataArray() -> [AASeriesElement] {
        var priceNumArrA = [Any]()
        
        for item in monthDayItems {
            let price = item.totalPrize()
            priceNumArrA.append(price)
        }
        
        let chartSeriesArr = [
            AASeriesElement()
                .name("")
                .lineWidth(2)
                .step(false)
                .data(priceNumArrA)

        ]
        return chartSeriesArr
    }
    
}

extension MNkbsInsightDaysChart: AAChartViewDelegate {
    open func aaChartViewDidFinishLoad(_ aaChartView: AAChartView) {
       print("🚀🚀🚀, AAChartView Did Finished Load!!!")
    }

    open func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        print(
            """
            
            selected point series element name: \(moveOverEventMessage.name ?? "")
            👌👌👌WARNING!!!!!!!!!!!!!!!!!!!! Touch Event Message !!!!!!!!!!!!!!!!!!!! WARNING👌👌👌
            || ==========================================================================================
            || ------------------------------------------------------------------------------------------
            || user finger moved over!!!,get the move over event message: {
            || category = \(String(describing: moveOverEventMessage.category))
            || index = \(String(describing: moveOverEventMessage.index))
            || name = \(String(describing: moveOverEventMessage.name))
            || offset = \(String(describing: moveOverEventMessage.offset))
            || x = \(String(describing: moveOverEventMessage.x))
            || y = \(String(describing: moveOverEventMessage.y))
            || }
            || ------------------------------------------------------------------------------------------
            || ==========================================================================================
            
            
            """
        )
    }
}
