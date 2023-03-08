//
//  PictureListViewController.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import UIKit
import SnapKit

class PictureViewController: UIViewController {
    
    private let picListTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "Picture List"
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(PictureCell.self, forCellReuseIdentifier: "PictureCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel = PictureViewModel()
    private var pictures: [Picture] = []
    private var currentPage = 1
    private var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.isNavigationBarHidden = true
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubviews([picListTitle, logoutButton, tableView])
        
        configureConstraints()
        
        fetchPictures()
    }
    
    private func configureConstraints(){
        picListTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(picListTitle)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(picListTitle.snp.bottom).offset(24)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func fetchPictures() {
        isFetching = true
        viewModel.fetchPictures { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func logoutButtonTapped(){
        navigationController?.popToRootViewController(animated: true)
    }
}

extension PictureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pictures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
        
        let picture = viewModel.pictures[indexPath.row]
        cell.titleLabel.text = "Title: \(picture.title)"
        cell.idLabel.text = "ID: \(picture.id)"
        cell.thumbnail.image = nil
        cell.activityIndicator.startAnimating()
        
        viewModel.fetchImage(from: picture.url) { imageData in
            if let imageData = imageData {
                let image = UIImage(data: imageData)
                // Do something with the fetched image here
                cell.thumbnail.image = image
                cell.activityIndicator.stopAnimating()
            } else {
                // Handle error
                print("Error fetching picture data")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            viewModel.fetchPictures { error in
                if let error = error {
                    print(error)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}


