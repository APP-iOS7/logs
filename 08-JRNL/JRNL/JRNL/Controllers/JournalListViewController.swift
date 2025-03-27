//
//  ViewController.swift
//  JRNL
//
//  Created by Jungman Bae on 3/25/25.
//

import UIKit

class JournalListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var sampleJournalEntryData = SampleJournalEntryData()
  var selectedJournalEntry: JournalEntry?

  override func viewDidLoad() {
    super.viewDidLoad()
    // 샘플 데이터 생성
    sampleJournalEntryData.createSampleJournalEntryData()
  }
  
  @IBAction func unwindNewEntryCancel(segue: UIStoryboardSegue) {
    print("unwindNewEntryCancel")
  }
  
  @IBAction func unwindNewEntrySave(segue: UIStoryboardSegue) {
    if let sourceViewController = segue.source as? AddJournalEntryViewController,
       let newJournalEntry = sourceViewController.newJournalEntry {
      sampleJournalEntryData.journalEntries.append(newJournalEntry)
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

extension JournalListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sampleJournalEntryData.journalEntries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let journalCell = tableView.dequeueReusableCell(
      withIdentifier: "journalCell",
      for: indexPath
    ) as! JournalListTableViewCell
    
    let journalEntry = sampleJournalEntryData.journalEntries[indexPath.row]
    // 날짜, 제목, 사진 표시
    // 날짜는 "월 일, 년" 형식으로 표시
    journalCell.dateLabel.text = journalEntry.date.formatted(.dateTime.month().day().year())
    journalCell.titleLabel.text = journalEntry.entryTitle
    journalCell.photoImageView.image = journalEntry.photo
    
    return journalCell
  }
}


extension JournalListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("didSelectRowAt: \(indexPath)")
    // 선택한 셀의 JournalEntry 객체를 가져와서 JournalEntryDetailViewController에 전달
    let selectedJournalEntry = sampleJournalEntryData.journalEntries[indexPath.row]
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
      sampleJournalEntryData.journalEntries.remove(at: indexPath.row)
      // 테이블 전체 새로고침
      // tableView.reloadData()
      
      // 테이블에서 해당 행만 삭제 ( 애니메이션 효과 포함 )
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}
