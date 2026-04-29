# 👥🥷👥 Ura Kata (裏方)

A modest, modal REPL for Godot.

Demo Video: https://www.youtube.com/watch?v=7tLOr-d4Qek


## Screenshots

### Code mode
<img src="images/screenshots/urakata-code-screenshot.png" alt="Code mode screenshot">

### Shell mode
<img src="images/screenshots/urakata-shell-screenshot.png" alt="Shell mode screenshot">


## Usage

Ura Kata provides multiple interactive modes.
When the input line is empty, typing a specific single character switches the current mode.

* **Default:** Code mode
* **`;`** switches to Shell mode


### Code mode (default)

```
code> 1 + 1
=> 2

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
# `current` returns the root node of the currently edited scene.
code> current
=> REPL:<HBoxContainer#1741055663592>

# `ls` shows a combined list of `Engine.get_singleton_list()` and `ProjectSettings.get_global_class_list()`.
code> ls
Performance                Engine                     ProjectSettings        OS                        Time
TextServerManager          NavigationServer2DManager  PhysicsServer2DManager NavigationServer3DManager PhysicsServer3DManager
NavigationMeshGenerator    IP                         Geometry2D             Geometry3D                ResourceLoader
ResourceSaver              ClassDB                    Marshalls              TranslationServer         Input
InputMap                   EngineDebugger             GDExtensionManager     ResourceUID               WorkerThreadPool
ThemeDB                    EditorInterface            JavaClassWrapper       JavaScriptBridge          AudioServer
CameraServer               DisplayServer              NativeMenu             RenderingServer           NavigationServer2D
NavigationServer3D         PhysicsServer2D            PhysicsServer3D        XRServer                  GDScriptLanguageProtocol
GDScriptInteractiveSession GutErrorTracker            GutHookScript          GutInputFactory           GutInputSender
GutMain                    GutStringUtils             GutTest                GutTestMeta               GutTrackedError
GutUtils                   Helper                     Urakata                UrakataCodeMode           UrakataMode
UrakataShellMode 
=> <null>

# `ls target` shows the methods of a given target.
code> ls current
HBoxContainer
  void free()                         String get_class()           void submit()       void linebreak()
  void clear_prompt()                 void remove_following_text() void history_back() void history_forward()
  void change_mode(mode: UrakataMode) 
=> <null>
```


### Shell mode (`;`)
```
shell> ls
addons
dev
icon.svg
icon.svg.import
images
LICENSE
project.godot
Rakefile
README.md
test
tmp

shell> ls -lA addons/urakata
total 24
-rw-r--r--@ 1 fujisetakumi  staff  127  4月 25 21:04 plugin.cfg
drwxr-xr-x@ 4 fujisetakumi  staff  128  4月 25 22:12 resources
drwxr-xr-x@ 5 fujisetakumi  staff  160  4月 24 21:24 src
-rw-r--r--@ 1 fujisetakumi  staff  427  4月 23 21:52 urakata.gd
-rw-r--r--@ 1 fujisetakumi  staff   19  4月 22 21:25 urakata.gd.uid
```


## Installation

1. Download the addons.tar.gz from the [release](https://github.com/tkmfujise/urakata/releases).
2. Extract the addons.tar.gz and place the redscribe directory into (Your godot project root)/addons directory.
3. Open the project settings and enable Ura Kata.


## Customization

### Adding a Custom mode

Ura Kata allows you to extend the REPL by adding your own modes.

A mode is simply a script that inherits `UrakataMode` and implements `perform(text: String)`.

#### 1. Define a mode Script
```gdscript
@tool
extends UrakataMode
class_name UrakataXxxMode

func perform(text: String) -> Variant:
	var result = null
	# do_something
	return result
```

#### 2. Register the mode in the REPL
Open the scene `addons/urakata/src/repl/repl.tscn`.

In the Inspector, find the *Modes* array.

<img src="images/screenshots/urakata-repl-modes-in-inspector-screenshot.png" alt="REPL modes in Inspector screenshot">

Add a new element and set the following fields:
* **Label**: Display name of the mode
* **Emoji**: Icon shown in the REPL prompt
* **Color**: Accent color for the mode
* **Character**: Prefix character to activate the mode (e.g. `?`, `/`)


## Roadmap

### v0.1.0
* [x] Simple Code mode
* [x] Simple Shell mode

### v0.1.1
* [x] Bug fix
  * [x] Code mode
    * [x] Lambda is not working (e.g. `[1, 2].map(func(i): return i)`.

### v0.2.0 or later
* [ ] Add other useful modes
* [ ] Bug fix
  * [ ] Code mode
    * [ ] Value reassignment fails. (e.g. `var x = 1` then `x = 2` fails)

