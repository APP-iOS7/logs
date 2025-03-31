//
//  JournalListCollectionViewCell.swift
//  JRNL
//
//  Created by Jungman Bae on 3/31/25.
//

import UIKit

class JournalListCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!

  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
    dateLabel.text = nil
    titleLabel.text = nil
  }
}
