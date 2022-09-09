//
//  MyCardsVC.swift
//  NFC-API-Firebase-SampleProject
//
//  Created by Burak Altunoluk on 08/09/2022.
//

import UIKit

final class MyCardsVC: UIViewController {
    
    //MARK: Properties
    private var cellWidth = 0.0
    private var cellHeight = 0.0
    private var timer = Timer()
    @IBOutlet private var cardCollectionView: UICollectionView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
   
    @IBAction private func backButton(_ sender: Any) {
        WebService().cancelRequestAll()
        timer.invalidate()
        dismiss(animated: true)
        
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        reSizeCollectionCell()
        activityIndicator.center = view.center
        
        WebService().myCardsList()
       
        loadingTimer()
    }
    
    @objc private func loading() {
        if myCards.name.count > 0 {
            timer.invalidate()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            cardCollectionView.reloadData()
        }
    }
    
    private func loadingTimer() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.loading), userInfo: nil, repeats: true)
        }
    }
    
    private func reSizeCollectionCell () {
        cellWidth = UIScreen.main.bounds.width / 2 - 30
        cellHeight = cellWidth * 1.5
    }
}

extension MyCardsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MyCardsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCards.name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCardCell", for: indexPath) as! MyCardsCell
        Cell.imageCell.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
        let imageData = try! Data(contentsOf:URL(string: myCards.picture[indexPath.row])!)
        Cell.imageCell.image = UIImage(data: imageData)
        return Cell
    }
}

extension MyCardsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        choosedRow = indexPath.row
        dismiss(animated: true)
    }
}
