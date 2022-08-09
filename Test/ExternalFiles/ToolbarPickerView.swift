//
//  ToolbarPickerView.swift
//  Test
//
//  Created by PC on 05/07/22.
//

import Foundation
import UIKit

protocol ToolbarPickerViewDelegate: AnyObject {
    func didTapDone(pickerview: UIPickerView)
    func didTapCancel(pickerview: UIPickerView)
}

class ToolbarPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone(pickerview: self)
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel(pickerview: self)
    }
}

// MARK: - USE UIPickerViewDataSource, UIPickerViewDelegate
/*
extension RodeTaxVC: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate, UITextFieldDelegate {
    
    func setupCountryPickerview() {
        txtCountry.inputView = countryPickerView
        txtCountry.inputAccessoryView = countryPickerView.toolbar
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.toolbarDelegate = self
        countryPickerView.reloadAllComponents()
    }
    
    func reloadPickerviewData() {
        var selectedCountryIndex = 0
        if selectedCountry == nil {
            selectedCountryIndex = arrCountryNames.firstIndex(where: {$0.name  == "România" || $0.name == "Romania"}) ?? 0
        } else {
            selectedCountryIndex = arrCountryNames.firstIndex(where: {$0.name  == selectedCountry?.name}) ?? 0
        }
        countryPickerView.selectRow(selectedCountryIndex, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCountryNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrCountryNames.get(at: row)?.getCountryNameWithFlag()
    }
 
    func didTapDone(pickerview: UIPickerView) {
        let row = self.countryPickerView.selectedRow(inComponent: 0)
        selectedCountry = self.arrCountryNames.get(at: row)
        self.txtCountry.text = self.arrCountryNames.get(at: row)?.getCountryNameWithFlag()
        if txtLicencePlate.text != "" { lincenceTextChnage() }
        view.endEditing(true)
    }
    
    func didTapCancel(pickerview: UIPickerView) {
        view.endEditing(true)
    }
    

}
 */
