//
//  ViewController.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import UIKit
import SnapKit

class SignupViewController: UIViewController {
    
    // MARK: - UI Elements

    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
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
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "User Type"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private var usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter username here..."
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
    
    private var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter email here..."
        textfield.font = .systemFont(ofSize: 18)
        textfield.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    private var userTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        segmentedControl.insertSegment(withTitle: "User", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Admin", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0

        return segmentedControl
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
    
    // MARK: - Page Setup
    
    var viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Sign-up"
        
        userTypeSegmentedControl.addTarget(self, action: #selector(userTypeChanged(_:)), for: .valueChanged)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        // Add subviews
        verticalStack.addArrangedSubviews([userLabel, usernameTextField, passwordLabel, passwordTextField, emailLabel,     emailTextField, typeLabel, userTypeSegmentedControl])
        view.addSubviews([verticalStack, submitButton])
        
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
    }
    
    @objc func userTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel.userType = .user
        } else {
            viewModel.userType = .admin
        }
    }
    
    @objc func submitButtonTapped() {
        
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        viewModel.username = username
        viewModel.email = email
        viewModel.password = password
        
        let alertController = UIAlertController(title: "Alert", message: "Alert message goes here.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        viewModel.saveUser() { error in
            if let error = error {
                // Handle the error
                alertController.message = "Error saving user: \(error.localizedDescription)"
                self.present(alertController, animated: true, completion: nil)
            } else {
                // User was saved successfully
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
            
}

