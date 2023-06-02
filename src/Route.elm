module Route exposing
    ( Route(..)
    , fromUrl
    , replaceUrl
    )


import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)


-- ROUTING
type Route
    = Home
    -- | Calendar
    -- | Stats
    -- | Login
    -- | Logout
    -- | Register


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
    --    , Parser.map Calendar <| Parser.s "calendar"
    --    , Parser.map Stats <| Parser.s "stats"
    --    , Parser.map Login <| Parser.s "login"
    --    , Parser.map Logout <| Parser.s "logout"
    --    , Parser.map Register <| Parser.s "register"
        ]

    
-- PUBLIC
replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key <| routeToString route


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser


-- PRIVATE
routeToString : Route -> String
routeToString page =
    "#/" ++ case page of
        Home ->
            ""
    {-
        Calendar ->
            "calendar"
        
        Stats ->
            "stats"

        Login ->
            "login"
        
        Logout ->
            "logout"
        
        Register ->
            "register"
    -}