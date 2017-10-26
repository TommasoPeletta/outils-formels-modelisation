import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
      let m0 = MarkingGraph(marking: marking) //MarkingGraph avec marquage initial inisialise
      var m2 = [MarkingGraph]() //liste vide avec marquage traiter
      var m1 = [m0] //liste avec marquage à traiter
      while m1.last != nil { //si la liste avec les marquage à traiter est vide
        let marking_courant = m1.popLast() //on definit le marquage à traiter comem le dernier element de m1
        m2.append(marking_courant!) //on passe le marquage courant comme traiter
        let marquage_courant = marking_courant!.marking
        for i in self.transitions { //pour toutes les transitions dans notre model
        if i.fire(from: marquage_courant) != nil { // si il est possible de tirer la transision i depuis le marquage courant
          let m_next = i.fire(from: marquage_courant)
          if m2.contains(where: {$0.marking == m_next!}) { // si le marquage succesive est deja dans la liste des marquage a traiter
            marking_courant!.successors[i] = m2.first(where: {$0.marking == m_next!}) //le marquage succesive est egale aux markingGraph deja contenu dans m2
          } else if m1.contains(where: {$0.marking == m_next!}) {// si le marquage succesive est deja dans m1
            marking_courant!.successors[i] = m1.first(where: {$0.marking == m_next!}) } //le marquage succesive est egale aux marquage contenu dans m1
            else { // si non
            let n = MarkingGraph(marking : m_next!)
            marking_courant!.successors[i] = n //le marquage succesive et le resultat du i.fire
            m1.append(n) //on mais le marquage trouver comme marquage à traiter
          }
        }
      }
    }
    return m0
  }
}
