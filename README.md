# 👥🥷👥 Ura Kata

A modest, modal REPL for Godot.

> **Caution:** This project is currently a work in progress (WIP). It is not yet ready for production use.


## Screenshots

### Code mode
<img src="images/screenshots/urakata-code-screenshot.png" alt="Code mode screenshot">


## Usage

Ura Kata provides multiple interactive modes.
When the input line is empty, typing a specific single character switches the current mode.

* **Default:** Code mode
* **`;`** switches to Shell mode
* **`?`** switches to Help mode
* **`/`** switches to Task mode


### Code mode (default)

```
code> 1 + 1
=>  2

code> var x = 1
=> null

code> x
=> 1

code> sin(x)
=> 0.8414709848079

code> func foo(): return 'foo!'
=> null

code> foo()
=> 'foo!'

code> EditorInterface
=> <EditorInterface#11072962786>

code> EditorInterface.get_editor_scale()
=> 2.0
```

To reset the execution environment, type `reload!`.
```
code> x
=> 1

code> reload!
Reloaded.

code> x
ERROR: Invalid named index 'x' for base type Object
ERROR: gdscript://-9223352824325131985.gd:2 - Parse Error: Identifier "x" not declared in the current scope.
=> <null>
```

You also have access to several utility variables and helper methods.
```
code> current
=> REPL:<HBoxContainer#1741055663592> # eturns the root node of the currently edited scene.
```


## Installation

1. Download the addons.tar.gz from the release.
2. Extract the addons.tar.gz and place the redscribe directory into (Your godot project root)/addons directory.
3. Open the project settings and enable Urakata.

