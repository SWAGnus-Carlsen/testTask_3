//
//  MainPageController.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//

import UIKit
import SnapKit

//MARK: - Literals enum
private enum Constants {
    static let controllerTitle = "Cars"
    static let carsCollectionItemHeight: CGFloat = 200
    static let carsCollectionItemWidth: CGFloat = UIScreen.main.bounds.size.width / 2 - 16
    static let carsCollectionMinimumLineSpacing: CGFloat = 16
    static let carsCollectionMinimumInteritemSpacing: CGFloat = 16
    static let carsCollectionSideInset: CGFloat = 4
}

//MARK: - MainPageController
final class MainPageController: UIViewController {
    
    //MARK: UI Elements
    private lazy var carsCollectionView = UICollectionView()
    
    //MARK: Properties
    lazy var coreDataManager = CoreDataManager.shared
    private var cars = [Car]()
    {
        didSet {
            carsCollectionView.reloadData()
        }
    }
    
    private var indexToUpdate: Int?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionCheck()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carsCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cars = coreDataManager.getSavedData()
    }
    
    //MARK: Override methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
            navigationItem.leftBarButtonItems = [editButtonItem, deleteButton]
            navigationItem.rightBarButtonItem?.isHidden = true
            carsCollectionView.allowsMultipleSelection = true
            
        } else {
            navigationItem.leftBarButtonItems = [editButtonItem]
            navigationItem.rightBarButtonItem?.isHidden = false
            carsCollectionView.indexPathsForSelectedItems?.forEach({ indexPath in
                carsCollectionView.deselectItem(at: indexPath, animated: false)
            })
        }
    }
    
    //MARK: Private methods
    private func connectionCheck() {
        if NetworkMonitorManager.shared.isConnected {
            showInfoAlert(withTitle: "You're connected", withMessage: "Impressive! Your device is connected to the network!")
        } else {
            showInfoAlert(withTitle: "You're not connected :-(", withMessage: "Check your internet connection...")
        }
    }
    
    private func setDefaultData() {
        for _ in 0..<3 {
            let car = Car(context: coreDataManager.context)
            car.model = "BMW i8"
            car.color = .red
            car.picture = UIImage(named: "BMW")
            car.year = 2019
            car.producer = "Germany"
            
            cars.append(car)
        }
    }
    
    

    
    //MARK: Targets
    @objc func addTapped() {
        
        let car = Car(context: coreDataManager.context)
        let vc = CarDetailsController(forCar: car)
        navigationController?.pushViewController(vc, animated: true)
//        car.model = "Mercedes"
//        car.color = .gray
//        car.picture = UIImage(named: "MerenAMG")
//        car.year = 2018
//        car.producer = "Germany"
        
//        cars.append(car)
//        coreDataManager.saveContext()
    }
    
    @objc func deleteTapped() {
        let sortedSelectedCells = carsCollectionView.indexPathsForSelectedItems?.sorted(by: {
            $0.row > $1.row
        })
        sortedSelectedCells?.forEach({ indexPath in
            let carToRemove = cars[indexPath.row]
            do {
                try coreDataManager.delete(carToRemove)
                cars.remove(at: indexPath.row)
            }
            catch {
                print("Ooops... An error occured while attempting to delete: \(error.localizedDescription)")
            }
        })
       
        isEditing = false
        showInfoAlert(withTitle: "Delete button tapped", withMessage: "Fantastic!")
        
    }
    
    
}


//MARK: - UI setup extension
private extension MainPageController {
    func setupUI() {
        title = Constants.controllerTitle
        view.backgroundColor = AppearenceManager.shared.backgroundColor
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItems = [editButtonItem]
        
        setupCarsCollection()
    }
    
    
    func setupCarsCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: Constants.carsCollectionItemWidth,
                                 height: Constants.carsCollectionItemHeight)
        layout.minimumLineSpacing = Constants.carsCollectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.carsCollectionMinimumInteritemSpacing
        
        carsCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: layout)
        
        carsCollectionView.backgroundColor = AppearenceManager.shared.backgroundColor
        
        carsCollectionView.register(CarCVCell.self,
                                       forCellWithReuseIdentifier: CarCVCell.identifier)
        carsCollectionView.showsHorizontalScrollIndicator = false
        carsCollectionView.showsVerticalScrollIndicator = false
        
        
        view.addSubview(carsCollectionView)
        
        carsCollectionView.dataSource = self
        carsCollectionView.delegate = self
        
        carsCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.carsCollectionSideInset)
            $0.trailing.equalToSuperview().inset(Constants.carsCollectionSideInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - Collection data source
extension MainPageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cars.isEmpty {
            showInfoAlert(withTitle: "Ooops...", withMessage: "Your cars collection looks a bit empty ://")
        }
        return cars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard !cars.isEmpty,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCVCell.identifier, for: indexPath) as? CarCVCell else {
            return UICollectionViewCell()
        }
        let currentCar = cars[indexPath.row]
        cell.configure(
            withCar: currentCar
        )
        return cell
    }
    
    
}

//MARK: - Collection delegate
extension MainPageController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isEditing else { return }
        collectionView.deselectItem(at: indexPath, animated: false)
        let detailsVC = CarDetailsController(forCar: cars[indexPath.row])
       // detailsVC.delegate = self
        navigationController?.pushViewController(detailsVC, animated: true)
        indexToUpdate = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
}
