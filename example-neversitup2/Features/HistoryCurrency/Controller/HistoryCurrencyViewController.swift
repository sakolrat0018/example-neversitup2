//
//  HistoryCurrencyViewController.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/30/22.
//

import UIKit
import RealmSwift

class HistoryCurrencyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName:"SecTableViewCell", bundle: nil), forCellReuseIdentifier: "SecCell")
            tableView.register(UINib(nibName:"HisDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "HisDetailCell")
            
            tableView.delegate   = self
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
        }
    }
    
    var viewModel = HistoryCurrencyViewModel()
    var data:  Results<Currency>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.historyDataSuccessCallback = { [weak self] response in
            guard let self = self else { return }
            self.data = response
            self.tableView.reloadData()
        }
        
        viewModel.getHistoryCurrency()
    }

}

//MARK: - UI TableView Delegate
extension HistoryCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - Section
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = data else { return 0 }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let data = data else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecCell") as! SecTableViewCell
        
        let sec: Currency = data[section]
        cell.titleLabel.text = sec.timestamp
        
        return cell
    }
    
    //MARK: - Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        let row: Currency = data[section]
        return row.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"HisDetailCell") as! HisDetailTableViewCell
        
        let sec: Currency = data[indexPath.section]
        let objDetail: Detail_Currency = sec.data[indexPath.row]
        
        cell.symbolLabel.text = objDetail.code
        cell.priceLabel.text   = objDetail.rate
        
        return cell
    }
    
}
