//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Victor Proppe on 10/12/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner: JGProgressHUD = JGProgressHUD(style: .dark)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = "Email address"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.returnKeyType = .continue
        return field
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = "First name"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.returnKeyType = .continue
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = "Last name"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.returnKeyType = .continue
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.returnKeyType = .done
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func registerButtonTapped() {
        
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstNameField.text, !firstName.isEmpty else {
            alertUserLoginError()
            return
        }
        guard let lastName = lastNameField.text, !lastName.isEmpty else {
            alertUserLoginError()
            return
        }
        guard let email = emailField.text, !email.isEmpty else {
            alertUserLoginError()
            return
        }
        guard let password = passwordField.text, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        //Firebase Sign-up
        
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] isUserExists in
            
            guard let strongSelf = self else {return}
            
            guard !isUserExists else {
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }
            
            strongSelf.spinner.show(in: strongSelf.view)
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
                
                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss(animated: true)
                }
                
                guard authResult != nil, error == nil else {
                    print("Error creating user \(String(describing: error?.localizedDescription))")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                
                strongSelf.navigationController?.dismiss(animated: true)
                
            }
        })
        
    }
    
    private func alertUserLoginError(message: String = "Please enter all information to register")  {
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gestureDetector = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        
        imageView.addGestureRecognizer(gestureDetector)
        
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.frame
        let size = scrollView.width / 3
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        
        
        imageView.layer.cornerRadius = imageView.width / 2.0
        
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 53)
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom + 10, width: scrollView.width - 60, height: 53)
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom + 10, width: scrollView.width - 60, height: 53)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 53)
        registerButton.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: scrollView.width - 60, height: 53)
    }

}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField) {
        case firstNameField:
            lastNameField.becomeFirstResponder()
            break
        case lastNameField:
            emailField.becomeFirstResponder()
            break
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            registerButtonTapped()
            break
        default:
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.imageView.image = selectedImage
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
