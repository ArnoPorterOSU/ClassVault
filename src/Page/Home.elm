module Page.Home exposing
    ( Model(..)
    , Msg(..)
    , getStudents
    , init
    , view
    , update
    )


import Http
import Element as El exposing (Element)
import Json.Decode as D
import Types.Name as Name
import Types.Student as Student exposing (Student)


-- MODEL
type Model
    = Loading
    | Students (List Student)
    | Error String


-- MSG
type Msg
    = GotStudents (Result Http.Error (List Student))


-- UPDATE
update : Msg -> Model -> Model
update msg _ =
    case msg of
        GotStudents result ->
            case result of
                Ok students ->
                    Students students

                Err _ ->
                    Error "Something went wrong"



-- VIEW
view : Model -> Element Msg
view model =
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
            El.el [] <| El.text "Loading..."

        Error msg ->
            El.el [] <| El.text msg

-- INIT
init : Model
init =
    Loading


getStudents : Cmd Msg
getStudents =
    Http.get
        { url = "/read" {- TEMPORARY -}
        , expect = Http.expectJson GotStudents <| D.list Student.decode
        }