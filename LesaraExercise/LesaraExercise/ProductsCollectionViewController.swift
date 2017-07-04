//
//  ProductsCollectionViewController.swift
//  LesaraExercise
//
//  Created by Matthew Lewis on 7/4/17.
//  Copyright © 2017 Matthew Lewis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductCollectionViewCell"

class ProductsCollectionViewController: UICollectionViewController {

    var products                : [Product]  = []
    var pageNumber              : Int = 1
    var updating                = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.networkCall()
    }

    
    func networkCall(){
        
        let url = URL(string: "\(Constants.urlString)\(self.pageNumber)")
        self.updating = true
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    let trendingReponse = TrendingProductResponse(json: json["trend_products"] as! [String : AnyObject])
                    self.extractData(data: trendingReponse!)

                    OperationQueue.main.addOperation({
                        self.collectionView?.reloadData()
                        self.updating = false
                    })
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    
    func extractData(data : TrendingProductResponse){
        
        var currentPage = Int(data.currentPage)
        currentPage = currentPage! + 1
        self.pageNumber = currentPage!
        self.products.append(contentsOf: data.productList.products)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
 
        cell.updateWithProduct(product: self.products[indexPath.row])
        cell.backgroundColor = UIColor.orange
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let maxItems = self.products.count
        if(indexPath.row > maxItems - Constants.updateThreshold){
            if(updating == false){
                
                self.networkCall()
            }
        }
    }
    
    // Called when the cell is displayed
    
}

extension ProductsCollectionViewController : UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = Constants.SectionInsets.left * (Constants.ItemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.ItemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.SectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.SectionInsets.left
    }



}
