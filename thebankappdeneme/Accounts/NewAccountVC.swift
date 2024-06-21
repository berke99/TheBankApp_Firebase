//
//  NewAccountVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewAccountVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {


    //MARK: - UI Elements
  
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var accountTypeTextField: UITextField!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    
    //MARK: - Properties
    
    let db = Firestore.firestore()
    var selectedCurrency = Currency.tl

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self

    }
    
    //MARK: - Functions
    
    /// Rastgele 7 Karakterli iban Oluşturur
    func generateRandomIban() -> Int{
        var iban = ""
        
        for _ in 0..<7 {
            let digit = Int.random(in: 0...9)
            iban += "\(digit)"
        }
        
        return Int(iban)!
    }

    //MARK: - PickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currency.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currency.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = Currency.allCases[row]        
    }

    //MARK: - Actions


    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let amountText = amountTextField.text, !amountText.isEmpty,
              let accountTypeText = accountTypeTextField.text, !accountTypeText.isEmpty else {
            print("Amount or account type is empty")
            return
        }
        
        guard let amount = Double(amountText) else {
            print("Invalid amount value")
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let iban = generateRandomIban()
        
        let bankAccount = BankAccount(accountType: accountTypeText, currency: selectedCurrency, amount: amount, iban: iban)
        
        let accountData: [String: Any] = [
            "accountType": bankAccount.accountType,
            "currency": bankAccount.currency.rawValue,
            "amount": bankAccount.amount,
            "iban": bankAccount.iban
        ]
        
        db.collection("Users").document(userID).collection("Accounts").addDocument(data: accountData){ error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Account successfully created")
                self.amountTextField.text = ""
                self.accountTypeTextField.text = ""
                self.dismiss(animated: true)
            }
        }
        
        
    }
    
    
    
}
