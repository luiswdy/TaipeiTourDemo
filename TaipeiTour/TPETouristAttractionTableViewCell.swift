//
//  TPETouristAttractionTableViewCell.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/25/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//

import UIKit
import Kingfisher

class TPETouristAttractionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
   
    @IBOutlet var collapseConstraint: NSLayoutConstraint!
    @IBOutlet var expandConstraint: NSLayoutConstraint!
    
    struct Consts {
        static let defaultPhotoFileIndex = 0
    }
    
    var isExpanded = false {
        didSet {
            self.bodyLabel.isHidden = !isExpanded
            self.expandConstraint.isActive = self.isExpanded
            self.collapseConstraint.isActive = !self.isExpanded
        }
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.bodyLabel.text = nil
        self.photoImageView.image = nil
        self.isExpanded = false
    }
    
    func updateCellBy(model: TPETouristAttractionModel) {
        self.titleLabel.text = model.sTitle
        self.bodyLabel.text = model.xBody
        if let urlString = model.file?[Consts.defaultPhotoFileIndex] {
            self.photoImageView.kf.setImage(with: URL(string:urlString), placeholder: Image(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.isExpanded = model.isExpanded
    }
    
    func onEndDisplaying() {
        self.photoImageView.kf.cancelDownloadTask()
    }
}
