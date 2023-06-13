module Route exposing
    ( Route(..)
    , fromUrl
    )


import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)


-- ROUTING
type Route
    = Home
    | Stats


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Stats <| Parser.s "stats"
        ]

    
-- PUBLIC
fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse parser