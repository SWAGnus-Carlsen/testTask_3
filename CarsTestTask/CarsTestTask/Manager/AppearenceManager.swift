//
//  AppearenceManager.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//

import UIKit


final class AppearenceManager : NSObject {
    
    //MARK: Singleton
    static let shared = AppearenceManager()
    
    //MARK: Constructor
    private override init(){ }
    
    //MARK: Colors
    public var backgroundColor: UIColor = UIColor(named: "BackGround") ?? .black
    public var foregroundColor: UIColor = UIColor(named: "ForeGround") ?? .white
    
    //MARK: Images
    public func carImage(withNumber number: Int) -> UIImage {
        return UIImage()
    }
}
