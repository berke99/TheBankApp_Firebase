//
//  GetMoneyVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 21.06.2024.
//

import UIKit
import FirebaseFirestore

class GetMoneyVC: UIViewController {
    
    //MARK: - UI Elements
    
    
    @IBOutlet weak var amountTextField: UITextField!
    
    var userID: String?
    var documentAccountID: String?
    var db = Firestore.firestore()
    
    //MARK: - Properties
    
    

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("GetMoneyVC - User ID: \(userID ?? "GetMoneyVC - No User ID")")
        print("GetMoneyVC - Document Account ID: \(documentAccountID ?? "GetMoneyVC - No Document ID")")

    }
    //MARK: - Functions
    
    
    func withdrawMoney(amount: Double) {
            guard let userID = userID, let documentAccountID = documentAccountID else {
                print("Error: userID or documentAccountID is nil")
                return
            }
            
            let accountRef = db.collection("Users").document(userID).collection("Accounts").document(documentAccountID)
            
            accountRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data(), let currentAmount = data["amount"] as? Double {
                        let newAmount = currentAmount - amount
                        
                        accountRef.updateData([
                            "amount": newAmount
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated with new amount: \(newAmount)")
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }

    
    
    
    //MARK: - Actions
    
    /// Firebase Banka Hesabına Para Çeker
    @IBAction func withdrawButtonTapped(_ sender: Any) {
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            print("Invalid amount entered")
            return
        }
        
        withdrawMoney(amount: amount)
        navigationController?.popViewController(animated: true)
    }
    
}
