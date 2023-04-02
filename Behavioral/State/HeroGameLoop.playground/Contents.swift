import Cocoa
import GameplayKit

// Entity

class Hero {
    
    lazy var stateMachine: GKStateMachine = {
        GKStateMachine(states: [
            HeroIdleState(self),
            HeroWalkState(self),
            HeroCombatState(self),
            HeroDeadState(self)
        ])
    }()
    
    var life = 3
    
    init() {}
    
    func start() {
        stateMachine.enter(HeroIdleState.self)
    }
    
    func recover() {
        if hero.life < 3 {
            hero.life += 1
        }
    }
    
}

// State machine is not implemented because the example is using the GameplayKit one.
// GKStateMachine

// States

class HeroIdleState: GKState {
    
    unowned var hero: Hero
    
    required init(_ hero: Hero) {
        self.hero = hero
    }
    
    override func didEnter(from previousState: GKState?) {
        hero.recover()
        print("🧘 Hero is idle, current life \(hero.life)")
        if Bool.random() {
            hero.stateMachine.enter(HeroIdleState.self)
        } else {
            hero.stateMachine.enter(HeroWalkState.self)
        }
    }
    
}

class HeroWalkState: GKState {
    
    unowned var hero: Hero
    
    required init(_ hero: Hero) {
        self.hero = hero
    }
    
    override func didEnter(from previousState: GKState?) {
        print("🚶 Hero is walking")
        switch Int.random(in: 0...2) {
            case 0: hero.stateMachine.enter(HeroIdleState.self)
            case 1: hero.stateMachine.enter(HeroWalkState.self)
            default: hero.stateMachine.enter(HeroCombatState.self)
        }
    }
}

class HeroCombatState: GKState {
     
    unowned var hero: Hero
    private var currentEnemyLife = 0
    
    required init(_ hero: Hero) {
        self.hero = hero
    }
    
    override func didEnter(from previousState: GKState?) {
        restartLife()
        print("🤺 Hero is fighting agains monster with \(currentEnemyLife) life points")
        fight()
    }
    
    private func fight() {
        if Bool.random() {
            currentEnemyLife -= 1
            print("💥 Damage to monster, current life: \(currentEnemyLife)")
        } else {
            hero.life -= 1
            print("🤕 Damage to hero, current life: \(hero.life)")
        }
        
        if hero.life <= 0 {
            hero.stateMachine.enter(HeroDeadState.self)
            return
        }
        
        if currentEnemyLife <= 0 {
            hero.stateMachine.enter(HeroIdleState.self)
            return
        }
        
        fight()
    }
    
    private func restartLife() {
        currentEnemyLife = Int.random(in: 1...3)
    }
}

class HeroDeadState: GKState {
    
    unowned var hero: Hero
    
    required init(_ hero: Hero) {
        self.hero = hero
    }
    
    override func didEnter(from previousState: GKState?) {
        print("💀 Hero is dead")
    }
}

// Run

let hero = Hero()
hero.start()
