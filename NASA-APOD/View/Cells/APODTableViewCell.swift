//
//  APODTableViewCell.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import UIKit
import Kingfisher

class APODTableViewCell: UITableViewCell {
    static let reuseIdentifier = "APODTableViewCell"
    
    let photoImageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = ColorManager.secondaryBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        titleLabel.textColor = ColorManager.primaryText
        dateLabel.textColor = ColorManager.secondaryText
        
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.backgroundColor = .systemGray5
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
        dateLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        
        let mainStackView = UIStackView(arrangedSubviews: [photoImageView, textStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            photoImageView.widthAnchor.constraint(equalToConstant: 80),
            photoImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with apod: APOD) {
        titleLabel.text = apod.title
        dateLabel.text = apod.date
        
        let url = URL(string: apod.url)
        let placeholder = UIImage(systemName: "photo")
        let processor = DownsamplingImageProcessor(size: CGSize(width: 160, height: 160))
        
        photoImageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2))
            ])
    }
}
