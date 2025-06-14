// SPDX-License-Identifier: GPL-2.0-or-later

import SwiftUI

struct ParticipantsListView: View {
    @Environment(CampViewModel.self) var viewModel: CampViewModel
    @State private var showingMenu = false
    @State private var showingSearch = false
    @State private var searchText = ""
    
    var filteredParticipants: [Participant] {
        if searchText.isEmpty {
            return viewModel.participants.sorted { $0.lastName < $1.lastName }
        } else {
            let lowercaseSearchText = searchText.lowercased()
            return viewModel.participants.filter { participant in
                participant.fullName.lowercased().contains(lowercaseSearchText) ||
                participant.firstName.lowercased().contains(lowercaseSearchText) ||
                participant.lastName.lowercased().contains(lowercaseSearchText)
            }.sorted { $0.lastName < $1.lastName }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Search bar (shown when active)
                if showingSearch {
                    searchBar
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Participants list
                participantsList
            }
#if os(Android)
            .background(Color.white)
#else
            .background(Color.clear)
            .navigationBarHidden(true)
#endif
        }
        .confirmationDialog("Menu", isPresented: $showingMenu) {
            menuButtons
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 4) {
            // Top bar with menu and date
            HStack {
                Button(action: { showingMenu = true }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack {
                    Text(viewModel.todayDateString)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text(viewModel.sessionDisplayText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingSearch = !showingSearch
                        if !showingSearch {
                            searchText = ""
                        }
                    }
                }) {
                    Image(systemName: showingSearch ? "xmark" : "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
#if os(Android)
        .background(Color.white)
#else
        .background(Color.clear)
#endif
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search participants...", text: $searchText)
                .textFieldStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
#if os(Android)
        .background(Color.white)
#else
        .background(Color.clear)
#endif
    }
    
    // MARK: - Participants List
    
    private var participantsList: some View {
#if os(Android)
        // Use a custom ScrollView instead of List on Android to avoid red background
        ScrollView {
            LazyVStack(spacing: 4) {
                ForEach(filteredParticipants) { participant in
                    NavigationLink(value: participant) {
                        ParticipantRowView(participant: participant)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
        }
        .background(Color.white)
        .navigationDestination(for: Participant.self) { participant in
            ParticipantDetailView(participant: participant)
        }
#else
        List {
            ForEach(filteredParticipants) { participant in
                NavigationLink(value: participant) {
                    ParticipantRowView(participant: participant)
                }
                .padding(.trailing, 20)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: removeParticipants)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .navigationDestination(for: Participant.self) { participant in
            ParticipantDetailView(participant: participant)
        }
#endif
    }
    
    // MARK: - Menu
    
    private var menuButtons: some View {
        Group {
            Button("Add Group Expense") {
                // TODO: Navigate to group expense
            }
            
            Button("Add Participant") {
                // TODO: Navigate to add participant
            }
            
            Button("Export Data") {
                viewModel.exportData()
            }
            
            Button("Settings") {
                viewModel.showSettings()
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    // MARK: - Helper Methods
    
    private func removeParticipants(at offsets: IndexSet) {
        let participantsToRemove = offsets.map { filteredParticipants[$0] }
        
        for participant in participantsToRemove {
            if let index = viewModel.participants.firstIndex(where: { $0.id == participant.id }) {
                viewModel.participants.remove(at: index)
            }
        }
    }
}

// MARK: - Participant Row View

struct ParticipantRowView: View {
    let participant: Participant
    
    var body: some View {
        HStack(spacing: 0) {
            // Avatar - fixed width
            Circle()
                .fill(participant.photoPath != nil ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    if participant.photoPath != nil {
                        // TODO: Load actual photo
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    } else {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 20))
                    }
                }
                .frame(width: 60) // Fixed container width for avatar
            
            // Name and details - flexible width (can shrink)
            VStack(alignment: .leading, spacing: 2) {
                Text(participant.fullName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if !participant.balances.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(Array(participant.balances.prefix(3)), id: \.id) { balance in
                            Text(balance.displayAmount)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        if participant.balances.count > 3 {
                            Text("...")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Take remaining space
            
            // Primary balance - fixed width
            if let primaryBalance = participant.primaryBalance {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(primaryBalance.displayAmount)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primaryBalance.isNegative ? .red : .primary)
                        .lineLimit(1)
                    
                    if primaryBalance.currencyCode != "GEL" {
                        Text("~\(String(format: "%.0f", primaryBalance.gelEquivalent)) ₾")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(width: 80, alignment: .trailing) // Fixed width for balance
            } else {
                Text("0 ₾")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .trailing) // Fixed width for balance
            }
#if os(Android)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 20)
#endif
        }
        .padding(.vertical, 12)
#if os(Android)
        .background(Color.white)
#else
        .background(Color.clear)
#endif
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.vertical, 4)
    }
}

// MARK: - Placeholder Detail View

struct ParticipantDetailView: View {
    let participant: Participant
    
    var body: some View {
        VStack {
            Text("Participant Details")
                .font(.largeTitle)
                .padding()
            
            Text(participant.displayName)
                .font(.title2)
                .padding()
            
            Text("Coming soon...")
                .foregroundColor(.secondary)
            
            Spacer()
        }
#if os(Android)
        .background(Color.white)
#else
        .background(Color.clear)
#endif
        .navigationTitle(participant.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
