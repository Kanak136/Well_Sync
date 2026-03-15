//
//  deatilsCollectionViewCell.swift
//  calendar
//
//  Created by Vidit Saran Agarwal on 15/03/26.
//

import UIKit

class deatilsCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath)
        return cell
    }

    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
