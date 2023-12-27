//
//  CarDetailsController.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//

import UIKit
import SnapKit

//MARK: - Literals enum
private enum Constants {
    static let carImageHeight: CGFloat = 200
    static let imageSideOffset: CGFloat = 32
    static let headlineLabelOffset: CGFloat = 16
    static let infoLabelOffset: CGFloat = 32
    static let interLabelsSpacing: CGFloat = 8
}

//MARK: - CarDetailsController
final class CarDetailsController: UIViewController {

    //MARK: UI elements
    private let carImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let ingridientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Ingridients:"
        return label
    }()
    
    private let ingredientsInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Here has to be whole lotta information about ingridients, but I'm just too lazy to do that :-( "
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Instructions:"
        return label
    }()
    
    private let instructionsInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Here has to be whole lotta instructions, but again, I'm just too lazy to do that :-( "
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
   
    
    //MARK: Constructor
    init(forCar car: Car) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: Targets
    @objc private func editTapped() {
        
    }
    
}

//MARK: - UI setup extension
private extension CarDetailsController {
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem = editButton
        view.backgroundColor = AppearenceManager.shared.backgroundColor
        setupCarImage()
        setupIngridientsLabel()
        setupIngridientsInfo()
        setupInstructionsLabel()
        setupInstructionsInfo()
    }
    
    func setupCarImage() {
        view.addSubview(carImage)
        carImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(Constants.imageSideOffset)
            make.trailing.equalToSuperview().inset(Constants.imageSideOffset)
            make.height.equalTo(Constants.carImageHeight)
        }
    }
    
    func setupIngridientsLabel() {
        view.addSubview(ingridientsLabel)
        ingridientsLabel.backgroundColor = AppearenceManager.shared.backgroundColor
        ingridientsLabel.textColor = AppearenceManager.shared.foregroundColor
        ingridientsLabel.snp.makeConstraints { make in
            make.top.equalTo(carImage.snp.bottom).offset(Constants.headlineLabelOffset)
            make.leading.equalToSuperview().offset(Constants.headlineLabelOffset)
        }
    }
    
    func setupIngridientsInfo() {
        view.addSubview(ingredientsInfo)
        ingredientsInfo.backgroundColor = AppearenceManager.shared.backgroundColor
        ingredientsInfo.textColor = AppearenceManager.shared.foregroundColor
        ingredientsInfo.snp.makeConstraints { make in
            make.top.equalTo(ingridientsLabel.snp.bottom).offset(Constants.interLabelsSpacing)
            make.leading.equalToSuperview().offset(Constants.infoLabelOffset)
            make.trailing.equalToSuperview().inset(Constants.infoLabelOffset)
        }
    }
    
    func setupInstructionsLabel() {
        view.addSubview(instructionsLabel)
        instructionsLabel.backgroundColor = AppearenceManager.shared.backgroundColor
        instructionsLabel.textColor = AppearenceManager.shared.foregroundColor
        instructionsLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsInfo.snp.bottom).offset(Constants.headlineLabelOffset)
            make.leading.equalToSuperview().offset(Constants.headlineLabelOffset)
        }
    }
    
    func setupInstructionsInfo() {
        view.addSubview(instructionsInfo)
        instructionsInfo.backgroundColor = AppearenceManager.shared.backgroundColor
        instructionsInfo.textColor = AppearenceManager.shared.foregroundColor
        instructionsInfo.snp.makeConstraints { make in
            make.top.equalTo(instructionsLabel.snp.bottom).offset(Constants.interLabelsSpacing)
            make.leading.equalToSuperview().offset(Constants.infoLabelOffset)
            make.trailing.equalToSuperview().inset(Constants.infoLabelOffset)
        }
    }
}
