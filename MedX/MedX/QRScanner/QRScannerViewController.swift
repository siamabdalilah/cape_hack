//
//  QRScannerViewController.swift
//  MedX
//
//  Created by Siam Abd Al-Ilah on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class QRScannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var scannerView: QRScannerView! {
        didSet{
            scannerView.delegate = self
        }
    }
    
    @IBAction func toggleScan(_ sender: UIButton) {
//        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
//        let title = scannerView.isRunning ? "Stop":"Start"
//        sender.setTitle(title, for: UIControl.State.normal)
        let filep = FilePicker(coder: NSCoder())
        filep?.pickFile()
    }
    
    
    @IBOutlet weak var data: UITextView!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
    var qrData: String? {
        didSet {
            data.attributedText = NSAttributedString(string: qrData ?? "nil", attributes: [:])
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension QRScannerViewController: QRScannerViewDelegate{
    func qrScanningDidFail() {
        print("Scan Failed")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        print("Scan Succeeded")
        self.qrData = str ?? "NO DATA RECEIVED"
    }
    
    func qrScanningDidStop() {
        print("Scanning stopped")
    }
    
    
}
