//
//  ViewController.swift
//  NFC-API-Firebase-SampleProject
//
//  Created by Burak Altunoluk on 03/09/2022.
//

import UIKit
import CoreNFC
import AVFoundation
import AVKit
import Alamofire
import SwiftyJSON


final class MainVC: UIViewController, NFCNDEFReaderSessionDelegate {
    
    //MARK: Properties
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var loadCardOutled: UIButton!
    @IBOutlet private var mainButton: UIImageView!
    @IBOutlet private var infoText: UILabel!
    private var nfcSession: NFCReaderSession?
    private var mainView = UIView()
    private var viewLed = UIView()
    private var player: AVPlayer?
    private var timer = Timer()
    private var word = "None"
    private var mainButtonStatu = -1
    private var scanLedPixel = -1
    private var ledPixelRow = [0,51,102,153,204,255]
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCardOutled.isEnabled = false
        activityIndicator.startAnimating()
        WebService().myCardsList()
        bottomButtonImageGesture()
        ledScreenBackgroundView()
        dataControl()
        stopLedPosition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if choosedRow != -1 {
            infoText.text = myCards.name[choosedRow]
            mainButton.isUserInteractionEnabled = true
            loadCardOutled.setTitle("Eject Card", for: .normal)
        } else {
            loadCardOutled.setTitle("Load Card", for: .normal)
        }
    }
   
    //MARK: NFC
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8) ?? "format not support"
        }
        DispatchQueue.main.async(execute: {
            self.infoText.text = result
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Functions
    private func ledLightController(x: Int, y: Int, lightOn: Int) {
        viewLed = UIView(frame: CGRect(x: y, y: x, width: 50, height: 50))
        if lightOn == 1 {
            viewLed.backgroundColor = UIColor(named: "ledOrange")
        } else {
            viewLed.backgroundColor = .lightGray
        }
        mainView.addSubview(viewLed)
    }
    
    private func dataInLedPanel(data:[Int]) {
        for i in ledPixelRow {
            for r in ledPixelRow {
                scanLedPixel += 1
                ledLightController(x: i, y: r, lightOn: data[scanLedPixel])
                if scanLedPixel == 35 {scanLedPixel = -1}
            }
        }
    }
    
    private func ledScreenBackgroundView() {
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: 305, height: 305))
        mainView.center = view.center
        mainView.tag = 100
        view.addSubview(mainView)
    }
    
    private func bottomButtonImageGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(buttonFeatures))
        mainButton.addGestureRecognizer(gesture)
    }
    
    @objc private func buttonFeatures() {
        if Reachability.isConnectedToNetwork(){
            mainButtonStatu += 1
            mainButton.transform = mainButton.transform.rotated(by: 45)
            
            if mainButtonStatu == 1 {mainButtonStatu = -1
                refreshLedScreen()
                stopLedPosition()
                player?.pause()
            } else {
                refreshLedScreen()
                dataInLedPanel(data: myCards.ledInfo[choosedRow])
                playSound(url: myCards.audioLink[choosedRow])
            }
        }
    }
    
    private func playSound(url: String) {
        guard let url = URL.init(string: url)
        else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
    }
    
    @IBAction private func loadButton(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork(){
            if  choosedRow != -1 {
                
                loadCardOutled.setTitle("Load Card", for: .normal)
                infoText.text = "Load card media..."
                player?.pause()
                mainButton.isUserInteractionEnabled = false
                stopLedPosition()
                choosedRow = -1
                mainButtonStatu = -1
                
            } else if choosedRow == -1 {
                
                performSegue(withIdentifier: "toMyCards", sender: nil)
            }
            
        }else{
            alertMenu()
        }
        
        
    }
    
    private func stopLedPosition() {
        dataInLedPanel(data: [  0,0,0,0,0,0,
                                0,0,0,0,0,0,
                                0,0,1,1,0,0,
                                0,0,1,1,0,0,
                                0,0,0,0,0,0,
                                0,0,0,0,0,0])
    }
    
    private func refreshLedScreen() {
        if let viewWithTag = self.mainView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        ledScreenBackgroundView()
    }
    
    private func dataControl() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(prepareData), userInfo: nil, repeats: true)
    }
    
    @objc private func prepareData() {
        if myCards.name.count > 0 {
            timer.invalidate()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            loadCardOutled.isEnabled = true
            
        }
    }
    func alertMenu() {
        let alert = UIAlertController(title: "Connection Failed", message: "No Internet Connection", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { UIAlertAction in
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

}

