//
//  AdminViewController.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import UIKit
import SnapKit

class UserListViewController: UIViewController {
    
    let userViewModel = UserViewModel()
    var users: [User] = []
    
    private let userListTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "User List"
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        refreshUserList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Add targets
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Layout subviews
        
        view.addSubviews([userListTitle, logoutButton, tableView])
    
        configureConstraints()
    }
    
    func configureConstraints(){
        userListTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(userListTitle)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userListTitle.snp.bottom).offset(24)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func refreshUserList(){
        tableView.dataSource = self
        tableView.delegate = self
        
        userViewModel.fetchAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                // Do something with the fetched users
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                // Handle the error
                print("Failed to fetch users: \(error)")
            }
        }
    }
    
    @objc func logoutButtonTapped(){
        navigationController?.popToRootViewController(animated: true)
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UserCell")
        }
        
        let currUser = users[indexPath.row]
        cell!.textLabel?.text = currUser.username
        cell!.detailTextLabel?.text = "ID: \(currUser.id)"

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UserDetailViewController()
        controller.user = users[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
