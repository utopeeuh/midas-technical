//
//  SigninViewController.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import UIKit
import SnapKit

class SigninViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter email here..."
        textfield.font = .systemFont(ofSize: 18)
        textfield.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    private var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "Enter password here..."
        textfield.font = .systemFont(ofSize: 18)
        textfield.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    // MARK: - Page Setup
    
    var viewModel = AuthViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Sign-in"
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
        
        // Add subviews
        verticalStack.addArrangedSubviews([emailLabel, emailTextField, passwordLabel, passwordTextField])
        view.addSubviews([verticalStack, submitButton, signupButton])
        
        // Setup constraints
        configureConstraints()
    }
    
    private func configureConstraints(){
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStack.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
        }
        
        signupButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(submitButton.snp.bottom).offset(32)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    @objc func goToSignup(){
        self.navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
    @objc func submitButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Handle error
            return
        }
        
        viewModel.signIn(with: email, password: password) { [weak self] success, error, controller in
            guard let self = self else { return }
            
            let alertController = UIAlertController(title: "Alert", message: "Alert message goes here.", preferredStyle: .alert)

            
            if success {
                // Handle successful sign-in
                alertController.message = "Success"
                if let controller = controller {
                    self.navigationController?.pushViewController(controller, animated: true)
                    return
                }
            }
            else {
                if let error = error {
                    // Handle sign-in error
                    alertController.message = "Sign in error: \(error)"
                }
                else {
                    // Handle unknown error
                    alertController.message = "Unknown error"
                }
            }
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}





