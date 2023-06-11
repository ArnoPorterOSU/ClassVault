module Page.Home exposing
    ( Model
    , Data(..)
    , Msg(..)
    , getStudents
    , init
    , view
    , update
    )


import Http
import Element as El exposing (Element)
import Element.Input as Inp
import Element.Border as Border
import Element.Background as Bg
import Element.Font as Font
import Json.Decode as D
import Types.Name as Name
import Types.Student as Student exposing (Student)
import StyleVars
import Util exposing (maybeToBool)


-- MODEL
type alias Model =
    { menu : Maybe Menu
    , data : Data
    }


type Data
    = Loading
    | Students (List Student)
    | Error String


type alias Menu =
    { name : String
    , nameBad : Bool
    }


-- MSG
type Msg
    = GotStudents (Result Http.Error (List Student))
    | ToggleMenu
    | NameUpdate String


-- UPDATE
defaultMenu : Menu
defaultMenu =
    { name = ""
    , nameBad = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotStudents result ->
            { model
            | data = case result of
                Ok students ->
                    Students students
                    
                Err _ ->
                    Error "Something went wrong"
            }
        
        ToggleMenu -> 
            { model
            | menu =
                case model.menu of
                    Nothing ->
                        Just defaultMenu

                    _ ->
                        Nothing
            }

        NameUpdate name ->
            { model
            | menu =
                Maybe.map (
                    \menu ->
                        { menu
                        | name = name
                        , nameBad = not <| (name |> Name.fromString >> maybeToBool) || String.isEmpty name
                        }
                    )
                    model.menu
            }

-- VIEW
addMenu : Menu -> Element Msg
addMenu menu =
    El.column
        [ El.spacing StyleVars.standardSpacing
        , El.padding StyleVars.standardPadding
        ] <| conditional
        [ Always <| Inp.text []
            { onChange = NameUpdate
            , text = menu.name
            , placeholder = Just <| Inp.placeholder [] <| El.text "First Last"
            , label = Inp.labelAbove [] <| El.text "Name"
            }
        , When menu.nameBad <|
            El.el [] <| El.text "Must provide first and last name"
        ]


-- This allows for conditional rendering of elements easily
type ConditionalElem msg
    = When Bool (Element msg)
    | Always (Element msg)


-- Collapses conditionals in an element list, allowing for
-- easy notation of lists of elements that may or may not be there
conditional : List (ConditionalElem msg) -> List (Element msg)
conditional =
    List.filter
        (\elem ->
            case elem of
                Always _ ->
                    True

                When p _ ->
                    p
        )
    >>
    List.map
        (\elem ->
            case elem of
                Always e ->
                    e

                When _ e ->
                    e
        )


view : Model -> Element Msg
view model =
    El.column
        [ El.width El.fill
        , El.padding StyleVars.standardPadding
        , El.spacing StyleVars.standardSpacing
        ] <| conditional
        [ Always <| Inp.button
            [ El.mouseOver [Bg.color StyleVars.interactibleMouseOverColor]
            , Bg.color StyleVars.interactibleColor
            , Border.rounded 5
            , Font.color StyleVars.white
            , El.padding StyleVars.standardPadding
            ]
            { onPress = Just ToggleMenu 
            , label = El.text <| if maybeToBool model.menu then "Close Menu" else "Add Student" 
            }
        , When (maybeToBool model.menu) <| addMenu <| Maybe.withDefault defaultMenu model.menu
        , Always <| case model.data of
            Students students ->
                case students of
                    [] ->
                        El.el [] <| El.text "Nothing here"

                    _ -> 
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
                El.el [] <| El.text "Loading..."

            Error msg ->
                El.el [] <| El.text msg
        ]

        
-- INIT
init : Model
init =
    { menu = Nothing
    , data = Loading
    }


getStudents : Cmd Msg
getStudents =
    Http.get
        { url = "/read" {- TEMPORARY -}
        , expect = Http.expectJson GotStudents <| D.list Student.decode
        }