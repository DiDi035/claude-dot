#!/usr/bin/env -S jq -c -f

def command: (.tool_input.command // "");

if .tool_name == "Bash" and (command | test("Co-Authored-By"; "i"))
then error("Do not add Co-Authored-By or AI attribution to commits. Commit as the user only.")
else empty end
