module Page.Home exposing
    ( Model(..)
    , init
    , view
    )


import Html exposing (Html)
import Element as El
import Element.Font as Font
import Types.Name as Name
import Types.Student exposing (Student)


-- MODEL
type Model
    = Loading
    | Students (List Student)
    | Error String


-- VIEW
view : Model -> Html msg
view model =
    El.layoutWith
        { options = [El.noStaticStyleSheet] } [] <|
            case model of
                Students students ->
                    El.table []
                        { data = students
                        , columns =
                            [ { header = El.text "Name"
                            , width = El.fill
                            , view = .name >> Name.toString >> El.text
                            }
                            , { header = El.text "Id Number"
                            , width = El.fill
                            , view = .id >> String.fromInt >> El.text
                            }
                            , { header = El.text "Email"
                            , width = El.fill
                            , view = .email >> El.text
                            }
                            ]
                        }

                Loading ->
                    El.el [Font.size 128] <| El.text "Loading..."

                Error msg ->
                    El.el [] <| El.text msg

init : Model
init =
    Loading