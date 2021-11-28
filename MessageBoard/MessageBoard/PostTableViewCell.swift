//
//  PostTableViewCell.swift
//  MessageBoard
//
//  Created by angel zambrano on 11/28/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let hashedPosterLabel = UILabel()
    let timestampLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        bodyLabel.font = UIFont.systemFont(ofSize: 15)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bodyLabel)
        
        hashedPosterLabel.font = UIFont.systemFont(ofSize: 10)
        hashedPosterLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hashedPosterLabel)
        
        timestampLabel.font = UIFont.systemFont(ofSize: 10)
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestampLabel)
    }
    
    func setupConstraints() {
        let topPadding: CGFloat = 15.0
        let sidePadding: CGFloat = 50.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topPadding),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding)
        ])
        
        NSLayoutConstraint.activate([
            hashedPosterLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: topPadding),
            hashedPosterLabel.leadingAnchor.constraint(equalTo: bodyLabel.leadingAnchor),
            hashedPosterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: hashedPosterLabel.bottomAnchor, constant: topPadding),
            timestampLabel.leadingAnchor.constraint(equalTo: hashedPosterLabel.leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timestampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with postObject: Post) {
        titleLabel.text = postObject.title
        bodyLabel.text = postObject.body
        hashedPosterLabel.text = postObject.hashedPoster
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        if let date = dateFormatter.date(from: postObject.timestamp) {
            dateFormatter.dateFormat = "E, d MMM yyyy h:mm a"
            timestampLabel.text = "Posted on \(dateFormatter.string(from: date)) (EST)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
