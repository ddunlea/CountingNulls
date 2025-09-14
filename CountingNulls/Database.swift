import Dependencies
import Foundation
import GRDB
import OSLog
import StructuredQueries

@Table
struct OneRecord: Identifiable, Sendable, Equatable {
  let id: Int
  var name: String
}

@Table
struct ManyRecord: Identifiable, Sendable, Equatable {
  let id: Int
  var name: String
  let oneId: Int
}

private let logger = Logger(subsystem: "CountingNulls", category: "CountingNulls")

public func appDatabase() throws -> any DatabaseWriter {
  @Dependency(\.context) var context
  let database: any DatabaseWriter
  var configuration = Configuration()
  configuration.foreignKeysEnabled = true
  configuration.prepareDatabase { db in
    #if DEBUG
      db.trace(options: .profile) {
        if context == .preview {
          print("\($0.expandedDescription)")
        } else {
          logger.debug("\($0.expandedDescription)")
        }
      }
    #endif
  }
  if context == .preview {
    database = try DatabaseQueue(configuration: configuration)
  } else {
    let path =
    context == .live
    ? URL.documentsDirectory.appending(component: "db.sqlite").path()
    : URL.temporaryDirectory.appending(component: "\(UUID().uuidString)-db.sqlite").path()
    logger.info("open \(path)")
    database = try DatabasePool(path: path, configuration: configuration)
  }
  var migrator = DatabaseMigrator()
  #if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
  #endif
  migrator.registerMigration("Add One table") { db in
    try db.create(table: OneRecord.tableName) { table in
      table.autoIncrementedPrimaryKey(OneRecord.columns.id.name)
      table.column(OneRecord.columns.name.name, .text).notNull()
    }
  }
  
  migrator.registerMigration("Add Many table") { db in
    try db.create(table: ManyRecord.tableName) { table in
      table.autoIncrementedPrimaryKey(ManyRecord.columns.id.name)
      table.column(ManyRecord.columns.name.name, .text).notNull()
      table.column(ManyRecord.columns.oneId.name, .text).notNull()
    }
  }

  try migrator.migrate(database)

  return database
}
