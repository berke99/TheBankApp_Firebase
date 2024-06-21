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


    
    //MARK: - Deposit Money - Para Yükle
    
    func depositMoneyWithFirebase(amount: Double) {
        
    }
    
}
