//
//  ViewController.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 18.06.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LogInViewController: UIViewController {

    //MARK: - UI Elements
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Properties
    
    var db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    //MARK: - Functions
    
    func makeAlert(title: String, message: String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func uyeOlButtonTapped(_ sender: Any) {
            
        guard let email = emailTextField.text, !email.isEmpty else {
            makeAlert(title: "Error", message: "Email field is empty")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            makeAlert(title: "Error", message: "Password field is empty")
            return
        }
        
        // guard let geçti nil ve error değil
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] (authResult, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                // Kullanıcı oluşturuldu ve diğer sayfaya geçiş yapacak
                guard let userId = authResult?.user.uid else {
                    print("Error: User ID not found")
                    return
                }
                
                let userRef = db.collection("User").document(userId)
                
                userRef.setData([
                    "email": email,
                    "user id": userId
                ]) { error in
                    if let error = error {
                        print("Error adding user document: \(error.localizedDescription)")
                        self.makeAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        // İlk banka hesabını start alt koleksiyonuna ekleyin
                        userRef.collection("Hesap").addDocument(data: [
                            "hesapName": "İlk Banka Hesabı",
                            "hesapMiktar": 10000,
                            "doviz": "tl"
                        ]) { error in
                            if let error = error {
                                print("Error adding start collection document: \(error.localizedDescription)")
                                self.makeAlert(title: "Error", message: error.localizedDescription)
                            } else {
                                // İşlem tamamlandı, diğer sayfaya geç
                                self.performSegue(withIdentifier: "toMainVC", sender: nil)
                            }
                        }
                    }
                }
            }
        }

        
    }
    
}
