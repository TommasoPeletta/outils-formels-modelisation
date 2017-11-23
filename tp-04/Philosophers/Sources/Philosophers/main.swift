import PetriKit
import PhilosophersLib

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockFreePhilosophers(n: 5) //pour philosopher de 5 sans bloquage
    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
    let markinggraph = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("nombre des etat pour reasaux sans bloquage", markinggraph!.count) // nombre d'etat
}

do {
    let philosophers = lockablePhilosophers(n: 5) //pour philosopher 5 avec bloquage
    let markinggraph2 = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("nombre des etat pour reasaux avec bloquage",markinggraph2!.count) // nombre d'etat
    for n in markinggraph2!{
      if n.successors.count == 0{ //si l'etat ne a pas de successors alors il y a un bloquage
        print("un etat avec bloquage: ", n.marking)
        break
      }
    }
}
