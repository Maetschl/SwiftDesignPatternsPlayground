import Cocoa

class BoxOffice {
    let numberOfTickets = 4
    var ticketsSold = 0
    
    func buyATicket() -> Bool {
        if(numberOfTickets == ticketsSold) { return false }
        ticketsSold += 1
        return true
    }
}

// 1.- Protocol to define the class behavior
protocol SellTicketsProtocol {
    func buyATicket() -> Bool
}

// 2.- Probably the BoxOffice class will be declared elsewhere, like a library, which we can't modify
extension BoxOffice: SellTicketsProtocol { }

// 3.- Proxy pattern to extend the functionality without modify the main class or the implementation
class BoxOfficeWithLoggingProxy: SellTicketsProtocol {
    private let boxOffice: SellTicketsProtocol
    
    init(_ boxOffice: SellTicketsProtocol) {
        self.boxOffice = boxOffice
    }
    
    func buyATicket() -> Bool {
        let boxOfficeResponse = boxOffice.buyATicket()
        let message = "Bought ticket at \(Date())"
        print(boxOfficeResponse ? message: "There aren't enough tickets.")
        return boxOfficeResponse
    }
}

// It's possible nest more than 1 proxy?
class BoxOfficeWithPeopleCount: SellTicketsProtocol {
    private var count = 0
    private let boxOffice: SellTicketsProtocol
    
    init(_ boxOffice: SellTicketsProtocol) {
        self.boxOffice = boxOffice
    }
    
    func buyATicket() -> Bool {
        if(boxOffice.buyATicket()) {
            count += 1
            return true
        } else {
            print("The cinema has reached full capacity with \(count) people.")
            return false
        }
    }
}

// Examples
let boxOffice: SellTicketsProtocol = BoxOffice()
//let boxOffice: SellTicketsProtocol = BoxOfficeWithLoggingProxy(BoxOffice())
//let boxOffice: SellTicketsProtocol = BoxOfficeWithPeopleCount(BoxOfficeWithLoggingProxy(BoxOffice()))
for _ in 0 ... 5 {
    boxOffice.buyATicket()
}
