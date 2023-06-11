module Page.Home exposing
    ( Model
    , Msg(..)
    , init
    , view
    , update
    )


import Element as El exposing (Element)
import Element.Input as Inp
import Element.Border as Border
import Element.Background as Bg
import Element.Font as Font
import Types.Name as Name
import Types.Student exposing (Student)
import StyleVars
import Util exposing (maybeToBool, inRange, guard)


-- MODEL
type alias Model =
    { menu : Maybe Menu
    , data : List Student
    }


type alias Menu =
    { name : String
    , id : String
    , email : String
    , gpa : String
    , street : String
    , city : String
    , state : String
    , zip : String
    }


-- MSG
type Msg
    = ToggleMenu
    | NameUpdate String
    | IdUpdate String
    | EmailUpdate String
    | GpaUpdate String
    | StreetUpdate String
    | CityUpdate String
    | StateUpdate String
    | ZipUpdate String


-- UPDATE
defaultMenu : Menu
defaultMenu =
    { name = ""
    , id = ""
    , email = ""
    , gpa = ""
    , street = ""
    , city = ""
    , state = ""
    , zip = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
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
            menuUpdate
                (\menu ->
                    { menu
                    | name = name
                    }
                )
                model

        IdUpdate id ->
            menuUpdate
                (\menu ->
                    { menu
                    | id = id
                    }
                )
                model
        
        EmailUpdate email ->
            menuUpdate
                (\menu ->
                    { menu
                    | email = email
                    }
                )
                model

        GpaUpdate gpa ->
            menuUpdate
                (\menu ->
                    { menu
                    | gpa = gpa
                    }
                )
                model

        StreetUpdate street ->
            menuUpdate
                (\menu ->
                    { menu
                    | street = street
                    }
                )
                model
        
        CityUpdate city ->
            menuUpdate
                (\menu ->
                    { menu
                    | city = city
                    }
                )
                model

        StateUpdate state ->
            menuUpdate
                (\menu ->
                    { menu
                    | state = state
                    }
                )
                model

        ZipUpdate zip ->
            menuUpdate
                (\menu ->
                    { menu
                    | zip = zip
                    }
                )
                model



menuUpdate : (Menu -> Menu) -> Model -> Model
menuUpdate nextMenu model =
    { model
    | menu = Maybe.map nextMenu model.menu
    }


-- VIEW
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
        , When (maybeToBool model.menu) <| addMenu
            <| Maybe.withDefault defaultMenu model.menu
        , Always <| case model.data of
            [] ->
                El.el [] <| El.text "Nothing here"

            _ -> 
                El.table []
                    { data = model.data
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
        ]


-- a function that allows for generating student data entry rows
entryRow :
    { onChange : (String -> Msg)
    , text : String
    , placeholderText : String
    , labelText : String
    , parser : String -> Maybe a
    , badMsg : String
    }
    -> Element Msg
entryRow
    { onChange
    , text
    , placeholderText
    , labelText
    , parser
    , badMsg
    } =
    El.row [El.spacing StyleVars.standardSpacing] <| conditional
        [ Always <| Inp.text []
            { onChange = onChange
            , text = text
            , placeholder = Just <| Inp.placeholder [] <| El.text placeholderText
            , label = Inp.labelAbove [Font.size 16] <| El.text labelText
            }
        , When (badCheck parser text) <|
            El.el
                [ Bg.color <| El.rgb255 0xf4 0x84 0x7C
                , Font.color <| El.rgb255 0xf4 0x64 0x7e
                , El.padding StyleVars.standardPadding
                , Border.rounded 5
                ] <| El.text badMsg
        ]


addMenu : Menu -> Element Msg
addMenu menu =
    El.column
        [ El.spacing StyleVars.standardSpacing
        , El.padding StyleVars.standardPadding
        ]
        [ entryRow
            { onChange = NameUpdate
            , text = menu.name
            , placeholderText = "First Last"
            , labelText = "Name"
            , parser = Name.fromString
            , badMsg = "⚠  Name must contain at least first and last name"
            }
        , entryRow
            { onChange = IdUpdate
            , text = menu.id
            , placeholderText = "Id #"
            , labelText = "Id Number"
            , parser = String.toInt
            , badMsg = "⚠ Id must be a number that a student doesn't already have"
            }
        , entryRow
            { onChange = GpaUpdate
            , text = menu.gpa
            , placeholderText = "GPA"
            , labelText = "GPA"
            , parser = String.toFloat >> Maybe.andThen (guard <| inRange 0 4)
            , badMsg = "⚠ GPA must be a float in the range 0-4"
            }
        ]


badCheck : (String -> Maybe a) -> String -> Bool
badCheck parse str =
    not <| maybeToBool (parse str) || String.isEmpty str


-- This allows for conditional rendering of elements easily
type ConditionalElem msg
    = Always (Element msg)
    | When Bool (Element msg)


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

        
-- INIT
init : List Student -> Model
init students =
    { menu = Nothing
    , data = students
    }