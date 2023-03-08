//
//  PictureCell.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import UIKit
import SnapKit

class PictureCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    var thumbnail = UIImageView()
    
    var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "TaskListCell")
        
        backgroundColor = .systemBackground
        
        addSubviews([thumbnail, titleLabel, idLabel])
    
        configureConstraints()
    }
    
    private func configureConstraints(){
        thumbnail.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnail.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(thumbnail.snp.right).offset(20)
        }
        
        idLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnail.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        thumbnail.image = nil
        titleLabel.text = nil
        idLabel.text = nil
    }
}
