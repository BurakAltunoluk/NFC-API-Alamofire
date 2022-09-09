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
    @IBOutlet private var loadCardOutled: UIButton!
    @IBOutlet private var mainButton: UIImageView!
    @IBOutlet private var infoText: UILabel!
    private var viewLed = UIView()
    private var nfcSession: NFCReaderSession?
    private var word = "None"
    private var player: AVPlayer?
    private var timer = Timer()
    private var mainButtonStatu = -1
    private var mainView = UIView()
    private var scanLedPixel = -1
    private var ledPixelRow = [0,51,102,153,204,255]
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomButtonImageGesture()
        ledScreenBackgroundView()
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
    
    private func playSound(url: String) {
        guard let url = URL.init(string: url)
        else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
    }
    
    @IBAction private func loadButton(_ sender: UIButton) {
        
            myCards.freshData()
        if  choosedRow != -1 {
            loadCardOutled.setTitle("Load Card", for: .normal)
            infoText.text = "Load card media..."
            player?.pause()
            mainButton.isUserInteractionEnabled = false
            stopLedPosition()
            choosedRow = -1
            mainButtonStatu = -1
          
        } else if choosedRow == -1 {
            myCards.freshData()
            performSegue(withIdentifier: "toMyCards", sender: nil)
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
}

