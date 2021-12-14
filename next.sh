#!/bin/zsh
emulate -LR zsh # reset zsh options

# Find the next day
next=$(ls Day* |  wc -l)
next=$((next+1))
# Create the code and text files
cp "Template.swift" "Day$next.swift"
touch "./data/day$next.txt"
echo "Created Day$next.swift and ./data/day$next.txt"
# Open the
/usr/local/bin/code "./data/day$next.txt"
/usr/local/bin/code "./Day$next.swift"