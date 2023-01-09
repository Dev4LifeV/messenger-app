//
//  ViewController.swift
//  Messenger
//
//  Created by Victor Proppe on 10/12/22.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

       validateAuth()
    }

    private func validateAuth() {

        if FirebaseAuth.Auth.auth().currentUser != nil {
            dismiss(animated: true)
        } else {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    

}

