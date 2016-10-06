//
//  main.swift
//  stodo
//
//  Created by Hiroki Nagasawa on 10/6/16.
//  Copyright © 2016 Hiroki Nagasawa. All rights reserved.
//

import Commandant
import StodoKit

let registry = CommandRegistry<StodoError>()
registry.register(ListCommand())
registry.register(AddCommand())
registry.register(DoneCommand())
registry.register(UndoneCommand())
registry.register(DeleteCommand())
registry.register(VersionCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}
