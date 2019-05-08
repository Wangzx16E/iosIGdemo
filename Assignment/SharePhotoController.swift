//
//  SharePhotoController.swift
//  Assignment
//
//  Created by Ellen Wang on 2019/2/17.
//  Copyright © 2019 ellen. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    // MARK: SET UP IMAGE & TEXT
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
//    let textTagView: UITextView = {
//        let tv = UITextView()
//        tv.text = "Enable auto Hashtags"
//        tv.font = UIFont.systemFont(ofSize: 14)
//        return tv
//    }()
//
//    let tagSwitch: UISwitch = {
//        let ts = UISwitch()
//        ts.tintColor = .black
//        ts.onTintColor = .mainBlue()
//        ts.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
//        return ts
//    }()
//
//    @objc fileprivate func handleSwitch(){
//        if tagSwitch.isOn {
//            print("ON")
//        } else {
//            print("OFF")
//        }
//    }
//
    
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        containerView.addSubview(tagSwitch)
//        tagSwitch.anchor(top: textView.bottomAnchor, left: textTagView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        containerView.addSubview(textTagView)
//        textTagView.anchor(top: textView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: tagSwitch.leftAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    // MARK: SAVE TO FIREBASE
    @objc func handleShare() {
        guard let caption = textView.text, !caption.isEmpty else { return }
        guard let image = selectedImage else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var tags = [String: Float]()
        var hashtag = [String]()
        //        if self.tagSwitch.isOn{
        let labeler = Vision.vision().onDeviceImageLabeler()
        var image: VisionImage
        
        if self.selectedImage!.imageOrientation != .up{
            let displayImage = self.rotateImage(image: selectedImage!) as? UIImage
            image = VisionImage(image: displayImage!)
        }
        else{
            image = VisionImage(image: self.selectedImage!)}
        
        labeler.process(image) { labels, error in
            guard error == nil, let labels = labels else { return }
            for label in labels {
                let confidence = label.confidence as! Float
                if confidence >= 0.80{
                    hashtag.append(label.text)
                }
            }
            let userPostRef = Firestore.firestore().collection("posts").document(uid).collection("post")
            userPostRef.addDocument(data: ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970, "hashtag": hashtag])
            { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("post saved!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    



    func rotateImage(image:UIImage) -> UIImage
    {
        var rotatedImage = UIImage()
        switch image.imageOrientation
        {
        case .right:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .down)
            
        case .down:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .left)
            
        case .left:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
            
        default:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        }
        
        return rotatedImage
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
