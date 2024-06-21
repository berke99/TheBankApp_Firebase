//
//  AccountVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 21.06.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AccountVC: UIViewController {

    //MARK: - UI Elements
        
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
        
    //MARK: - Properties
    
    var account: BankAccount?
    var userID: String? = Auth.auth().currentUser?.uid
    var documentAccountID: String?
    let db = Firestore.firestore()
    

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Document ID: \(documentAccountID ?? "No ID")")

        readAccountDetail()
    }
    //MARK: - Functions
        
    /// Hesap Bilgilerini Okur
    func readAccountDetail(){
        
        guard let userID = userID, let documentAccountID = documentAccountID else {
            print("Error: userID or documentAccountID is nil")
            return
        }

        
        db.collection("Users").document(userID).collection("Accounts").document(documentAccountID).getDocument { [weak self] (document, error) in
                    guard let strongSelf = self else { return }
                    
                    if let error = error {
                        print("Error fetching account details: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = document, document.exists {
                        let data = document.data()
                        if let accountType = data?["accountType"] as? String,
                           let currencyRawValue = data?["currency"] as? String,
                           let currency = Currency(rawValue: currencyRawValue),
                           let amount = data?["amount"] as? Double,
                           let iban = data?["iban"] as? Int {
                            
                            let account = BankAccount(accountType: accountType, currency: currency, amount: amount, iban: iban)
                            strongSelf.updateUI(with: account)
                        } else {
                            print("Document data is nil or cannot be parsed")
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
    }
    
    
    func updateUI(with account: BankAccount) {
        DispatchQueue.main.async { [weak self] in
            self?.accountTypeLabel.text = "\(account.accountType)"
            self?.amountLabel.text = "\(account.amount) \(account.currency.rawValue)"
            self?.ibanLabel.text = "iban: \(account.iban)"
        }
    }

    //MARK: - Actions

    /// Başka Hesaba Para Gönderir
    @IBAction func sendMoneyToAnotherAccountButtonTapped(_ sender: Any) {
        // id: toSendMoney
        
    }
    
    /// Para Çeker
    @IBAction func getMoneyButtonTapped(_ sender: Any) {
        // id: toGetMoney
        
    }
    
    /// Para Yatırır
    @IBAction func depositMoneyButtonTapped(_ sender: Any) {
        // id: toDepositMoney
        
    }
    
    
    
    

}