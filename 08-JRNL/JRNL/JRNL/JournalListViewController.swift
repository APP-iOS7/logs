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

  override func viewDidLoad() {
    super.viewDidLoad()
    // 샘플 데이터 생성
    sampleJournalEntryData.createSampleJournalEntryData()
  }

  @IBAction func unwindNewEntryCancel(segue: UIStoryboardSegue) {
    print("unwindNewEntryCancel")
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

