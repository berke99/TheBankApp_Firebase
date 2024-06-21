//
//  AccountViewModel.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 21.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class AccountViewModel{
    
    //MARK: - Properties
    
    let db = Firestore.firestore()
    var userID: String? = Auth.auth().currentUser?.uid
    var accountRef: DocumentReference?

    // MARK: - Functions

    func setAccountRef(accountID: String) {
        guard let userID = userID else {
            print("Error: User not authenticated.")
            return
        }
        accountRef = db.collection("Users").document(userID).collection("Accounts").document(accountID)
    }
    
    //MARK: - Deposit Money - Para Yükle
    
    func depositMoneyWithFirebase(amount: Double) {
        
    }
    
}
