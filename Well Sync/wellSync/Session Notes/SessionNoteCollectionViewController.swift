//
//  SessionNoteCollectionViewController.swift
//  wellSync
//
//  Created by Vidit Agarwal on 10/03/26.
//

import UIKit
import Foundation
class SessionNoteCollectionViewController: UICollectionViewController {

    var patient: Patient?
    
    var sessions:[SessionNote]?
    override func viewDidLoad() {
        super.viewDidLoad()
        sessions = globalSession.filter { $0.patientId == patient?.patientID }
        self.collectionView.collectionViewLayout = generateLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sessions?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sessionCell", for: indexPath) as! SessionNoteCollectionViewCell
            
            // ← ADD this
        print("session title: \(sessions?[indexPath.row].title ?? "nil")")
        print("session notes: \(sessions?[indexPath.row].notes ?? "nil")")
            
        cell.configur(with: sessions?[indexPath.row], indexPath: indexPath)
        return cell
    }
    func generateLayout() -> UICollectionViewLayout {
        //createthe itemSize
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        //certe the item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //create teh siz eof the group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(200.0))
        //create the group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(16)
        
        //create the section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSession", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If we passed an IndexPath as the sender, use it to configure the destination
        if let indexPath = sender as? IndexPath {
            let vc = segue.destination
            vc.title = "Session \(indexPath.row + 1)"
        }
    }
}
