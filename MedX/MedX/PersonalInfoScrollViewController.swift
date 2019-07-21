//
//  PersonalInfoScrollView.swift
//  MedX
//
//  Created by Harry Wei on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class PersonalInfoScrollViewController:UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var PreferredHospitalList: UITextView!
    
    @IBOutlet weak var txtDatePicker: UITextField!
    
    @IBOutlet weak var GenderField: UITextField!
    
    @IBOutlet weak var BloodTypeField: UITextField!
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    var genderType:[String] = []
    var bloodType:[String] = []
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.5836969018, green: 0.7517433167, blue: 0.8807654977, alpha: 1)
        genderType = ["Male", "Female"]
        bloodType = ["A-positive", "A-negative", "B-positive", "B-negative", "AB-positive", "AB-negative", "O-positive", "O-negative"]
        
        showDatePicker()
        
        PreferredHospitalList!.layer.borderWidth = 1
        PreferredHospitalList!.layer.borderColor = UIColor.black.cgColor
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == GenderField{
            return genderType.count
        } else if currentTextField == BloodTypeField{
            return bloodType.count
        } else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == GenderField{
            return genderType[row]
        } else if currentTextField == BloodTypeField{
            return bloodType[row]
        } else{
            return " "
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == GenderField{
            GenderField.text = genderType[row]
            self.view.endEditing(true)
        } else if currentTextField == BloodTypeField{
           BloodTypeField.text = bloodType[row]
            self.view.endEditing(true)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == GenderField {
            currentTextField.inputView = pickerView
        } else if currentTextField == BloodTypeField {
            currentTextField.inputView = pickerView
        }
    }

    
    @IBAction func backToFrontPageView(_ sender: Any) {
        print("Back button clicked")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
