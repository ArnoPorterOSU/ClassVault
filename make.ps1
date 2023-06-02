New-Item -Path . -Name 'static' -ItemType directory
elm make src/Main.elm --output 'static/elm.js'