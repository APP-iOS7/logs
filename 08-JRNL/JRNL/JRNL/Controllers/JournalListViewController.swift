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
    SharedData.shared.loadJournalEntriesData()

    search.searchResultsUpdater = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "제목 검색"
    navigationItem.searchController = search
  }

  @IBAction func unwindNewEntryCancel(segue: UIStoryboardSegue) {
    print("unwindNewEntryCancel")
  }
  
  @IBAction func unwindNewEntrySave(segue: UIStoryboardSegue) {
    if let sourceViewController = segue.source as? AddJournalEntryViewController,
       let newJournalEntry = sourceViewController.newJournalEntry {
      SharedData.shared.addJournalEntry(newJournalEntry)
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

// MARK: - UITableViewDataSource
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
    journalCell.dateLabel.text = journalEntry.dateString
    journalCell.titleLabel.text = journalEntry.entryTitle
    if let photoData = journalEntry.photoData {
      journalCell.photoImageView.image = UIImage(data: photoData)
    }
    return journalCell
  }
}

// MARK: - UITableViewDelegate
extension JournalListViewController: UICollectionViewDelegate {
//  TODO: 컬렉션 뷰 델리게이트 코드 추가 ( contextMenu, 동적 사이즈 코드 추가 필요 )
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
