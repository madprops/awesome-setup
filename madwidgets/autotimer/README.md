```lua
function auto_suspend(minutes)
  autotimer.start("Suspend", function() suspend() end, minutes)
end
```

Use this to perform an action after some minutes.

A widget has to be created to show how many minutes are left.

First initialize autotimer:

```lua
autotimer = require("madwidgets/autotimer/autotimer")
autotimer.create({left = " ", right = " "})
```

Then place autotimer where you want the container widget:

```
[widget],
autotimer,
[widget],
```

Middle clicking the widgets cancels the actions.

## Example timer tool

First make a lua function:

```lua
function timer(minutes)
  autotimer.start("Timer", function() 
    msg("Timer ended") 
  end, minutes)
end
```

Then make a python script:

```python
import os
from subprocess import Popen, PIPE

# Get input information using rofi
def get_input(prompt: str) -> str:
  proc = Popen(f"rofi -dmenu -p '{prompt}'", stdout=PIPE, stdin=PIPE, shell=True, text=True)
  return proc.communicate()[0].strip()

def main() -> None:
  minutes = get_input("Enter minutes")
  os.popen(f"awesome-client 'timer({minutes})'").read()

if __name__ == "__main__": main()
```