import ComposableArchitecture
import SharingGRDB
import SwiftUI

@Reducer
struct CountingNullsFeature {
  @ObservableState
  struct State {
    @FetchAll(OneWithManyCount.all())
    var oneWithManyCounts: [OneWithManyCount]
  }
}

struct CountingNullsView: View {
  @Bindable var store: StoreOf<CountingNullsFeature>

  var body: some View {
    Form {
      Text("Record count: \(store.oneWithManyCounts.count)")
    }
  }
}
