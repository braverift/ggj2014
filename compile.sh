clear
(killall -9 "Flash Player Debugger" || true) &&
(echo "mxmlc -debug=true Game/src/GGJ2K4.as -o Game/bin/GGJ2K4.swf" | fcsh) &&
open Game/bin/GGJ2K4.swf


