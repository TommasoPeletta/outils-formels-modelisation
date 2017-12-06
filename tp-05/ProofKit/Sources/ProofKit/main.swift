import ProofKitLib
/// Quelque example
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"
let ff: Formula = "ff"
let e: Formula = "e"
let g: Formula = "g"
let h: Formula = "h"
let f1 = (!d) || ((a || b) && (c || g))
let f2 = a => (b => c)
let f3 = a || (b || (c && a))
let f4 = (a || d) && (c || !(b || g) && h)
let f5 = (g => (h && (c || (ff => e)))) && ((ff || (g && h)) => (a || b))
print("f1")
print(f1.nnf)
print(f1.cnf)
print(f1.dnf)
print("f2")
print(f2.nnf)
print(f2.cnf)
print(f2.dnf)
print("f3")
print(f3.nnf)
print(f3.cnf)
print(f3.dnf)
print("f4")
print(f4.nnf)
print(f4.cnf)
print(f4.dnf)
print("f5")
print(f5.nnf)
print(f5.cnf)
print(f5.dnf)

let f = a && b

//print(f)

let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)
