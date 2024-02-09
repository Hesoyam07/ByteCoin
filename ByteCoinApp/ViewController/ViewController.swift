//
//  ViewController.swift
//  ByteCoinApp
//
//  Created by Дмитрий on 08.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    //MARK: UI
    let label: UILabel = {
        let l = UILabel()
        l.text = "ByteCoin"
        return l
    }()
    let bitcoinImage: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(systemName: "bitcoinsign.circle.fill")
        return i
    }()
    let price: UILabel = {
        let l = UILabel()
        l.text = "..."
        return l
    }()
    let currency: UILabel = {
        let l = UILabel()
        l.text = "USD"
        return l
    }()
    let picker: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .clear
        return pv
    }()
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.backgroundColor = .lightGray
        sv.layer.cornerRadius = 10
        return sv
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        setPickerDelegate()
        setCoinManagerDelegate()
        setupView()
        setupStackView()
        setupConstraints()
    }
    
    //MARK: Methods
    
    func setupView() {
        [label,stackView,bitcoinImage, price, currency, picker].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    func setupStackView() {
        [bitcoinImage, price, currency].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 80),
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 90),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            bitcoinImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bitcoinImage.widthAnchor.constraint(equalToConstant: 80),
            bitcoinImage.topAnchor.constraint(equalTo: stackView.topAnchor),
            bitcoinImage.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            price.leadingAnchor.constraint(equalTo: bitcoinImage.trailingAnchor),
            price.topAnchor.constraint(equalTo: stackView.topAnchor),
            price.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            currency.leadingAnchor.constraint(equalTo: price.trailingAnchor),
            currency.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            currency.topAnchor.constraint(equalTo: stackView.topAnchor),
            currency.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            picker.heightAnchor.constraint(equalToConstant: 200),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func setCoinManagerDelegate() {
        coinManager.delegate = self
        
    }
    func setPickerDelegate() {
        picker.dataSource = self
        picker.delegate = self
    }
}
//MARK: PickerDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
        
    }
}
//MARK: PickerDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(coinManager.currencyArray[row])
        
        currency.text = coinManager.currencyArray[row]
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
//MARK: CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdatedPrice(rate: Float) {
        DispatchQueue.main.async {
            self.price.text = String(rate)
            
        }
    }
    func didFailWithError(error: Error?) {
        print(error)
    }
    
    
}
