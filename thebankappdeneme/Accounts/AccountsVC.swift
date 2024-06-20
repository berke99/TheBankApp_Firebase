//
//  AccountsVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties

    var userID: String? = Auth.auth().currentUser?.uid
    var userAccounts: [BankAccount] = []
    
    let db = Firestore.firestore()

    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        readUserAccounts()
        
    }
    //MARK: - Functions
    
    func readUserAccounts(){
        guard let userID = userID else { return }
        
        db.collection("Users").document(userID).collection("Accounts").getDocuments { [weak self] (querySnapshot, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error getting user accounts: \(error.localizedDescription)")
                return
            }
            
            strongSelf.userAccounts.removeAll()
            
            for document in querySnapshot!.documents {
                let data = document.data()
                if let accountType = data["accountType"] as? String,
                   let currencyRawValue = data["currency"] as? String,
                   let currency = Currency(rawValue: currencyRawValue),
                   let amount = data["amount"] as? Double,
                   let iban = data["iban"] as? Int { // Burayı uygun veri türüne göre güncelleyin

                   let account = BankAccount(accountType: accountType, currency: currency, amount: amount, iban: iban)
                   strongSelf.userAccounts.append(account)
                }
            }
            
            strongSelf.tableView.reloadData()

            
        }// firebase db.collection
    }
    
    
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountsCell")!
        let account = userAccounts[indexPath.row]
        cell.textLabel?.text = account.accountType
        cell.detailTextLabel?.text = "\(account.amount) \(account.currency.rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Actions
    
    
    @IBAction func createNewAccount(_ sender: Any) {
    
        
        
    }
    

}
