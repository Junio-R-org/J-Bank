// SPDX-License-Identifier: GPL-2.0-or-later

import Foundation
import Observation
import OSLog

/// The Observable ViewModel for the JMoney camp management system
@Observable public class CampViewModel {
    var currentSession: CampSession
    var participants: [Participant] = []
    
    init() {
        // Initialize with mock session
        self.currentSession = CampSession(
            year: 2025,
            sessionNumber: 3,
            name: "Session 3"
        )
        
        // Load mock data
        loadMockData()
    }
    
    // MARK: - Computed Properties
    
    var sessionDisplayText: String {
        currentSession.displayName
    }
    
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    // MARK: - Mock Data Generation
    
    private func loadMockData() {
        logger.info("Loading mock camp data...")
        
        let mockParticipants = [
            createMockParticipant(firstName: "Aleksandr", lastName: "Abramov", balances: [
                CurrencyBalance(currencyCode: "GEL", amount: -28)
            ]),
            createMockParticipant(firstName: "Nadezhda", lastName: "Baban", balances: [
                CurrencyBalance(currencyCode: "EUR", amount: 150, initialDeposit: 200),
                CurrencyBalance(currencyCode: "GEL", amount: 59)
            ]),
            createMockParticipant(firstName: "Fedor", lastName: "Barshak", balances: [
                CurrencyBalance(currencyCode: "USD", amount: 80, initialDeposit: 100),
                CurrencyBalance(currencyCode: "GEL", amount: -28)
            ]),
            createMockParticipant(firstName: "Mark", lastName: "Volkov", balances: [
                CurrencyBalance(currencyCode: "EUR", amount: 175, initialDeposit: 200),
                CurrencyBalance(currencyCode: "USD", amount: 20, initialDeposit: 50),
                CurrencyBalance(currencyCode: "GEL", amount: 80, initialDeposit: 100)
            ]),
            createMockParticipant(firstName: "Alisa", lastName: "Volkova", balances: [
                CurrencyBalance(currencyCode: "EUR", amount: 183, initialDeposit: 200),
                CurrencyBalance(currencyCode: "GEL", amount: 250, initialDeposit: 300)
            ]),
            createMockParticipant(firstName: "Ivan", lastName: "Garkusha", balances: [
                CurrencyBalance(currencyCode: "GEL", amount: -3)
            ]),
            createMockParticipant(firstName: "Elizabet", lastName: "Geld", balances: [
                CurrencyBalance(currencyCode: "EUR", amount: 430, initialDeposit: 500)
            ]),
            createMockParticipant(firstName: "Anna", lastName: "Belousova", balances: [
                CurrencyBalance(currencyCode: "USD", amount: 106, initialDeposit: 150)
            ]),
            createMockParticipant(firstName: "Polina", lastName: "Brink", balances: [
                CurrencyBalance(currencyCode: "EUR", amount: 130, initialDeposit: 200),
                CurrencyBalance(currencyCode: "USD", amount: 50, initialDeposit: 50)
            ]),
            createMockParticipant(firstName: "Yakov", lastName: "Butenko", balances: [
                CurrencyBalance(currencyCode: "EUR", amount: 84, initialDeposit: 150),
                CurrencyBalance(currencyCode: "GEL", amount: 10)
            ])
        ]
        
        self.participants = mockParticipants
        logger.info("Loaded \(self.participants.count) mock participants")
    }
    
    private func createMockParticipant(
        firstName: String,
        lastName: String,
        balances: [CurrencyBalance]
    ) -> Participant {
        Participant(
            sessionId: currentSession.id,
            firstName: firstName,
            lastName: lastName,
            parentEmail: "\(firstName.lowercased()).\(lastName.lowercased())@parent.com",
            balances: balances
        )
    }
    
    // MARK: - Public Methods
    
    func addParticipant(_ participant: Participant) {
        participants.append(participant)
        logger.info("Added participant: \(participant.displayName)")
    }
    
    func participant(withId id: UUID) -> Participant? {
        participants.first { $0.id == id }
    }
    
    func updateParticipant(_ participant: Participant) {
        if let index = participants.firstIndex(where: { $0.id == participant.id }) {
            participants[index] = participant
            logger.info("Updated participant: \(participant.displayName)")
        }
    }
}

// MARK: - Menu Actions
extension CampViewModel {
    
    func exportData() {
        // TODO: Implement CSV export
        logger.info("Export data requested")
    }
    
    func importData() {
        // TODO: Implement CSV import
        logger.info("Import data requested")
    }
    
    func showSettings() {
        // TODO: Navigate to settings
        logger.info("Settings requested")
    }
}
