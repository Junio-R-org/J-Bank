// SPDX-License-Identifier: GPL-2.0-or-later

import Foundation

// MARK: - Session Model
struct CampSession: Identifiable, Codable, Hashable {
    let id: UUID
    var year: Int
    var sessionNumber: Int
    var name: String
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        year: Int = 2025,
        sessionNumber: Int = 3,
        name: String = "Session 3",
        startDate: Date = Date(),
        endDate: Date = Date().addingTimeInterval(10 * 24 * 60 * 60), // 10 days later
        isActive: Bool = true
    ) {
        self.id = id
        self.year = year
        self.sessionNumber = sessionNumber
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
    }
    
    var displayName: String {
        "\(sessionNumber) session, \(year)"
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: startDate)
    }
}

// MARK: - Participant Model
struct Participant: Identifiable, Codable, Hashable {
    let id: UUID
    var sessionId: UUID
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String?
    var photoPath: String?
    var parentEmail: String?
    var notes: String?
    var balances: [CurrencyBalance]
    
    init(
        id: UUID = UUID(),
        sessionId: UUID,
        firstName: String,
        lastName: String,
        email: String? = nil,
        phone: String? = nil,
        photoPath: String? = nil,
        parentEmail: String? = nil,
        notes: String? = nil,
        balances: [CurrencyBalance] = []
    ) {
        self.id = id
        self.sessionId = sessionId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.photoPath = photoPath
        self.parentEmail = parentEmail
        self.notes = notes
        self.balances = balances
    }
    
    var fullName: String {
        "\(lastName.uppercased()) \(firstName)"
    }
    
    var displayName: String {
        "\(firstName) \(lastName)"
    }
    
    // Calculate total balance in GEL equivalent for sorting/display
    var totalBalanceGEL: Double {
        balances.reduce(0.0) { total, balance in
            total + balance.gelEquivalent
        }
    }
    
    // Get primary balance for list display
    var primaryBalance: CurrencyBalance? {
        // Show the largest balance, or GEL if available
        if let gelBalance = balances.first(where: { $0.currencyCode == "GEL" }) {
            return gelBalance
        }
        return balances.max { $0.amount < $1.amount }
    }
}

// MARK: - Currency Balance Model
struct CurrencyBalance: Identifiable, Codable, Hashable {
    let id: UUID
    var currencyCode: String
    var amount: Double
    var initialDeposit: Double
    var totalSpent: Double
    
    init(
        id: UUID = UUID(),
        currencyCode: String,
        amount: Double,
        initialDeposit: Double = 0.0,
        totalSpent: Double = 0.0
    ) {
        self.id = id
        self.currencyCode = currencyCode
        self.amount = amount
        self.initialDeposit = initialDeposit
        self.totalSpent = totalSpent
    }
    
    var isPositive: Bool {
        amount > 0
    }
    
    var isNegative: Bool {
        amount < 0
    }
    
    var formattedAmount: String {
        String(format: "%.0f", amount)
    }
    
    var currencySymbol: String {
        switch currencyCode {
        case "EUR": return "€"
        case "USD": return "$"
        case "GEL": return "₾"
        case "RUB": return "₽"
        default: return currencyCode
        }
    }
    
    var displayAmount: String {
        if currencyCode == "EUR" || currencyCode == "USD" {
            return "\(formattedAmount)\(currencySymbol)"
        } else {
            return "\(formattedAmount) \(currencyCode)"
        }
    }
    
    // Mockup conversion to GEL for sorting (in real app, this would use live rates)
    var gelEquivalent: Double {
        switch currencyCode {
        case "EUR": return amount * 2.65
        case "USD": return amount * 2.45
        case "GEL": return amount
        case "RUB": return amount * 0.027
        default: return amount
        }
    }
}

// MARK: - Transaction Model
struct Transaction: Identifiable, Codable, Hashable {
    let id: UUID
    var participantId: UUID
    var transactionType: TransactionType
    var amount: Double
    var currencyCode: String
    var description: String
    var groupExpenseId: UUID?
    var exchangeRate: Double?
    var equivalentGEL: Double?
    var transactionDate: Date
    
    init(
        id: UUID = UUID(),
        participantId: UUID,
        transactionType: TransactionType,
        amount: Double,
        currencyCode: String,
        description: String,
        groupExpenseId: UUID? = nil,
        exchangeRate: Double? = nil,
        equivalentGEL: Double? = nil,
        transactionDate: Date = Date()
    ) {
        self.id = id
        self.participantId = participantId
        self.transactionType = transactionType
        self.amount = amount
        self.currencyCode = currencyCode
        self.description = description
        self.groupExpenseId = groupExpenseId
        self.exchangeRate = exchangeRate
        self.equivalentGEL = equivalentGEL
        self.transactionDate = transactionDate
    }
    
    var formattedAmount: String {
        let symbol = CurrencyBalance(currencyCode: currencyCode, amount: 0.0).currencySymbol
        let sign = transactionType == .expense ? "-" : ""
        return "\(sign)\(String(format: "%.0f", abs(amount))) \(symbol)"
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: transactionDate)
    }
}

enum TransactionType: String, Codable, CaseIterable {
    case deposit = "deposit"
    case expense = "expense"
    case refund = "refund"
}

// MARK: - Group Expense Model
struct GroupExpense: Identifiable, Codable, Hashable {
    let id: UUID
    var sessionId: UUID
    var name: String
    var totalAmount: Double
    var currencyCode: String
    var participantIds: [UUID]
    var amountPerPerson: Double
    var expenseDate: Date
    
    init(
        id: UUID = UUID(),
        sessionId: UUID,
        name: String,
        totalAmount: Double,
        currencyCode: String,
        participantIds: [UUID],
        expenseDate: Date = Date()
    ) {
        self.id = id
        self.sessionId = sessionId
        self.name = name
        self.totalAmount = totalAmount
        self.currencyCode = currencyCode
        self.participantIds = participantIds
        self.amountPerPerson = participantIds.isEmpty ? 0.0 : totalAmount / Double(participantIds.count)
        self.expenseDate = expenseDate
    }
    
    var participantCount: Int {
        participantIds.count
    }
}
