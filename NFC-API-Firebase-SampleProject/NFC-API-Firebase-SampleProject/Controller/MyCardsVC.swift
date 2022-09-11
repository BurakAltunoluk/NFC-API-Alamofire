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
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet private var cardCollectionView: UICollectionView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBAction private func refreshButton(_ sender: UIButton) {
        activityIndicator.center = view.center
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        WebService().deleteAllData()
        WebService().myCardsList()
        view.alpha = 0.7
        dataControl()
    }
    
    @IBAction private func backButton(_ sender: Any) {
        WebService().cancelRequestAll()
        dismiss(animated: true)
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.setTitle("", for: UIControl.State.normal)
          reSizeCollectionCell()
        activityIndicator.isHidden = true
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
            Cell.imageCell.frame = CGRect(x: 0, y: 0, width: self.cellWidth, height: self.cellHeight)
        DispatchQueue.main.async {
            Cell.imageCell.image = UIImage(data: myCards.imageDatam[indexPath.row])
        }
        return Cell
    }
}

extension MyCardsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        choosedRow = indexPath.row
        dismiss(animated: true)
      

    }
    
    private func dataControl() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(prepareData), userInfo: nil, repeats: true)
    }
 
    @objc private func prepareData() {
        if myCards.name.count > 0 {
            timer.invalidate()
            view.alpha = 1
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            cardCollectionView.reloadData()
            
        }
    }

}
