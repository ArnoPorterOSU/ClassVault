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


-- MODEL
type alias Model =
    { addingStudent : Bool
    , data : Data
    }

type Data
    = Loading
    | Students (List Student)
    | Error String


-- MSG
type Msg
    = GotStudents (Result Http.Error (List Student))
    | ToggleMenu


-- UPDATE
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
            | addingStudent = not model.addingStudent
            }


-- VIEW
view : Model -> Element Msg
view model =
    El.column
        [ El.width El.fill
        , El.padding StyleVars.standardPadding
        ] <|
        Inp.button
            [ El.mouseOver [Bg.color StyleVars.interactibleMouseOverColor]
            , Bg.color StyleVars.interactibleColor
            , Border.rounded 5
            , Font.color StyleVars.white
            , El.padding StyleVars.standardPadding
            ]
            { onPress = Just ToggleMenu 
            , label = El.text <| if model.addingStudent then "Close Menu" else "Add Student" 
            }
        ::
        (if model.addingStudent then [El.el [] <| El.text "Placeholder"] else [])
        ++
        [ case model.data of
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
    { addingStudent = False
    , data = Loading
    }


getStudents : Cmd Msg
getStudents =
    Http.get
        { url = "/read" {- TEMPORARY -}
        , expect = Http.expectJson GotStudents <| D.list Student.decode
        }