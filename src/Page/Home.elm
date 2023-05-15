module Page.Home exposing (..)

import Element as El exposing (Attribute)
import Element.Input as Inp
import Html exposing (Html)
import Types.Student exposing (Student)


-- VIEW

type Model
    = Empty
    | Loading
    | Table (List Student)


noTablePadding : Attribute Msg
noTablePadding =
    El.padding 40

loading : Html Msg
loading =
    El.layout [ noTablePadding ] <| El.text "Loading..."

noTable : Html Msg
noTable =
    El.layout [ noTablePadding ] <|
        El.column []
            [ El.text "It looks like there's nothing here"
            , Inp.button []
                { onPress = Just <| NewStudent 0
                , label = El.text "Add Student"
                }
            ]

studentTable : List Student -> Html Msg
studentTable students =
    El.layout [] <|
        El.table []
            { data = students 
            , columns =
                [ 
                ]
            }

-- MSG

type Msg
    = Create Student
    | Read Student
    | Update Student
    | Delete Student
    | NewStudent Int