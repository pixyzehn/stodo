# stodo
Swifty command-line tool for todo list.

```
$ stodo help
Available commands:

   add       Add a new task if it exists
   delete    Delete a task if it exists
   done      Check done mark
   help      Display general or command-specific help
   list      Show a list of your tasks
   undone    Remove done mark
   version   Display the current stodo
```

## Installation

To be added...

## Usage

### list
```
$ stodo list
[x] 001: Buy milk after work
[ ] 002: Call Taro
[ ] 003: Grab coffee with Satoshi
```
#### List options
- `-m` or `--markdown` : Show todo list by markdown.
- `-t` or `--time` : Show todo list with `createdAt` or `updatedAt`.
- `-d` or `--done` : Show only done tasks.
- `-u` or `--undone` : Show only undone tasks.

### Add
```
$ stodo add 'Check new application'
[x] 001: Buy milk after work
[ ] 002: Call Taro
[ ] 003: Grab coffee with Satoshi
[ ] 004: Check new application
```

#### Add options
- `-d` or `--done` : Add new task with a status of done.

### Done
```
$ stodo done 3
[x] 001: Buy milk after work
[ ] 002: Call Taro
[x] 003: Grab coffee with Satoshi
[ ] 004: Check new application
```

#### Done options
None.

### Undone
```
$ stodo undone 1
[ ] 001: Buy milk after work
[ ] 002: Call Taro
[x] 003: Grab coffee with Satoshi
[ ] 004: Check new application
```

#### Undone options
None.

### Move
```
$ stodo move 2 3
[ ] 001: Buy milk after work
[x] 002: Grab coffee with Satoshi
[ ] 003: Call Taro
[ ] 004: Check new application
```

#### Move options
None.

### Rename
```
$ stodo rename 3 'Call Taro san'
[ ] 001: Buy milk after work
[x] 002: Grab coffee with Satoshi
[ ] 003: Call Taro san
[ ] 004: Check new application
```

### Rename options
None.

### Delete
```
$ stodo delete 2 3
[ ] 001: Buy milk after work
[ ] 004: Check new application
```

#### Delete options
None.

### Reset
```
$ stodo reset
Are you sure to reset your todo list? [y/n]
```

#### Reset options
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
