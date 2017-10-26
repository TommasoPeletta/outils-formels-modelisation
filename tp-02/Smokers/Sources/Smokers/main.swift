import PetriKit
import SmokersLib
import Foundation

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

try model.saveAsDot(to: URL(fileURLWithPath: "model.dot"), withMarking: [r: 1, w1: 1, w2: 1, w3:1])
// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// function implementè en classe pour compter les etats en parcourant le markinggraph
public func countNodes(markingGraph: MarkingGraph)-> Int {
  var seen = [markingGraph]
  var toVisit = [markingGraph]
  while let current = toVisit.popLast(){
    for(_,successors) in current.successors {
      if !seen.contains(where: {$0 === successors}){
        seen.append(successors)
        toVisit.append(successors)
      }
    }
  }
  return seen.count
}

/* *******************************************************************************************
Cette focntion permet de savoir si il est possible que deux fumeurs fumes aux meme temps.
l'ideè c'est de parcourir notre markingraph (1)
est tester à chaque iteration si il y a deux fumeurs aux meme temps (2).
la fonction return 1 si il y a deux fumeurs aux meme temps (3)
la fonction return 0 si il est pas possible que deux fumeurs fume aux meme temps (4)
******************************************************************************************** */
public func fumeurs_aux_meme_temps(markingGraph: MarkingGraph) -> Int {
  var seen = [markingGraph]
  var toVisit = [markingGraph]
  while let current = toVisit.popLast(){ //(1)
    for(_,successors) in current.successors {//(1)
      if !seen.contains(where: {$0 === successors}){//(1)
        seen.append(successors)//(1)
        toVisit.append(successors)//(1)
        let a = successors.marking[s1]//(1)
        let b = successors.marking[s2]//(1)
        let c = successors.marking[s3]//(1)
        if (a == 1 && b == 1) || (a == 1 && c == 1) || (b == 1 && c == 1) {//(2)
          return 1 //(3)
        }
      }
    }
  }
      return 0//(4)
    }
/***********************************************************************************************
Cette fonction permet de savoir si il est possible que il y a deux ingredient ègale sur la table.
l'ideè c'est de parcourir notre markingraph (1)
est tester à chaque iteration si il y a deux ingredient ègale sur la table (2).
la fonction return 1 si il y a deux ingredient ègale sur la table (3)
la fonction return 0 si il n'y a pas deux ingredient ègale sur la table (4)
************************************************************************************************/
  public func two_ingredient(markingGraph: MarkingGraph) -> Int {
    var seen = [markingGraph]
    var toVisit = [markingGraph]
    while let current = toVisit.popLast(){ //(1)
      for(_,successors) in current.successors { //(1)
        if !seen.contains(where: {$0 === successors}){ //(1)
          seen.append(successors) //(1)
          toVisit.append(successors) //(1)
          let a = successors.marking[p]
          let b = successors.marking[t]
          let c = successors.marking[m]
          if (a == 2 || b == 2 || c == 2) { //(2)
            return 1 //(3)
          }
        }
      }
    }
        return 0 //(4)
  }

  // Main on lance les fonction pour notre resaux
if let markingGraph = model.markingGraph(from: initialMarking) {
  let Ex_4_a = countNodes(markingGraph: markingGraph)
  print("nombres d'etat:")
  print(Ex_4_a)
  if 1 == fumeurs_aux_meme_temps(markingGraph: markingGraph) {
    print("deux fumeurs peuvent fumer aux meme temps")
  } else {
    print("deux fumeurs ne peuvent pas fumer aux meme temps")
  }
  if 1 == two_ingredient(markingGraph: markingGraph) {
    print("il est possible de avoir deux fois le meme ingredient sur la table")
  } else {
    print("il n'est pas possible de avoire le meme ingredient sur la table")
}
}
