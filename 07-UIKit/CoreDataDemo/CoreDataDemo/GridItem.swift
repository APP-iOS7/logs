//
//  GridItem.swift
//  CoreDataDemo
//
//  Created by Jungman Bae on 3/20/25.
//

import UIKit
import CoreData

struct GridItem: Hashable {
  let id: UUID
  let title: String
  let imageSystemName: String

  init(title: String, imageSystemName: String) {
    self.id = UUID()
    self.title = title
    self.imageSystemName = imageSystemName
  }

  init(id: UUID, title: String, imageSystemName: String) {
    self.id = id
    self.title = title
    self.imageSystemName = imageSystemName
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: GridItem, rhs: GridItem) -> Bool {
    return lhs.id == rhs.id
  }
}

extension GridItem {
  // GridItem -> GridItemEntity 변환
  func toManagedObject(in context: NSManagedObjectContext) -> GridItemEntity {
    let entity = GridItemEntity(context: context)
    entity.id = id
    entity.title = title
    entity.imageSystemName = imageSystemName
    entity.createdAt = Date()
    return entity
  }

  // GridItemEntity -> GridItem 변환
  static func from(_ entity: GridItemEntity) -> GridItem? {
    guard let id = entity.id,
          let title = entity.title,
          let imageSystemName = entity.imageSystemName else {
      return nil
    }

    var item = GridItem(id: id, title: title, imageSystemName: imageSystemName)
    return item
  }

}
