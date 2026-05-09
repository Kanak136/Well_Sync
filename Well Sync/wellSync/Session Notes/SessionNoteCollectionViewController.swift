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
    var appointment: Appointment?
    var sessions: [SessionNote] = []
    var sizeOfNotes: Int?
    private var onboardingSequence: FeatureOnboardingSequence?
    private var hasLoadedSessionsOnce = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SessionEmptyStateCell")
        collectionView.collectionViewLayout = generateLayout()
        onboardingSequence = FeatureOnboardingSequence(
            viewController: self,
            storageKey: "doctor_session_notes"
        ) { [weak self] in
            self?.makeOnboardingSteps() ?? []
        }
    }
    override func viewWillAppear(_ animated: Bool) {
            loadSessionNotes()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startOnboardingIfPossible()
    }
    func loadSessionNotes() {
        Task {
            guard let patientID = patient?.patientID else { return }

            do {
                let fetched = try await AccessSupabase.shared.fetchSessionNotes(patientID: patientID)
                await MainActor.run {
                    self.sessions = fetched
                    self.sizeOfNotes = self.sessions.count
                    self.hasLoadedSessionsOnce = true
                    self.collectionView.reloadData()
                    self.updateEmptyState()
                    self.startOnboardingIfPossible()
                }
            } catch {
                print("❌ fetch error:", error)
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard hasLoadedSessionsOnce else { return 0 }
        return max(sessions.count, 1)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if sessions.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionEmptyStateCell", for: indexPath)
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            let empty = EmptyStateCardView(
                title: "No session notes available",
                subtitle: "Tap + to create the first note for this patient.",
                iconSystemName: "note.text"
            )
            cell.contentView.addSubview(empty)
            NSLayoutConstraint.activate([
                empty.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                empty.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                empty.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                empty.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sessionCell", for: indexPath) as! SessionNoteCollectionViewCell
        cell
            .configur(
                with: sessions[indexPath.row],
                index: (sizeOfNotes ?? 0) - indexPath.row
            )
        return cell
    }

    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(170.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12)
        section.interGroupSpacing = 16

        return UICollectionViewCompositionalLayout(section: section)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !sessions.isEmpty else { return }
        performSegue(withIdentifier: "detailSession", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSession",
           let indexPath = sender as? IndexPath,
           let vc = segue.destination as? DetailSessionCollectionViewController {

            vc.session = sessions[indexPath.row]
            vc.title = "Session \(sessions.count - indexPath.row)"
        }

        if let navVC = segue.destination as? UINavigationController,
           let addVC = navVC.topViewController as? AddSessionCollectionViewController {
            addVC.patientID = patient?.patientID
            addVC.appointmentID = appointment?.appointmentId
            addVC.onSessionAdded = { [weak self] in
                self?.loadSessionNotes()
            }
        }
    }
    
    // MARK: - Context Menu for Deletion
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.confirmDeleteSession(at: indexPath)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [deleteAction])
        }
    }
    
    private func confirmDeleteSession(at indexPath: IndexPath) {
        let session = sessions[indexPath.row]
        guard let sessionId = session.sessionId else { return }
        
        let alert = UIAlertController(
            title: "Delete Session Note",
            message: "Are you sure you want to delete this session note? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteSession(sessionId: sessionId, at: indexPath)
        })
        
        present(alert, animated: true)
    }
    
    private func deleteSession(sessionId: UUID, at indexPath: IndexPath) {
        Task {
            do {
                try await AccessSupabase.shared.deleteSessionNote(sessionID: sessionId)
                await MainActor.run {
                    self.sessions.remove(at: indexPath.row)
                    self.loadSessionNotes()
                    self.updateEmptyState()
                }
            } catch {
                print("❌ Failed to delete session note: \(error)")
                await MainActor.run {
                    let errorAlert = UIAlertController(title: "Error", message: "Failed to delete the session note. Please try again.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true)
                }
            }
        }
    }

    private func updateEmptyState() {
        guard isViewLoaded else { return }
        collectionView.backgroundView = nil
    }

    private func makeOnboardingSteps() -> [FeatureSpotlightStep] {
        collectionView.layoutIfNeeded()
        return [
            FeatureSpotlightStep(
                title: "Create session notes",
                message: "Use + to add notes after each patient session.",
                placement: .below,
                targetProvider: { [weak self] in self?.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView }
            ),
            FeatureSpotlightStep(
                title: "Review older notes",
                message: "All previous notes appear here in reverse order.",
                placement: .above,
                targetProvider: { [weak self] in
                    guard let self, !self.sessions.isEmpty else { return nil }
                    return self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
                }
            )
        ]
    }

    private func startOnboardingIfPossible() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.onboardingSequence?.startIfNeeded()
        }
    }
}
