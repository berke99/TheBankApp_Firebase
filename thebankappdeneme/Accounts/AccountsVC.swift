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
    var querySnapshot: QuerySnapshot?
    var selectedAccount: BankAccount?
    
    var documentVCID: String = ""
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        readUserAccounts()
        
    }
    //MARK: - Functions
    
    func readUserAccounts() {
        guard let userID = userID else { return }
        
        db.collection("Users").document(userID).collection("Accounts").addSnapshotListener { [weak self] (snapshot, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error getting user accounts: \(error.localizedDescription)")
                return
            }
            
            strongSelf.userAccounts.removeAll()
            strongSelf.querySnapshot = snapshot
            
            for document in snapshot!.documents {
                let data = document.data()
                if let accountType = data["accountType"] as? String,
                   let currencyRawValue = data["currency"] as? String,
                   let currency = Currency(rawValue: currencyRawValue),
                   let amount = data["amount"] as? Double,
                   let iban = data["iban"] as? Int {

                    let account = BankAccount(accountType: accountType, currency: currency, amount: amount, iban: iban)
                    strongSelf.userAccounts.append(account)
                }
            }
            
            strongSelf.tableView.reloadData()
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAccountDetail" {
            if let destinationVC = segue.destination as? AccountVC {
                destinationVC.account = selectedAccount
                destinationVC.documentAccountID = documentVCID
            }
        }
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
        selectedAccount = userAccounts[indexPath.row]
        
        
        if let documentID = querySnapshot?.documents[indexPath.row].documentID {
            //print("Selected Account ID: \(documentID)")
            documentVCID = documentID
        }
        
        
        performSegue(withIdentifier: "toAccountDetail", sender: nil)
        
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func createNewAccount(_ sender: Any) {
    
        performSegue(withIdentifier: "toNewAccountVC", sender: nil)
        
    }
    

}
