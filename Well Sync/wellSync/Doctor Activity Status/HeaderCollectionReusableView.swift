//
//  HeaderCollectionReusableView.swift
//  wellSync
//
//  Created by Vidit Agarwal on 12/02/26.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var sectionHeader: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(withTitle title:String)
    {
        sectionHeader.text = title
    }
    
}
