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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyTextField: UITextField!
    @IBOutlet weak var convertedCurrencyTextField: UITextField!
    
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var convertedCurrencyButton: UIButton!
    
    
    private let viewModel = LatestRatesViewModel()
    private let disposeBag = DisposeBag()

    var currencyNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Converter"
        viewModel.fetchLatestRates(base: AppConstant.defaultBaseCurrency)
        bindTextFields()
        populateSelectionView()
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
            .distinctUntilChanged()
            .map { text -> String in
                guard let usd = Double(text) else { return "" }
                let bdt = usd * self.viewModel.conversionRate.value
                return String(format: "%.2f", bdt)
            }
            .bind(to: convertedCurrencyTextField.rx.text)
            .disposed(by: disposeBag)

        convertedCurrencyTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { text -> String in
                guard let bdt = Double(text) else { return "" }
                let usd = bdt / self.viewModel.conversionRate.value
                return String(format: "%.2f", usd)
            }
            .bind(to: baseCurrencyTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.conversionRate
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.baseCurrencyTextField.text = "0"
                self?.convertedCurrencyTextField.text = "0"
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
