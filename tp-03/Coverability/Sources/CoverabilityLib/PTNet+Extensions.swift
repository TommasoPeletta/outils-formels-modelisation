import PetriKit
public extension PTNet {


/*******************************************************************************************
La fonction ConvertToCov permet de convertir un CoverabilityMarking dans un PTMarking
l'ideè est de remplacer tous les omega
*******************************************************************************************/
public func ConvertToMarking (from marking: CoverabilityMarking) -> PTMarking {
      var m : PTMarking = [:]
      let token : UInt
      token = 1000
      for place1 in self.places{
        m[place1] = token
        for i in 0...token{
          if UInt(i) == marking[place1]!{ 
            m[place1] = UInt(i)
          }
        }
      }
      return m
    }
/******************************************************************************************
La function ConvertToMarking permet de convertir un  PTMarking dans un CoverabilityMarking
l'ideè c'est de donner un maximum de jeton au-dela de cette valeur on assume que on a omega
Donc sa suffit de changer les valeurs depassant le max de getons par omega
*******************************************************************************************/
    public func ConvertToCov (from marking: PTMarking) -> CoverabilityMarking {
      var c : CoverabilityMarking = [:]
      let token = 1000
      for place1 in self.places{
        if marking[place1]!<token{
          c[place1] = .some(marking[place1]!)
        }else{
          c[place1] = .omega
        }
      }
      return c
    }
    /***********************************************************************************************************************
    Cette fonction permet de verifier si le marquage courant est plus "grand" (condition de omega) d'un marquage deja traitè
    *************************************************************************************************************************/
    public func check(from m0: CoverabilityGraph,from m_next: PTMarking)->CoverabilityMarking {
      var y = ConvertToCov(from: m_next)
      for p in m0{
      if y > p.marking{
        for place1 in self.places{
          if y[place1]! > p.marking[place1]!{
              y[place1] = .omega
          }
        }
      }
    }
    return y
  }

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
      let m0 = CoverabilityGraph(marking: marking) //CoverabilityGraph avec marquage initial inisialise
      var m2 = [CoverabilityGraph]() //liste vide avec marquage traiter
      var m1 = [m0] //liste avec marquage à traiter
      while m1.last != nil { //si la liste avec les marquage à traiter est vide
        let marking_courant = m1.popLast() //on definit le marquage à traiter comem le dernier element de m1
        m2.append(marking_courant!) //on passe le marquage courant comme traiter
        for i in self.transitions { //pour toutes les transitions dans notre model
        if i.fire(from: ConvertToMarking(from: marking_courant!.marking)) != nil { // si il est possible de tirer la transision i depuis le marquage courant
        let m_next = i.fire(from: ConvertToMarking(from: marking_courant!.marking)) //on tire la transition
          /**************************************************************************
          Partie different de la fonction MarkingGraph
          **************************************************************************/
          let x = check(from: m0,from: m_next!) //voir commantaire fonction check
          /********************************************************************************
          *********************************************************************************/
          if m2.contains(where: {$0.marking == x}) { // si le marquage succesive est deja dans la liste des marquage a traiter
            marking_courant!.successors[i] = m2.first(where: {$0.marking == x}) //le marquage succesive est egale aux markingGraph deja contenu dans m2
          } else if m1.contains(where: {$0.marking == x}) {// si le marquage succesive est deja dans m1
            marking_courant!.successors[i] = m1.first(where: {$0.marking == x}) } //le marquage succesive est egale aux marquage contenu dans m1
            else { // si non
            let n = CoverabilityGraph(marking : x)
            marking_courant!.successors[i] = n //le marquage succesive et le resultat du i.fire
            m1.append(n) //on mais le marquage trouver comme marquage à traiter
          }
        }
      }
    }
    return m0
  }
}
