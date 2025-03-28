//
//  ViewController.swift
//  JRNL
//
//  Created by Jungman Bae on 3/25/25.
//

import UIKit

class JournalListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

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
      tableView.reloadData()
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
extension JournalListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return search.isActive ? filteredTableData.count : SharedData.shared.numberOfJournalEntries
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let journalCell = tableView.dequeueReusableCell(
      withIdentifier: "journalCell",
      for: indexPath
    ) as! JournalListTableViewCell
    
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
extension JournalListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("didSelectRowAt: \(indexPath)")
    // 선택한 셀의 JournalEntry 객체를 가져와서 JournalEntryDetailViewController에 전달
    let selectedJournalEntry = search.isActive ? filteredTableData[indexPath.row] : SharedData.shared.getJournalEntry(at: indexPath.row)
    print("selectedJournalEntry: \(selectedJournalEntry)")
    self.selectedJournalEntry = selectedJournalEntry
    performSegue(withIdentifier: "showDetail", sender: self)
  }

  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    if editingStyle == .delete {
      if search.isActive {
        let journalEntry = filteredTableData[indexPath.row]
        SharedData.shared.removeSelected(journalEntry: journalEntry)
        filteredTableData.remove(at: indexPath.row)
      } else {
        SharedData.shared.removeJournalEntry(at: indexPath.row)
      }
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
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

    tableView.reloadData()
  }
}
