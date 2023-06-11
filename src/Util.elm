module Util exposing
    ( uncurry
    , maybeToBool
    , inRange
    , guard
    , flip
    )


-- uncurry takes a function and undoes the
-- default "currying" that Elm does
--
-- in other words, it takes a function that
-- returns a function and turns it
-- into a function that takes a pair
uncurry : (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) =
    f x y


-- maybeToBool takes a Maybe value
-- it converts all Just values into True
-- and Nothing values into False
maybeToBool : Maybe a -> Bool
maybeToBool m =
    case m of
        Nothing ->
            False

        _ ->
            True


-- inRange takes a pair of comparables and a third
-- comparable of the same type and tests whether the third number is
-- in range of the first two
inRange : comparable -> comparable -> comparable -> Bool
inRange low high x =
    low <= x && x <= high


-- returns Nothing if the predicate p fails
guard : (a -> Bool) -> a -> Maybe a
guard p x =
    if p x then
        Just x
    else
        Nothing


-- flips the arguments to a binary function around
flip : (a -> b -> c) -> b -> a -> c
flip f x y =
    f y x