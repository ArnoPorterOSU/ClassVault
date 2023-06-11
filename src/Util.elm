module Util exposing
    ( uncurry
    , maybeToBool
    )


uncurry : (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) =
    f x y


maybeToBool : Maybe a -> Bool
maybeToBool m =
    case m of
        Nothing ->
            False

        _ ->
            True