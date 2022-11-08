Show an overlay in the middle of the screen.

For instance to show desktop number on tag change.

```lua
args.delay = args.delay or 2
args.bgcolor = args.bgcolor or "#000000"
args.fontcolor = args.fontcolor or "#ffffff"
args.font = args.font or "monospace 20"
```

```lua
local overlay = require("madwidgets/overlay/overlay")

Overlay = overlay.create({
  delay = 2,
  bgcolor = "#000000",
  fontcolor = "#ffffff"
})

Overlay.show("some text")
```