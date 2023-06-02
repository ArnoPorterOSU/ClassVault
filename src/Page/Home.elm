module Page.Home exposing
    ( Model
    , view
    )


import Html exposing (Html)
import Element as El
import Types.Name as Name
import Types.Student exposing (Student)


-- MODEL
type alias Model =
    { students : List Student
    }


-- VIEW
view : Model -> Html msg
view model =
    El.layoutWith
        { options = [El.noStaticStyleSheet] }
        [] <|
        El.table []
            { data = model.students
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