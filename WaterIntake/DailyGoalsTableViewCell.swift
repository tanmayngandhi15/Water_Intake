//
//  DailyGoalsTableViewCell.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 06/12/24.
//

import UIKit

class DailyGoalsTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "goalsCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "DailyGoalsTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var lbl_waterQty: UILabel!
    
    @IBOutlet weak var lbl_selectDate: UILabel!
    
    @IBOutlet weak var iv_container: UIImageView!
    
    @IBOutlet weak var vw_subView: UIView!
    
    func setupCell(viewModel: DailyGoals) {
     
        lbl_selectDate.text = viewModel.date
        lbl_waterQty.text = "\(viewModel.waterIntake!) ml"
        
        let type = (viewModel.containerType == "GLASS") ? "water-glass" : "water-bottle"

        iv_container.image = UIImage(named: type)
        
        vw_subView.layer.cornerRadius = vw_subView.bounds.height / 9
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
