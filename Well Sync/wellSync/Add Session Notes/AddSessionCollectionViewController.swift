//
//  AddSessionCollectionViewController.swift
//  wellSync
//
//  Created by Vidit Saran Agarwal on 25/03/26.
//

import UIKit


class AddSessionCollectionViewController: UICollectionViewController,TextFieldCollectionViewCellDelegate {

    var recording:[String] = ["abc"]
    var image:[String] = []
    @IBOutlet weak var clipButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        collectionView.register(UINib(nibName: "textFieldCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "textCell")
        collectionView.register(UINib(nibName: "RIViewCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "uploadCell")
        collectionView.collectionViewLayout = generateLayout()
        collectionView.alwaysBounceVertical = true
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? textFieldCollectionViewCell {
            cell.writtenNote.becomeFirstResponder()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0{
            return 1
        }
        return recording.count+image.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "textCell",
                for: indexPath
            ) as! textFieldCollectionViewCell
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! RIViewCollectionViewCell
            return cell
        }
    }
    func generateLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                // MARK: - Section 0: Text Field (self-sizing)
                // Step 1: Item uses .estimated so Auto Layout drives the actual height
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)        // item self-sizes
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Step 2: Group height is also .estimated, but set independently
                // This tells the group to defer to the item's resolved height
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)        // group defers to item
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 1
                )

                // Step 3: Add insets so the cell doesn't hug the screen edges
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 12, leading: 16, bottom: 8, trailing: 16
                )
                return section

            default:
                // MARK: - Section 1: Media Thumbnails (horizontal scroll)
                // Step 1: Each thumbnail item is a fixed 100x100 square
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 4, leading: 4, bottom: 4, trailing: 4
                )

                // Step 2: Group is a horizontal row — width is the full collection width
                // Height matches the item height
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),   // stretches full width
                    heightDimension: .absolute(108)          // item height + insets
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 1                )

                // Step 3: Section with orthogonal (horizontal) scrolling
                let section = NSCollectionLayoutSection(group: group)// swipe horizontally
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8, leading: 16, bottom: 16, trailing: 16
                )
                return section
            }
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    func setup() {
        
        // Camera action
        let camera = UIAction(title: "Camera", image: UIImage(systemName: "camera")) { _ in
            print("Camera tapped")
        }
        
        // Photo Library action
        let library = UIAction(title: "Photo Library", image: UIImage(systemName: "photo")) { _ in
            print("Photo Library tapped")
        }
        
        // Recording action
        let recording = UIAction(title: "Recording", image: UIImage(systemName: "mic")) { _ in
            print("Recording tapped")
        }
        
        // Create menu
        let menu = UIMenu(title: "", children: [camera, library, recording])
        
        clipButton.menu = menu
        clipButton.primaryAction = nil
        clipButton.target = nil
        clipButton.action = nil
    }
    
    @IBAction func upload(_ sender: UIBarButtonItem) {
    }
    
    func textFieldCell(_ cell: textFieldCollectionViewCell, didChangeHeight height: CGFloat) {
            collectionView.performBatchUpdates({
                collectionView.collectionViewLayout.invalidateLayout()
            })
        }

    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
