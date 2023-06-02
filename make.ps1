New-Item -Path . -Name 'static' -ItemType directory -Force
elm make src/Main.elm --output 'static/elm.js'