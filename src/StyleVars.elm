module StyleVars exposing
    ( standardPadding
    , standardSpacing
    , white
    , interactibleColor
    , interactibleMouseOverColor
    )


import Element exposing (Color, rgb255)


standardPadding : Int
standardPadding =
    10

standardSpacing : Int
standardSpacing =
    5


white : Color
white =
    rgb255 255 255 255
    

interactibleColor : Color
interactibleColor =
    rgb255 95 171 220


interactibleMouseOverColor : Color
interactibleMouseOverColor =
    rgb255 30 96 138