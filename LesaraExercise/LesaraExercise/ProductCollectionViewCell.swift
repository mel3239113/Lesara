//
//  ProductCollectionViewCell.swift
//  LesaraExercise
//
//  Created by Matthew Lewis on 7/4/17.
//  Copyright © 2017 Matthew Lewis. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    var nameLabel: UILabel!
    var priceLable : UILabel!
    var imageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.nameLabel = UILabel()
        self.nameLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: Constants.LabelHeight * 2)
        self.nameLabel.textAlignment = .center
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.numberOfLines = 0
        self.nameLabel.minimumScaleFactor = 0.5
        self.contentView.addSubview(self.nameLabel)
        
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: 0, y: nameLabel.frame.maxY, width: self.frame.width, height: self.frame.height - Constants.LabelHeight * 3)
        self.imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.imageView)
       
        self.priceLable = UILabel()
        self.priceLable.frame = CGRect(x: 0, y: self.imageView.frame.maxY, width: self.frame.width, height: Constants.LabelHeight)
        self.priceLable.adjustsFontSizeToFitWidth = true
        self.priceLable.minimumScaleFactor = 0.8
        self.priceLable.textAlignment = .center
        self.contentView.addSubview(priceLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateWithProduct(product : Product){
        
        self.nameLabel.text = product.name
        self.priceLable.text = "Price \(product.getPriceDisplay())"
        self.downloadUIImage(product: product)
        
    }
    
    func downloadUIImage(product : Product) {
        
        let imageURL = URL(string: "\(Constants.imageUrlBase)\(product.thumbnailPath)")!
        let session = URLSession(configuration: .default)

        let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
          if let res = response as? HTTPURLResponse {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        downloadPicTask.resume()
    }
}
