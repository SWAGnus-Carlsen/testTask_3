//
//  CarCVCell.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//

import UIKit

final class CarCVCell: UICollectionViewCell {
    
    static let identifier = String(describing: CarCVCell.self)
    
    //MARK: UI Elements
    private let nameLabel: UILabel = {
        var label = UILabel ()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: Override variables
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor.red.cgColor
            } else {
                contentView.layer.borderColor = AppearenceManager.shared.foregroundColor.cgColor
            }
        }
    }
    
    //MARK: Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect (
            x: 0,
            y: 0,
            width: contentView.frame.size.width,
            height: contentView.frame.size.height * 2/3
        )
        nameLabel.frame = CGRect (
            x: 0,
            y: imageView.frame.maxY,
            width: contentView.frame.size.width,
            height: contentView.frame.size.height * 1/3
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        contentView.layer.borderColor = AppearenceManager.shared.foregroundColor.cgColor
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Custom methods declaration
    public func configure(
        withCar car: Car
    ) {
        imageView.image = car.picture
        nameLabel.text = car.model
    }
    
    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
        contentView.backgroundColor = AppearenceManager.shared.backgroundColor
        contentView.layer.borderColor = AppearenceManager.shared.foregroundColor.cgColor
        contentView.layer.borderWidth = 3
        nameLabel.textColor = AppearenceManager.shared.foregroundColor
        contentView.layer.cornerRadius = contentView.frame.height / 8
        contentView.clipsToBounds = true
    }
    
   
}
