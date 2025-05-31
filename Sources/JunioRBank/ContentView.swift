// SPDX-License-Identifier: GPL-2.0-or-later

import SwiftUI

struct ContentView: View {
    @AppStorage("appearance") var appearance = ""
    @State var campViewModel = CampViewModel()

    var body: some View {
        ParticipantsListView()
            .environment(campViewModel)
            .preferredColorScheme(appearance == "dark" ? .dark : appearance == "light" ? .light : nil)
    }
}

#Preview {
    ContentView()
}
