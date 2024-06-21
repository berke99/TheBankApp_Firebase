//
//  MainVC.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainVC: UIViewController {
    
    //MARK: - UI Elements
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    //MARK: - Properties

    var userID: String? = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        readUserProfile()
    }
    //MARK: - Functions
    
    func readUserProfile(){
        guard let userID = userID else { return }
        
        db.collection("Users").document(userID).getDocument { [weak self] (documentSnapshot, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                        print("Error getting user profile: \(error.localizedDescription)")
                        return
            }

            guard let document = documentSnapshot, document.exists else {
                print("User profile document does not exist")
                return
            }
            
            let data = document.data()
            if let firstName = data?["firstName"] as? String,
               let lastName = data?["lastName"] as? String,
               let email = data?["email"] as? String,
               let mobilePhone = data?["mobilePhone"] as? String {
                // Kullanıcı profil bilgilerini kullanın
                print("User Profile: \(firstName) \(lastName), \(email), \(mobilePhone)")

                self!.updateUi(firstName: firstName, lastName: lastName, email: email, mobilePhone: mobilePhone)
                    
                // Burada kullanıcı profil bilgilerini UI'da güncelleyebilirsiniz
            } else {
                print("User profile data is incomplete or malformed")
            }

        }
    }
    
    
    func updateUi(firstName: String, lastName: String, email: String,mobilePhone: String ){
        nameLabel.text = "Ad Soyad:  \(firstName) \(lastName)"
        emailLabel.text = "Email:  \(email)"
        phoneLabel.text = "Phone Number:  \(mobilePhone)"
    }

    func navigateToLoginScreen() {
        performSegue(withIdentifier: "toSignInVC", sender: nil)
    }

    
    //MARK: - Actions

    

    @IBAction func logOutButtonTapped(_ sender: Any) {
                
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

    }
}
