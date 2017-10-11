import TaskManagerLib

let taskManager = createTaskManager()

//on definit les places 
  let taskPool = taskManager.places.first {$0.name == "taskPool"}!
  let processPool = taskManager.places.first {$0.name == "processPool"}!
  let inProgress = taskManager.places.first {$0.name == "inProgress"}!
//on definit les transitions
  let create = taskManager.transitions.first {$0.name == "create"}!
  let exec = taskManager.transitions.first {$0.name == "exec"}!
  let success = taskManager.transitions.first {$0.name == "success"}!
  let fail = taskManager.transitions.first {$0.name == "fail"}!
  let spawn = taskManager.transitions.first {$0.name == "spawn"}!
// on tire les transision
  let m1 = spawn.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
  let m2 = spawn.fire(from: m1!)
  let m3 = create.fire(from: m2!)
  let m4 = exec.fire(from: m3!)
  let m5 = exec.fire(from: m4!)
  let m6 = success.fire(from: m5!) //on ne peut plus tirer succes de nouveau car on avait 2 processus en execution en meme temps sans avoir des tache pour chaque un
  print(m6!)
  //let m7 = success.fire(from: m6!)         ERROR!


let correctTaskManager = createCorrectTaskManager()


//on definit les places
let taskPool2 = correctTaskManager.places.first {$0.name == "taskPool"}!
let processPool2 = correctTaskManager.places.first {$0.name == "processPool"}!
let inProgress2 = correctTaskManager.places.first {$0.name == "inProgress"}!
let control_token2 = correctTaskManager.places.first {$0.name == "control_token"}!
//on definit les transitions
let create2 = correctTaskManager.transitions.first {$0.name == "create"}!
let exec2 = correctTaskManager.transitions.first {$0.name == "exec"}!
let success2 = correctTaskManager.transitions.first {$0.name == "success"}!
let fail2 = correctTaskManager.transitions.first {$0.name == "fail"}!
let spawn2 = correctTaskManager.transitions.first {$0.name == "spawn"}!
// on tire les transisions
let m1a = spawn2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, control_token2: 1]) //on doit avoir un token dans control_token2 pour executer le premier processus
let m2a = spawn2.fire(from: m1a!)
let m3a = create2.fire(from: m2a!)
let m4a = exec2.fire(from: m3a!)//on ne peut pas retirer exec2 car on a pas une tache pour le deuxieme processus donc notre programme se arrete avant de encomencè le deuxieme processus.
print(m4a!)
//let m5a = exec2.fire(from: m4a!)
//let m6a = success2.fire(from: m5a!)
//let m7a = success2.fire(from: m6a!)
