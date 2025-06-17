//
//  ViewController.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 13/06/2025.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Charts
import DGCharts

class HomeViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyTextField: UITextField!
    @IBOutlet weak var convertedCurrencyTextField: UITextField!
    
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var convertedCurrencyButton: UIButton!
    
    @IBOutlet weak var loadChartButton: UIButton!
    @IBOutlet weak var offlineLabel: UILabel!
    
    @IBOutlet weak var chartDateLabel: UILabel!
    @IBOutlet weak var barGraphView: BarChartView!
    private let viewModel = LatestRatesViewModel()
    private let historicatlViewModel = HistoricalRatesViewModel()
    
    private let disposeBag = DisposeBag()

    var currencyNames : [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Converter"
        
        bindTextFields()
        populateSelectionView()
        fetchData()
        configureUI()
    }
    
    func fetchData() {
        ReachabilityService.shared.isReachable
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isConnected in
                print("Network is reachable: \(isConnected)")
                self?.offlineLabel.isHidden = isConnected
                self?.viewModel.fetchLatestRates(base: AppConstant.defaultBaseCurrency, isInternetAvailable: isConnected)
                //
            })
            .disposed(by: disposeBag)
    }
    
    func fetchhistoricalData() {
        historicatlViewModel.fetchHistoticalRates(base: AppConstant.defaultBaseCurrency, isInternetAvailable: true)
        historicatlViewModel.historicalRates
            .asObservable()
            .subscribe(onNext: { newRate in
                if let model = newRate {
                    self.setupBarChart(from: model, in: self.barGraphView!)
                    self.chartDateLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupBarChart(from model: HistoricalRateModel, in barChartView: BarChartView) {
        let sortedRates = model.rates.sorted { $0.key < $1.key }

        let entries = sortedRates.enumerated().map { index, item in
            BarChartDataEntry(x: Double(index), y: item.value)
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Exchange Rates to \(model.base)")
        dataSet.colors = ChartColorTemplates.material()
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data

        // Format x-axis with currency codes
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sortedRates.map { $0.key })
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelRotationAngle = -45

        // Optional: animation
        barChartView.animate(yAxisDuration: 1.2)
    }
    
    
    fileprivate func configureUI() {
        baseCurrencyTextField.addDoneButtonOnKeyboard()
        convertedCurrencyTextField.addDoneButtonOnKeyboard()
        
        baseCurrencyButton.setCornerRadius(4.0)
        convertedCurrencyButton.setCornerRadius(4.0)
        loadChartButton.setCornerRadius(4.0)
        
        chartDateLabel.text = "Previous day's chart \(AppConstant.getDate())"
        chartDateLabel.isHidden = true
    }
    
    private func populateSelectionView(){
        viewModel.latestRates
            .subscribe(onNext: {[weak self] rates in
                if let rates = rates {
                    self?.currencyNames = Array(rates.rates.keys)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindTextFields() {
        
        baseCurrencyTextField.rx.text.orEmpty
            .map { text -> String in
                // Keep only digits and at most one dot
                let filtered = text.filter { "0123456789.".contains($0) }
                let components = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                let clean = components.prefix(2).joined(separator: ".")
                guard let base = Double(clean) else { return "" }
                let con = base * self.viewModel.conversionRate.value
                return String(format: "%.2f", con)
            }
            .distinctUntilChanged()
            .bind(to: convertedCurrencyTextField.rx.text)
            .disposed(by: disposeBag)

        convertedCurrencyTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { text -> String in
                let filtered = text.filter { "0123456789.".contains($0) }
                let components = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                let clean = components.prefix(2).joined(separator: ".")
                guard let con = Double(clean) else { return "" }
                let base = con / self.viewModel.conversionRate.value
                return String(format: "%.2f", base)
            }
            .bind(to: baseCurrencyTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.conversionRate
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.baseCurrencyTextField.text = nil
                self?.convertedCurrencyTextField.text = nil
            })
            .disposed(by: disposeBag)
        
        loadChartButton.rx.tap
            .subscribe(onNext: {
                print("Button tapped!")
                self.fetchhistoricalData()
            })
            .disposed(by: disposeBag)
    }

    @IBAction func baseCurrencyButtonPressed(_ sender: Any) {
        guard let selectionVC = StoryBoardManeger.shared.viewController(from: "Main", identifier: "SelectionTableViewController") as? SelectionTableViewController else {
            return
        }
        selectionVC.baseCurrencySelectionCallback = { currencyName in
            self.viewModel.convert(to: currencyName)
            self.baseCurrencyButton.setTitle(currencyName, for: .normal)
        }
        if !currencyNames.isEmpty {
            selectionVC.currencyNames = self.currencyNames.sorted()
            StoryBoardManeger.shared.present(selectionVC, from: self, fullscreen: false)
        }
        
    }
    @IBAction func convertedCurrencyButtonPressed(_ sender: Any) {
        guard let selectionVC = StoryBoardManeger.shared.viewController(from: "Main", identifier: "SelectionTableViewController") as? SelectionTableViewController else {
            return
        }
        selectionVC.isBaseSelectionOn = false
        selectionVC.convertedCurrencySelectionCallback = { currencyName in
            self.viewModel.convertedCurrencyRelay.accept(currencyName)
            self.convertedCurrencyButton.setTitle(currencyName, for: .normal)
        }
        if !currencyNames.isEmpty {
            selectionVC.currencyNames = self.currencyNames.sorted()
            StoryBoardManeger.shared.present(selectionVC, from: self, fullscreen: false)
        }
    }
    
}
