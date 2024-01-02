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
    static let colorViewBorderWidth: CGFloat = 3
    static let minimumInfoLabelHeight: CGFloat = 30
}

//MARK: - CarDetailsController
final class CarDetailsController: UIViewController {

    //MARK: UI elements
    private let carImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let modelLabel = CarDeatailsUIBuilder.createHeaderLabel(withText: "Model")

    
    private let modelInfo = CarDeatailsUIBuilder.createInfoLabel(
        withText: "Default model"
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
   
    //MARK: Properties
    let passedCar: Car
    var isNewEntityCreating: Bool = false
    
    //MARK: Constructor
    init(forCar car: Car) {
        passedCar = car
        super.init(nibName: nil, bundle: nil)
        
        if car.model != nil {
            setupView(withCarData: car)
        } else {
            isEditing = true
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        assignGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard self.isMovingFromParent else { return }
        onDissapearCarInfoSave()
        CoreDataManager.shared.saveContext()
        
    }
    //MARK: Override methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            view.subviews.forEach {
                $0.isUserInteractionEnabled = true
            }
        } else {
            view.subviews.forEach {
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    //MARK: Private Methods

    private func onDissapearCarInfoSave() {
        passedCar.model = modelInfo.text
        passedCar.producer = producerInfo.text
        passedCar.year = Int16(Int(yearInfo.text ?? "") ?? 0)
        passedCar.picture = carImage.image
        passedCar.color = colorView.backgroundColor
    }
    
    private func showImagePicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func showAlertForEditing(label: UILabel) {
        let alert = UIAlertController(title: "Editing", message: "Here you can type whatever you want", preferredStyle: .alert)
        alert.addTextField()
        if label == yearInfo {
            // it makes only numeric textField for year textField
            alert.textFields?.first?.delegate = self
        }
        alert.textFields?.first?.text = label.text
        alert.addAction(UIAlertAction(title: "Save", style: .default) {_ in
            label.text = alert.textFields?.first?.text
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
    
    //MARK: Targets
    @objc private func colorViewDidPressed(_ gesture: UITapGestureRecognizer) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    
    @objc private func didPressImage(_ gesture: UITapGestureRecognizer) {
        showImagePicker()
    }
    
    @objc private func didPressLabel(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel else { return }
        showAlertForEditing(label: tappedLabel)
    }
    
    @objc func backButtonTapped() {
        
        navigationController?.popViewController(animated: true)
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
            make.height.greaterThanOrEqualTo(Constants.minimumInfoLabelHeight)
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
            make.height.greaterThanOrEqualTo(Constants.minimumInfoLabelHeight)
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
            make.height.greaterThanOrEqualTo(Constants.minimumInfoLabelHeight)
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
        colorView.layer.borderWidth = Constants.colorViewBorderWidth
        colorView.layer.borderColor = AppearenceManager.shared.foregroundColor.cgColor
    }
    
    func setupView(withCarData car: Car) {
        carImage.image = car.picture
        modelInfo.text = car.model
        producerInfo.text = car.producer
        yearInfo.text = car.year.description
        colorView.backgroundColor = car.color
    }
    
}

//MARK: - UI Functionality
private extension CarDetailsController {
    func assignGestures() {
        let colorViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorViewDidPressed(_:)))
        colorView.addGestureRecognizer(colorViewTapGesture)
        
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressImage(_:)))
        carImage.addGestureRecognizer(imageViewTapGesture)
        
        ///somehow it doesn't work with one tap gesture. If i'll assign one gesture for all labels only last will work
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressLabel(_:)))
        let label2TapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressLabel(_:)))
        let label3TapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressLabel(_:)))

        modelInfo.addGestureRecognizer(labelTapGesture)
        producerInfo.addGestureRecognizer(label2TapGesture)
        yearInfo.addGestureRecognizer(label3TapGesture)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.backBarButtonItem = backButton
        
    }
}

//MARK: - TextFieldDelegate
extension CarDetailsController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let pattern = "^[0-9]*$"
           if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
               let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))

               return matches.count > 0 || string.isEmpty
           }

           return false
       }
}

//MARK: - ColorPickerDelegate
extension CarDetailsController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ colorPicker: UIColorPickerViewController) {
        let color = colorPicker.selectedColor
        colorView.backgroundColor = color
    }
}

//MARK: - ImagePickerDelegate
extension CarDetailsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            carImage.image = image
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
