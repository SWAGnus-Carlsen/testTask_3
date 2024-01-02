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
    static let colorViewSize: CGFloat = 50
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
    
    private let modelLabel = CarDeatailsUIBuilder.createHeaderLabel(withText: "Model")

    
    private let modelInfo = CarDeatailsUIBuilder.createInfoLabel(
        withText: "Here has to be whole lotta information about model"
    )
    
    private let producerLabel = CarDeatailsUIBuilder.createHeaderLabel(withText: "Producer")
    
    private let producerInfo = CarDeatailsUIBuilder.createInfoLabel(
        withText: "Here has to be whole lotta information about producer"
    )
    
    private let yearLabel = CarDeatailsUIBuilder.createHeaderLabel(withText: "Year")
    
    private let yearInfo = CarDeatailsUIBuilder.createInfoLabel(
        withText: "Here has to be whole lotta information about the year of creation"
    )
    
    private let colorLabel = CarDeatailsUIBuilder.createHeaderLabel(withText: "Color")
    
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppearenceManager.shared.foregroundColor
        view.isUserInteractionEnabled = false
        return view
    }()
   
    
    //MARK: Constructor
    init(forCar car: Car) {
        super.init(nibName: nil, bundle: nil)
        setupView(withCarData: car)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorViewDidPressed(_:)))
        colorView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Override methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            colorView.isUserInteractionEnabled = true
            
        } else {
            
        }
    }
    
    //MARK: Private Methods
    private func setupView(withCarData car: Car) {
        carImage.image = car.picture
        modelInfo.text = car.model
        producerInfo.text = car.producer
        yearInfo.text = car.year.description
        colorView.backgroundColor = car.color
    }
    
    
    //MARK: Targets
    
    @objc private func colorViewDidPressed(_ gesture: UITapGestureRecognizer) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    
}

//MARK: - UI setup
private extension CarDetailsController {
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = editButtonItem
        view.backgroundColor = AppearenceManager.shared.backgroundColor
        setupCarImage()
        setupModelLabel()
        setupModelInfo()
        setupProducerLabel()
        setupProducerInfo()
        setupYearLabel()
        setupYearInfo()
        setupColorLabel()
        setupColorView()
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
    
    func setupModelLabel() {
        view.addSubview(modelLabel)
        modelLabel.backgroundColor = AppearenceManager.shared.backgroundColor
        modelLabel.textColor = AppearenceManager.shared.foregroundColor
        modelLabel.snp.makeConstraints { make in
            make.top.equalTo(carImage.snp.bottom).offset(Constants.headlineLabelOffset)
            make.leading.equalToSuperview().offset(Constants.headlineLabelOffset)
        }
    }
    
    func setupModelInfo() {
        view.addSubview(modelInfo)
        modelInfo.backgroundColor = AppearenceManager.shared.backgroundColor
        modelInfo.textColor = AppearenceManager.shared.foregroundColor
        modelInfo.snp.makeConstraints { make in
            make.top.equalTo(modelLabel.snp.bottom).offset(Constants.interLabelsSpacing)
            make.leading.equalToSuperview().offset(Constants.infoLabelOffset)
            make.trailing.equalToSuperview().inset(Constants.infoLabelOffset)
        }
    }
    
    func setupProducerLabel() {
        view.addSubview(producerLabel)
        producerLabel.backgroundColor = AppearenceManager.shared.backgroundColor
        producerLabel.textColor = AppearenceManager.shared.foregroundColor
        producerLabel.snp.makeConstraints { make in
            make.top.equalTo(modelInfo.snp.bottom).offset(Constants.headlineLabelOffset)
            make.leading.equalToSuperview().offset(Constants.headlineLabelOffset)
        }
    }
    
    func setupProducerInfo() {
        view.addSubview(producerInfo)
        producerInfo.backgroundColor = AppearenceManager.shared.backgroundColor
        producerInfo.textColor = AppearenceManager.shared.foregroundColor
        producerInfo.snp.makeConstraints { make in
            make.top.equalTo(producerLabel.snp.bottom).offset(Constants.interLabelsSpacing)
            make.leading.equalToSuperview().offset(Constants.infoLabelOffset)
            make.trailing.equalToSuperview().inset(Constants.infoLabelOffset)
        }
    }
    
    func setupYearLabel() {
        view.addSubview(yearLabel)
        yearLabel.backgroundColor = AppearenceManager.shared.backgroundColor
        yearLabel.textColor = AppearenceManager.shared.foregroundColor
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(producerInfo.snp.bottom).offset(Constants.headlineLabelOffset)
            make.leading.equalToSuperview().offset(Constants.headlineLabelOffset)
        }
    }
    
    func setupYearInfo() {
        view.addSubview(yearInfo)
        yearInfo.backgroundColor = AppearenceManager.shared.backgroundColor
        yearInfo.textColor = AppearenceManager.shared.foregroundColor
        yearInfo.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(Constants.interLabelsSpacing)
            make.leading.equalToSuperview().offset(Constants.infoLabelOffset)
            make.trailing.equalToSuperview().inset(Constants.infoLabelOffset)
        }
    }
    
    func setupColorLabel() {
        view.addSubview(colorLabel)
        colorLabel.backgroundColor = AppearenceManager.shared.backgroundColor
        colorLabel.textColor = AppearenceManager.shared.foregroundColor
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(yearInfo.snp.bottom).offset(Constants.headlineLabelOffset)
            make.leading.equalToSuperview().offset(Constants.headlineLabelOffset)
        }
    }
    
    func setupColorView() {
        view.addSubview(colorView)
        
        colorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.infoLabelOffset)
            make.top.equalTo(colorLabel.snp.bottom).offset(Constants.interLabelsSpacing)
            make.height.width.equalTo(Constants.colorViewSize)
        }
        colorView.layer.cornerRadius = Constants.colorViewSize / 8
        colorView.layer.borderWidth = 3
        colorView.layer.borderColor = AppearenceManager.shared.foregroundColor.cgColor
    }
    
}

//MARK: - ColorPickerDelegate
extension CarDetailsController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ colorPicker: UIColorPickerViewController) {
        let color = colorPicker.selectedColor
        colorView.backgroundColor = color
    }
}
