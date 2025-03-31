//
//  ViewController.swift
//  JRNL
//
//  Created by Jungman Bae on 3/25/25.
//

import UIKit

class JournalListViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  let search = UISearchController(searchResultsController: nil)
  var filteredTableData: [JournalEntry] = []
  var selectedJournalEntry: JournalEntry?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()

    SharedData.shared.fetchJournalEntries()

    search.searchResultsUpdater = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "제목 검색"
    navigationItem.searchController = search
    tabBarController?.mode = .tabSidebar
  }

  func setupCollectionView() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    flowLayout.minimumInteritemSpacing = 10
    flowLayout.minimumLineSpacing = 10
    collectionView.collectionViewLayout = flowLayout
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    print("viewWillLayoutSubviews!!!!!")
    collectionView.collectionViewLayout.invalidateLayout()
  }

  @IBAction func unwindNewEntryCancel(segue: UIStoryboardSegue) {
    print("unwindNewEntryCancel")
  }

  @IBAction func unwindNewEntrySave(segue: UIStoryboardSegue) {
    if let sourceViewController = segue.source as? AddJournalEntryViewController,
       let newJournalEntry = sourceViewController.newJournalEntry {
      SharedData.shared.addJournalEntry(newJournalEntry)
      SharedData.shared.fetchJournalEntries()
      collectionView.reloadData()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let segueIndentifier = segue.identifier {
      if segueIndentifier == "showDetail" {
        guard let entryDetailViewController = segue.destination as? JournalEntryDetailViewController else {
          fatalError("Unexpected destination: \(segue.destination)")
        }
        entryDetailViewController.selectedJournalEntry = selectedJournalEntry
      }
    }
  }
}

// MARK: - UICollectionViewDataSource
extension JournalListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return search.isActive ? filteredTableData.count : SharedData.shared.numberOfJournalEntries
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let journalCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "journalCell",
      for: indexPath
    ) as! JournalListCollectionViewCell

    let journalEntry =  search.isActive ? filteredTableData[indexPath.row] : SharedData.shared.getJournalEntry(at: indexPath.row)
    // 날짜, 제목, 사진 표시
    // 날짜는 "월 일, 년" 형식으로 표시
    journalCell.dateLabel.text = journalEntry.title
    journalCell.titleLabel.text = journalEntry.entryTitle
    if let photoData = journalEntry.photoData {
      journalCell.photoImageView.image = UIImage(data: photoData)
    }
    return journalCell
  }
}

// MARK: - UICollectionViewDelegate
extension JournalListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedJournalEntry = search.isActive ? filteredTableData[indexPath.row] : SharedData.shared.getJournalEntry(at: indexPath.row)
    performSegue(withIdentifier: "showDetail", sender: self)
  }

  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
    let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
      let delete = UIAction(title: "Delete") { (action) in
        indexPaths.forEach { indexPath in
          if self.search.isActive {
            let selectedJournalEntry = self.filteredTableData[indexPath.item]
            self.filteredTableData.remove(at: indexPath.item)
            SharedData.shared.removeSelected(journalEntry: selectedJournalEntry)
          } else {
            let selectedJournalEntry = SharedData.shared.getJournalEntry(at: indexPath.item)
            SharedData.shared.removeSelected(journalEntry: selectedJournalEntry)
          }
        }
        self.collectionView.reloadData()
      }
      return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
    }
    return config
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension JournalListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var columns: CGFloat
    if traitCollection.horizontalSizeClass == .compact {
      columns = 1
    } else {
      columns = 2
    }
    let viewWidth = collectionView.frame.width
    let inset = 10.0
    let contentWidth = viewWidth - inset * (columns + 1)
    let cellWidth = contentWidth / columns
    let cellHeight = 90.0
    return CGSize(width: cellWidth, height: cellHeight)
  }
}

// MARK: - UISearchResultsUpdating
extension JournalListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else {
      return
    }

    filteredTableData = SharedData.shared.getAllJournalEntries().filter { journalEntry in
      return journalEntry.entryTitle.lowercased().contains(searchText.lowercased())
    }

    collectionView.reloadData()
  }
}
