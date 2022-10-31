//
//  MainCurrencyViewController.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/29/22.
//

import UIKit
import DropDown

class MainCurrencyViewController: UIViewController {
    
    @IBOutlet weak var usdStaticLabel: UILabel! {
        didSet {
            usdStaticLabel.text = "USD"
        }
    }
    
    @IBOutlet weak var gbpStaticLabel: UILabel!{
        didSet {
            gbpStaticLabel.text = "GBP"
        }
    }
    
    @IBOutlet weak var eurStaticLabel: UILabel!{
        didSet {
            eurStaticLabel.text = "EUR"
        }
    }
    
    @IBOutlet weak var usdStackView: UIStackView!
    @IBOutlet weak var gbpStackView: UIStackView!
    @IBOutlet weak var eurStackView: UIStackView!
    
    @IBOutlet weak var usdPriceLabel: UILabel!
    @IBOutlet weak var gbpPriceLabel: UILabel!
    @IBOutlet weak var eurPriceLabel: UILabel!
    
    @IBOutlet weak var selectCoinButton: UIButton! {
        didSet {
            selectCoinButton.setTitle("Select Coin", for: .normal)
        }
    }
    @IBOutlet weak var quantityTextField: UITextField! {
        didSet {
            quantityTextField.keyboardType = .decimalPad
            quantityTextField.delegate = self
        }
    }
    
    @IBOutlet weak var currencyConvertLabel: UILabel! {
        didSet {
            currencyConvertLabel.text = ""
        }
    }
    
    @IBOutlet weak var historyCurrencyPriceButton: UIButton! {
        didSet {
            historyCurrencyPriceButton.setTitle("History", for: .normal)
        }
    }
    
    var viewModel = MainCurrencyViewModel()
    var data: CurrencyResponseModel.CurrencyPrice?
    var priceSelectCurrent: Float = 0.0
    var typeSelectCurrent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.currencyPriceSuccessCallback = { [weak self] response in
            guard let self = self else { return }
            self.data = response
            self.usdPriceLabel.text = response.bpi.usd.rate
            self.gbpPriceLabel.text = response.bpi.gbp.rate
            self.eurPriceLabel.text = response.bpi.eur.rate
        }
        
        viewModel.currencyConvertSuccessCallback = { [weak self] response in
            guard let self = self else { return }
            self.currencyConvertLabel.text = response
        }
        
        viewModel.getCurrencyPrice()
        
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(intervalData), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Interval Keep Data 1 Min
    @objc func intervalData() {
        viewModel.getCurrencyPrice()
    }
    
    //MARK: - Action
    @IBAction func pressHistory(_ sender: Any) {
        let history = HistoryCurrencyViewController()
        present(history, animated: true)
    }
    
    @IBAction func selectCoin(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.dataSource = ["USD","GBP","EUR"]
        dropDown.accessibilityElements = [data?.bpi.usd.rateFloat ?? 0.0,data?.bpi.gbp.rateFloat ?? 0.0,data?.bpi.eur.rateFloat ?? 0.0]
        dropDown.anchorView = selectCoinButton
        dropDown.bottomOffset = CGPoint(x: 0, y: selectCoinButton.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self,
            let value = dropDown.accessibilityElements?[index] else {return}
            
            self.selectCoinButton.setTitle(item, for: .normal)
            self.priceSelectCurrent = value as! Float
            self.typeSelectCurrent = item
            
            let quantity = Float(self.quantityTextField.text ?? "0.0") ?? 0.0
            self.viewModel.convertCurrency(quantity:quantity, typeSelect: item, priceSelect: value as! Float)
        }
    }
    
}

//MARK: - UI TextField Delegate
extension MainCurrencyViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let _ = updatedText == "" ? self.currencyConvertLabel.text = "" : viewModel.convertCurrency(quantity: Float(updatedText) ?? 0, typeSelect: self.typeSelectCurrent, priceSelect:self.priceSelectCurrent)
        }
        return true
    }
}
