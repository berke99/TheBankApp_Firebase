//
//  AuthenticationViewModel.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel {
    
    //MARK: - Properties
    
    let db = Firestore.firestore()
    
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

    
    /// Firebase ile Kullanıcı Oluşturur
    func createUserAccount(firstName: String, lastName: String, email: String, mobilePhone: String, password: String) {
           Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   print("Error creating user: \(error.localizedDescription)")
                   return
               }
               
               guard let user = authResult?.user else { return }
               let userID = user.uid
               
               // Save additional user data in Firestore
               self.db.collection("Users").document(userID).setData([
                   "firstName": firstName,
                   "lastName": lastName,
                   "email": email,
                   "mobilePhone": mobilePhone
               ]) { error in
                   if let error = error {
                       print("Error saving user data: \(error.localizedDescription)")
                   } else {
                       print("User data successfully saved")
                       self.userFirstBankAccount(uid: userID)
                   }
               }
           }
       }
    
    /// İlk Kullanıcı Bilgilerini Kaydeder
    func userInfo(user: User, uid: String){
        
        let userDic: [String: Any] = [
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            "email" : user.email,
            "mobilePhone" : user.mobilePhone
        ]
        
        db.collection("Users").document(uid).setData(userDic) { error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("kullanıcı datası oluşturuldu")
                self.userFirstBankAccount(uid: uid)
            }
        }
        
    }
    
    /// Kullanıcı Oluşması Sonucunda İlk Banka Hesabının Oluşması
    func userFirstBankAccount(uid: String){
        let randomIban = generateRandomIban()
        let firstBankAccount = BankAccount(accountType: "İlk Hesap", currency: .tl, amount: 10000.00, iban: randomIban)
        
        let firstBankAccountData: [String: Any] = [
            "accountType": firstBankAccount.accountType,
            "currency": firstBankAccount.currency.rawValue,
            "amount": firstBankAccount.amount,
            "iban": firstBankAccount.iban
        ]
        
        let accountRef = db.collection("Users").document(uid).collection("Accounts").document(UUID().uuidString)
        
        accountRef.setData(firstBankAccountData) { error in
            if let error = error {
                print("Error setting document data: \(error)")
            } else {
                print("First account data set successfully")
                
            }
        }
        
    }
    
    /// Kullanıcı Sisteme Giriş Yapar
    func sigInFunc(email: String, password: String,completion: @escaping (Result<Bool, Error>) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] (authResult, error) in
            guard let _ = self else { return }
            if let error = error {
                print("Error logging in user: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("User logged in successfully.")
                completion(.success(true))
            }

        }
        
    }
    
    
    
    
}
