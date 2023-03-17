import Cocoa

protocol PasswordValidatorStep: AnyObject {
    var nextValidation: PasswordValidatorStep? { get set }
    func validate(_ password: String) -> Bool
    func setNext(_ validation: PasswordValidatorStep) -> PasswordValidatorStep
}

extension PasswordValidatorStep {
    func setNext(_ validation: PasswordValidatorStep) -> PasswordValidatorStep {
        self.nextValidation = validation
        return validation
    }
}

class PasswordNotEmpty: PasswordValidatorStep {
    var nextValidation: PasswordValidatorStep?
    
    func validate(_ password: String) -> Bool {
        if !password.isEmpty {
            return nextValidation?.validate(password) ?? true
        }
        return false
    }
}

class PasswordLowerAndUppercase: PasswordValidatorStep {
    var nextValidation: PasswordValidatorStep?
    
    func validate(_ password: String) -> Bool {
        if password.uppercased() != password && password.lowercased() != password {
            return nextValidation?.validate(password) ?? true
        }
        return false
    }
}

class PasswordWithCharacter: PasswordValidatorStep {
    var nextValidation: PasswordValidatorStep?
    let character: Character
    
    public init(character: Character) {
        self.character = character
    }
    
    func validate(_ password: String) -> Bool {
        print(password)
        print(self.character)
        if password.contains(self.character) {
            return nextValidation?.validate(password) ?? true
        }
        return false
    }
}

class PasswordSize: PasswordValidatorStep {
    var nextValidation: PasswordValidatorStep?
    let minSize, maxSize: Int
    
    public init(minSize: Int = 6, maxSize: Int = 12) {
        self.minSize = minSize
        self.maxSize = maxSize
    }
    
    func validate(_ password: String) -> Bool {
        if password.count >= minSize && password.count < maxSize {
            return nextValidation?.validate(password) ?? true
        }
        return false
    }
}


let passwordValidator = PasswordNotEmpty()
passwordValidator
    .setNext(PasswordSize(minSize: 10))
    .setNext(PasswordWithCharacter(character: "S"))
    .setNext(PasswordLowerAndUppercase())

let password = "ASD123as"

print(passwordValidator.validate(password))
