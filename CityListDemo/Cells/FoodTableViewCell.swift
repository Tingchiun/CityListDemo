//
//  FoodTableViewCell.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/12.
//

import UIKit

// TODO: Change to single label
class FoodTableViewCell: UITableViewCell {
    
    static let identifier: String = "FoodTableViewCell"
    
    private var imageProvider = ImageProvider()

    var cellModel: ListItemCellModel? {
        didSet {
            foodName.text = cellModel?.cellName
            guard let imageURLString = cellModel?.cellImage, let name = cellModel?.cellName else { return }
            imageProvider
                .getImage(urlString: imageURLString, name: name)
                .then(on: .main) { [weak self] image in
                    self?.foodImage.image = image
                }
        }
    }

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodName.adjustsFontSizeToFitWidth = true
        foodName.font = .boldSystemFont(ofSize: 16)
        foodImage.contentMode = .scaleAspectFill
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.borderWidth = 0.5
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
