//
//  UserDetailViewController.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import UIKit
import SnapKit

class UserDetailViewController: UIViewController {
    
    let userViewModel = UserViewModel()
    var user: User? {
        didSet {
            usernameTextField.text = user?.username
            emailTextField.text = user?.email
            userTypeSegmentedControl.selectedSegmentIndex = user?.userType == UserType.user.rawValue ? 0 : 1
            selectedType = user?.userType == UserType.user.rawValue ? .user : .admin
        }
    }
    private var selectedType: UserType?
    
    // MARK: - UI Elements

    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
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

        return segmentedControl
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private let verticalStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - Page Setup
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    var viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Update user"
        
        userTypeSegmentedControl.addTarget(self, action: #selector(userTypeChanged(_:)), for: .valueChanged)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // Add subviews
        verticalStack.addArrangedSubviews([userLabel, usernameTextField, emailLabel, emailTextField, typeLabel, userTypeSegmentedControl])
        view.addSubviews([verticalStack, updateButton, deleteButton])
        
        // Setup constraints
        configureConstraints()
    }
    
    private func configureConstraints(){
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStack.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(updateButton.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func userTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedType = .user
        } else {
            selectedType = .admin
        }
    }
    
    @objc func updateButtonTapped() {
        
        guard let username = usernameTextField.text, let email = emailTextField.text else { return }
        
        userViewModel.updateUser(with: user!.id, username: username, email: email, type: selectedType!) { [weak self] result in
            switch result {
            case .success:
                // Update successful, do something
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                // Update failed, handle error
                print("Error updating user: \(error)")
            }
        }
    }

    // Delete user
    @objc func deleteButtonTapped() {
        userViewModel.deleteUser(with: user!.id) { [weak self] result in
            switch result {
            case .success:
                // Deletion successful, do something
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                // Deletion failed, handle error
                print("Error deleting user: \(error)")
            }
        }
    }
}

