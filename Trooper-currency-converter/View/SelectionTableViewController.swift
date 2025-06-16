//
//  SelectionTableViewController.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 16/06/2025.
//

import UIKit

class SelectionTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currencySelectionTableView: UITableView!
    
    
    var baseCurrencySelectionCallback : ((String) -> Void)?
    var convertedCurrencySelectionCallback : ((String) -> Void)?
    var isBaseSelectionOn: Bool = true
    
    var currencyNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencySelectionTableView.dataSource = self
        self.currencySelectionTableView.delegate = self
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = currencyNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = currencyNames[indexPath.row]
        if isBaseSelectionOn {
            self.baseCurrencySelectionCallback?(selectedCurrency)
        } else {
            self.convertedCurrencySelectionCallback?(selectedCurrency)
        }
        dismiss(animated: true)
    }

}
