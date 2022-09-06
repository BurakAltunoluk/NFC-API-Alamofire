//
//  CardsVC.swift
//  NFC-API-Firebase-SampleProject
//
//  Created by Burak Altunoluk on 06/09/2022.
//

import UIKit
import Alamofire
import SwiftyJSON

final class CardsVC: UIViewController {
    
    //MARK: Properties
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var Cards2Numbers: UIImageView!
    @IBOutlet private var Cards1Animals: UIImageView!
    private var timer = Timer()
    
    @IBAction private func backButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        Cards1Animals.isUserInteractionEnabled = true
        Cards2Numbers.isUserInteractionEnabled = true
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(card1))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(card2))
        Cards1Animals.addGestureRecognizer(gesture1)
        Cards2Numbers.addGestureRecognizer(gesture2)
    }
    
    //MARK: Functions
    @objc private func card1() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        loadingTimer()
        WebService().getData(link: "https://firebasestorage.googleapis.com/v0/b/edellcoffee2app.appspot.com/o/animals.json?alt=media&token=3f89e84f-9507-4d5f-b3da-7f52518ce4aa")
    }
    
    @objc private func card2() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        loadingTimer()
        WebService().getData(link: "https://firebasestorage.googleapis.com/v0/b/edellcoffee2app.appspot.com/o/numbers.json?alt=media&token=e3ff1bf5-ce4b-4617-a7b8-9a2bcf839cdb")
    }

    @objc private func loading() {
        if downloadedData.name != "" {
            timer.invalidate()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            dismiss(animated: true)
        }
    }
    
    private func loadingTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loading), userInfo: nil, repeats: true)
    }
    
}
