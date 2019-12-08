//
//  DQImagePickerController.swift
//  RXSwiftDemo
//
//  Created by dengqi on 2019/12/8.
//  Copyright © 2019 DQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DQImagePickerController: DQViewController {
    
//    var disposeBag = DisposeBag()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        btnA.rx.tap.flatMapLatest { [weak self] _ in
            return UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .camera
                picker.allowsEditing = false
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
        }
        .map { info in
            return info[.originalImage] as? UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)

        
        brnB.rx.tap.flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        btnC.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[.editedImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
    }

    @IBOutlet weak var btnA: UIButton!
    
    @IBOutlet weak var brnB: UIButton!
    
    @IBOutlet weak var btnC: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
}

class DQViewController: UIViewController {
    var disposeBag = DisposeBag()
}


#if os(iOS)
    
    import RxSwift
    import RxCocoa
    import UIKit

    extension Reactive where Base: UIImagePickerController {

        /**
         Reactive wrapper for `delegate` message.
         */
        public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
            return delegate
                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
                .map({ (a) in
                    return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
                })
        }

        /**
         Reactive wrapper for `delegate` message.
         */
        public var didCancel: Observable<()> {
            return delegate
                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
                .map {_ in () }
        }
        
    }
    
#endif

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

