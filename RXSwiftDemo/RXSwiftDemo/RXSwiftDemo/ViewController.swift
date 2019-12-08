//
//  ViewController.swift
//  RXSwiftDemo
//
//  Created by dengqi on 2019/12/1.
//  Copyright © 2019 DQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        _ = btn.rx.tap.subscribe(onNext: { (sender) in
            self.navigationController?.pushViewController(DQImagePickerController(), animated: true)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
        
    }


}

