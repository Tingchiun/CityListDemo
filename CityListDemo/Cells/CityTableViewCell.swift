//
//  CityTableViewCell.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/9.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityDescription: UILabel!
    
    static let identifier: String = "CityTableViewCell"
    
    private let imageProvider = ImageProvider()

    var cellModel: ListItemCellModel? {
        didSet {
            cityName.text = cellModel?.cellName
            cityDescription.text = cellModel?.cellDetail

            guard let imageURLString = cellModel?.cellImage, let name = cellModel?.cellName else { return }
            imageProvider
                .getImage(urlString: imageURLString, name: name)
                .then (on: .main) { image in
                    self.cityImageView.image = image
                }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cityName.adjustsFontSizeToFitWidth = true
        cityName.font = .boldSystemFont(ofSize: 16)
        cityDescription.font = .systemFont(ofSize: 12)
        cityDescription.numberOfLines = 2
        cityImageView.contentMode = .scaleAspectFill
        
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
