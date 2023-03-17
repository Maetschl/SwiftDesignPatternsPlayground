import Cocoa

protocol Monster {
    var name: String { get }
}

class Beholder: Monster {
    
    var name: String {
        "\(numberOfEyes) eyes Beholder"
    }
    
    var numberOfEyes: Int
    
    init() {
        self.numberOfEyes = Bool.random() ? 5: 11
    }
}

class Elemental: Monster {
    
    enum Element: CaseIterable {
        case Fire
        case Holy
        case Electro
        case Ice
        case Water
    }
    
    var name: String {
        "\(element) Elemental lvl \(lvl)"
    }
    
    var element: Element = Element.allCases.randomElement()!

    var lvl: Int = Int.random(in: 1...20)
}

// MARK: - Factory -

protocol MonsterFactory {
    func create() -> Monster
}

class ElementalFactory: MonsterFactory {
    func create() -> Monster {
        Elemental()
    }
}

class BeholderFactory: MonsterFactory {
    func create() -> Monster {
        Beholder()
    }
}

class RandomFactory: MonsterFactory {
    func create() -> Monster {
        Bool.random() ? Elemental(): Beholder()
    }
}

// MARK: - Factory Use -

class Spawner {
    
    private let factory: MonsterFactory
    
    init(factory: MonsterFactory) {
        self.factory = factory
    }
    
    func start() {
        for i in 0 ... 10 {
            let monster = factory.create()
            print("[\(i)] Spawn: \(monster.name)")
            sleep(1)
        }
    }
}

let spawner = Spawner(factory: BeholderFactory())
// let spawner = Spawner(factory: ElementalFactory())
// let spawner = Spawner(factory: RandomFactory())

spawner.start()
