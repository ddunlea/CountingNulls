import Foundation
import StructuredQueries
import StructuredQueriesSQLite

@Selection
struct OneWithManyCount: Equatable, Identifiable, Sendable {
  public let one: OneRecord
  public let manyCount: Int
  
  public var id: Int {
    one.id
  }
  
  public static func all() -> Select<OneWithManyCount.Columns.QueryValue, OneRecord, ManyRecord?> {
    return OneRecord
      .all
      .leftJoin(ManyRecord.all) { one, many in
        one.id.eq(many.oneId)
      }
      .order{ one, many in
        (many.count().desc(), one.name)
      }
      .select{ one, many in
        OneWithManyCount.Columns(one: one, manyCount: many.count())
      }
  }
}
