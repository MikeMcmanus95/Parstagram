//
//  PostCell.swift
//  Parstagram
//
//  Created by Michael Mcmanus on 3/16/19.
//  Copyright © 2019 Michael Mcmanus. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var liked:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        // Initialization code
    }
    
   @objc func pinch(sender:UIPinchGestureRecognizer) {
        if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.photoView.frame.size.width / self.photoView.bounds.size.width
            var newScale = currentScale*sender.scale

            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.photoView.transform = transform
                sender.scale = 1
            }
            if newScale > 7 {
                newScale = 7
            }
            else {
                view.transform = transform
                sender.scale = 1
            }
        }
        else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                self.photoView.transform = CGAffineTransform.identity
            })
        }
    }
    

    
    func setUpView() {
        
        photoView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        self.photoView.addGestureRecognizer(pinch)
        captionLabel.layer.zPosition = -1
        
    }
    @objc
    
    @IBAction func likePost(_ sender: Any) {
        let toBeLiked = !liked
        
        if (toBeLiked){
            print("Success!")
            self.setLiked(true)
        }
        else {
            print("Unliked.")
            self.setLiked(false)
        }
    }
    
    
    func setLiked(_ isLiked:Bool) {
        liked = isLiked
        
        if(liked)
        {
            likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else
        {
            likeButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
