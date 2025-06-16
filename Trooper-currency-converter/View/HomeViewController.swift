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
    
    private let viewModel = LatestRatesViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchLatestRates(base: "EUR")
        viewModel.latestRates
            .subscribe(onNext: { [weak self]
                rate in
                print(rate?.rates)
            })
            .disposed(by: disposeBag)
    }


}
