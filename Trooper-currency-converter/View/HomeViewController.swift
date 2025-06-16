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
        
        baseCurrencyTextField.addDoneButtonOnKeyboard()
        convertedCurrencyTextField.addDoneButtonOnKeyboard()
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
