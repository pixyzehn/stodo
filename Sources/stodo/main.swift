//
//  main.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Foundation
import Commandant
import StodoKit

let registry = CommandRegistry<StodoError>()
registry.register(AddCommand())
registry.register(DeleteCommand())
registry.register(DoneCommand())
registry.register(ListCommand())
registry.register(MoveCommand())
registry.register(RenameCommand())
registry.register(ResetCommand())
registry.register(UndoneCommand())
registry.register(VersionCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}
