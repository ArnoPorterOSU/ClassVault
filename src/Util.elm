module Util exposing
    ( uncurry
    , maybeToBool
    , inRange
    , guard
    , flip
    , on
    , group
    , groupBy
    , groupWith
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


-- filters the arguments to a binary function `f` through a unary function `g`
on : (b -> b -> c) -> (a -> b) -> a -> a -> c
on f g x y =
    f (g x) (g y)


-- splits a list into the longest possible list of elements taken from the front that satisfy a given predicate
-- and the rest of the elements
span : (a -> Bool) -> List a -> (List a, List a)
span p xxs =
    case xxs of
        [] ->
            ([], [])
        
        x::xs ->
            if p x then
                let
                    (ys, zs) = span p xs
                in
                    (x :: ys, zs)
            else
                ([], xxs)


-- takes a binary predicate and groups a list into sublists whose elements all satisfy
-- that predicate with the first element of each group
groupWith : (a -> a -> Bool) -> List a -> List (List a)
groupWith eq xxs =
    case xxs of
        [] ->
            []
        
        x::xs ->
            let
                (ys, zs) = span (eq x) xs
            in
                (x :: ys) :: groupWith eq zs


-- takes a key function and runs elements through the key function
-- before grouping them with (==)
groupBy : (a -> b) -> List a -> List (List a)
groupBy =
    groupWith << on (==)


-- groupWith (==). groups a list into sublists of equal elements
group : List a -> List (List a)
group =
    groupWith (==)