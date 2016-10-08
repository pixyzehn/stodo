# stodo
Swifty command-line tool for todo list.

```
$ stodo
Available commands:

   add       Create a new task
   delete    Delete a task if it exists
   done      Check done mark in a task
   help      Display general or command-specific help
   list      Show a list of your tasks
   move      Move your tasks
   rename    Rename your task
   reset     Reset all your task
   undone    Remove done mark in a task
   version   Display the current version
```

## Installation

Install the `stodo` command line tool by running git clone for this repo followed by `make install` in the root directory.
```
$ git clone git@github.com:pixyzehn/stodo.git
$ make install
```

## Usage

### TOC
- [Add](https://github.com/pixyzehn/stodo#add)
- [Delete](https://github.com/pixyzehn/stodo#delete)
- [Done](https://github.com/pixyzehn/stodo#done)
- [Help](https://github.com/pixyzehn/stodo#help)
- [List](https://github.com/pixyzehn/stodo#list)
- [Move](https://github.com/pixyzehn/stodo#move)
- [Rename](https://github.com/pixyzehn/stodo#rename)
- [Reset](https://github.com/pixyzehn/stodo#reset)
- [Undone](https://github.com/pixyzehn/stodo#undone)
- [Version](https://github.com/pixyzehn/stodo#version)

### Add
```
$ stodo add 'Check new application'
[x] 001: Buy milk after work
[ ] 002: Call Taro
[ ] 003: Grab coffee at cafe
[ ] 004: Check new application
```

#### Add options
- `-d` or `--done` : Add a new task with a status of done.

### Delete
```
$ stodo delete 2
[x] 001: Buy milk after work
[ ] 003: Grab coffee at cafe
[ ] 004: Check new application
```

#### Delete options
None.

### Done
```
$ stodo done 3
[x] 001: Buy milk after work
[x] 003: Grab coffee at cafe
[ ] 004: Check new application
```

#### Done options
None.

### Help
```
$ stodo help
Available commands:

   add       Create a new task
   delete    Delete a task if it exists
   done      Check done mark in a task
   help      Display general or command-specific help
   list      Show a list of your tasks
   move      Move your tasks
   rename    Rename your task
   reset     Reset all your task
   undone    Remove done mark in a task
   version   Display the current version
```

#### Help options
None.

### list
```
$ stodo list
[x] 001: Buy milk after work
[x] 003: Grab coffee at cafe
[ ] 004: Check new application

$ stodo list -m -t -d
- [x] Buy milk after work    | 2016/10/08 20:13:06
- [x] Grab coffee at cafe    | 2016/10/08 14:43:27
```
#### List options
- `-m` or `--markdown` : Show todo list by markdown.
- `-t` or `--time` : Show todo list with `createdAt` or `updatedAt` if it has.
- `-d` or `--done` : Show only done tasks.
- `-u` or `--undone` : Show only undone tasks.

### Move
```
$ stodo move 1 3
[x] 003: Grab coffee at cafe
[x] 001: Buy milk after work
[ ] 004: Check new application
```

#### Move options
None.

### Rename
```
$ stodo rename 3 'Grab coffee at home'
[ ] 003: Grab coffee at home
[x] 001: Buy milk after work
[ ] 004: Check new application
```

### Rename options
None.

### Reset
```
$ stodo reset
```
:warning: Delete all your task.

#### Reset options
None.

### Undone
```
$ stodo undone 1
[ ] 003: Grab coffee at home
[ ] 001: Buy milk after work
[ ] 004: Check new application
```

#### Undone options
None.

### Version
```
$ stodo version
```
Show the current version.

### Todo
- Setting .stodo file path. (default path is HOME)

## Author
[pixyzehn](https://github.com/pixyzehn)

## License
[MIT License](https://github.com/pixyzehn/stodo/blob/master/LICENSE)
