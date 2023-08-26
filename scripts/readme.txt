For commands.rb create the file data/commands.data

Inside that file fill it with lines like:

dolphin ; some comand
dolphin ; some other command
tilix ; some command

Then when you use the smart button on dolphin or tilix it will show their commands.

In order for this to work, set `xcommands = true` in the rules of these clients.

Else the smart button will minimize them or reset their rules.
