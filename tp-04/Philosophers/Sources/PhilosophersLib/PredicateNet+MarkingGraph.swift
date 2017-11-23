extension PredicateNet {

      public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
        let m0 = PredicateMarkingNode<T> (marking: marking, successors: [:]) //PredicateMarkingNode avec marquage initial initialise
        var m2 = [m0] //liste vide avec marquage à traiter
        var m1 = [m0] //liste avec marquage traiter
        var bind = [PredicateTransition<T>.Binding] () // liste des binding
        while m2.last != nil { //si la liste avec les marquage à traiter est vide
          let marking_courant = m2.popLast() //on definit le marquage_courant comme le dernier element de m2
          m1.append(marking_courant!) //on passe le marquage courant comme traiter
          let marquage_courant = marking_courant!.marking
          for i in self.transitions { //pour toutes les transitions dans notre model
          bind = i.fireableBingings(from : marquage_courant)
          var new_bind : PredicateBindingMap<T> = [:]
          for b in bind{ //pour tous le binding
          if i.fire(from: marquage_courant, with: b) != nil { // si il est possible de tirer la transision i depuis le marquage courant
          let m_next = i.fire(from: marquage_courant, with:b)
          let new_m = PredicateMarkingNode<T>(marking: m_next!, successors: [:]) //nouveau marquage optenue
            if (m1.contains(where: {PredicateNet.greater(new_m.marking, $0.marking)}) == true) { //si new_m.marking est plus grand que $0.marking
            return nil
            }
             if (m1.contains(where: {PredicateNet.equals( $0.marking, new_m.marking)}) == false){ //si on à pas ancore traiter le nouveaux marquage
              m1.append(new_m) //on mais le marquage trouver comme marquage à traiter
              m2.append(new_m)
              new_bind[b]=new_m
              marking_courant!.successors.updateValue(new_bind, forKey: i)
            }else{ // si on a deja traiter le nouveau marquage
              for n in m1 { //on parcoure les marquage traitè
                if PredicateNet.equals( n.marking, new_m.marking) == true{
                  new_bind[b] = n
                  marking_courant!.successors.updateValue(new_bind, forKey: i)//le successors c'est le marquage deja traitè
                }
              }
            }
          }
        }
      }
    }
    return m0
  }
    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard rhs[place]!.contains(t) else { return false }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.contains(t) else { return false }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
