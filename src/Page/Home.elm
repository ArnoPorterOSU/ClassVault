module Page.Home exposing
    ( Model
    , Msg(..)
    , init
    , view
    , update
    )


import Element as El exposing (Element, Color)
import Element.Input as Inp
import Element.Border as Border
import Element.Background as Bg
import Element.Font as Font
import Json.Encode exposing (Value)
import Types.Name as Name
import Types.Student as Student exposing (Student)
import Types.Address as Address
import StyleVars
import Util exposing (maybeToBool, inRange, mfilter)
import Email


-- MODEL
type alias Model =
    { menu : MenuType
    , data : List Student
    , width : Int
    , search : String
    }


type MenuType
    = AllClosed
    | AddStudent Menu
    | EditStudent Int Menu


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
    | SubmitStudent Value
    | UpdateStudent Int Value
    | OpenEdit Student
    | DeleteStudent (List Int)
    | ListUpdated (List Student)
    | SearchBarUpdated String


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
            | search = ""
            , menu =
                case model.menu of
                    AllClosed ->
                        AddStudent defaultMenu

                    _ ->
                        AllClosed
            }
        
        OpenEdit student ->
            { model
            | menu =
                EditStudent student.id
                    { name = Name.toString student.name
                    , email = student.email
                    , id = String.fromInt student.id
                    , gpa = String.fromFloat student.gpa
                    , street = student.address.street
                    , city = student.address.city
                    , state = student.address.state
                    , zip = String.fromInt student.address.zipCode
                    }
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

        SubmitStudent _ ->
            menuUpdate (always defaultMenu) model

        UpdateStudent _ _ ->
            { model
            | menu = AllClosed
            }

        ListUpdated students -> 
            { model
            | data = students
            }
        
        SearchBarUpdated search ->
            { model
            | search = search
            }

        _ ->
            { model
            | search = ""
            }


menuUpdate : (Menu -> Menu) -> Model -> Model
menuUpdate nextMenu model =
    { model
    | menu = case model.menu of
        AddStudent menu ->
            AddStudent <| nextMenu menu

        EditStudent id menu ->
            EditStudent id <| nextMenu menu
        
        menu ->
            menu
    }


-- VIEW
view : Model -> Element Msg
view model =
    El.column
        [ El.width El.fill
        , El.padding StyleVars.standardPadding
        , El.spacing StyleVars.standardSpacing
        ] <|
        [ El.row [El.width El.fill, El.spacing <| model.width * 3 // 5] <| conditional
            [ Always <| Inp.button
                [ El.mouseOver [Bg.color StyleVars.interactibleMouseOverColor]
                , Bg.color StyleVars.interactibleColor
                , Border.rounded buttonRounding
                , Font.color StyleVars.white
                , El.padding StyleVars.standardPadding
                ]
                { onPress = Just ToggleMenu 
                , label = El.text <| if hasMenuOpen model.menu then "Close Menu" else "Add Student" 
                }
            , When (not <| hasMenuOpen model.menu) <| Inp.search [El.width << El.px <| model.width // 5]
                { onChange = SearchBarUpdated
                , text = model.search
                , placeholder = Just <| Inp.placeholder [] <| El.text "123456"
                , label = Inp.labelLeft [] <| El.text "Search by ID"
                }
            ]
        , case model.menu of
            AddStudent menu ->
                studentMenu SubmitStudent Nothing model.data menu
            
            EditStudent id menu ->
                studentMenu (UpdateStudent id) (Just id) model.data menu
            
            _ ->
                El.none
        ]
        ++
        case model.menu of
            EditStudent _ _ ->
                []
            
            _ ->
                [ case model.data of
                    [] ->
                        El.el [] <| El.text "Nothing here"

                    _ -> 
                        El.table []
                            { data = List.filter (.id >> String.fromInt >> String.startsWith model.search) model.data
                            , columns =
                                [   { header = header "Name"
                                    , width = El.fill
                                    , view = entry <| .name >> Name.toString
                                    }
                                ,   { header = header "Email"
                                    , width = El.fill
                                    , view = entry .email
                                    }
                                ,   { header = header "Id Number"
                                    , width = El.fill
                                    , view = entry <| .id >> String.fromInt
                                    }
                                ,   { header = header "GPA"
                                    , width = El.fill
                                    , view = entry <| .gpa >> String.fromFloat
                                    }
                                ,   { header = header "Address"
                                    , width = El.fill
                                    , view = entry <| .address >> Address.toString 
                                    }
                                ,   { header = header "Edit"
                                    , width = El.fill
                                    , view = \student -> Inp.button
                                        [ Bg.color StyleVars.interactibleColor 
                                        , Font.color StyleVars.white
                                        , El.mouseOver [Bg.color StyleVars.interactibleMouseOverColor]
                                        , El.height El.fill
                                        ]
                                        { onPress = Just <| OpenEdit student
                                        , label = El.el [El.centerX] <| El.text "Edit"
                                        }
                                    }
                                ,   { header = header "Delete"
                                    , width = El.fill
                                    , view = \student -> Inp.button
                                        [ Bg.color deleteColor
                                        , Font.color StyleVars.white
                                        , El.mouseOver [Bg.color deleteMouseOverColor]
                                        , El.height El.fill
                                        ]
                                        { onPress = Just << DeleteStudent << List.singleton <| student.id
                                        , label = El.el [El.centerX] <| El.text "Delete"
                                        }
                                    }
                                ]
                            }
                , Inp.button
                    [ Bg.color deleteColor
                    , Font.color StyleVars.white
                    , El.mouseOver [Bg.color deleteMouseOverColor]
                    , El.padding StyleVars.standardPadding
                    , Border.rounded buttonRounding
                    ]
                    { onPress = Just << DeleteStudent << List.map .id <| model.data
                    , label = El.text "Delete All"
                    }
                ]


hasMenuOpen : MenuType -> Bool
hasMenuOpen menu =
    case menu of
        AddStudent _ ->
            True
        
        EditStudent _ _ ->
            True
        
        _ ->
            False

deleteColor : Color
deleteColor =
    El.rgb255 0xff 0x0c 0x24


deleteMouseOverColor : Color
deleteMouseOverColor =
    El.rgb255 0xc1 0x00 0x09


tableBorderColor : Color
tableBorderColor =
    El.rgb255 0 0 0


tableBorderWidth : Int
tableBorderWidth =
    2


header : String -> Element Msg
header =
    El.text
    >> El.el
        [ Font.bold
        , El.padding StyleVars.standardPadding
        , Border.solid
        , Border.color tableBorderColor
        , Border.width tableBorderWidth
        ]


entry : (Student -> String) -> Student -> Element Msg
entry conversion =
    conversion
    >> El.text
    >> El.el
        [ El.padding StyleVars.standardPadding
        , Border.solid
        , Border.color tableBorderColor
        , Border.width tableBorderWidth
        ]


entryRowFontSize : Int
entryRowFontSize =
    16


buttonRounding : Int
buttonRounding =
    5


-- a function that allows for generating student data entry rows
entryRow :
    { onChange : (String -> Msg)
    , text : String
    , placeholderText : String
    , labelText : String
    , parser : String -> Maybe a
    , badMsg : String
    } -> Element Msg
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
            , placeholder = Just <| Inp.placeholder [Font.size entryRowFontSize] <| El.text placeholderText
            , label = Inp.labelAbove [Font.size entryRowFontSize] <| El.text labelText
            }
        , When (badCheck parser text) <|
            El.el
                [ Bg.color <| El.rgba255 0xf9 0x3d 0x5c 0x80
                , Font.color StyleVars.white
                , Font.size entryRowFontSize
                , El.padding StyleVars.standardPadding
                , Border.rounded buttonRounding
                ] <| El.text badMsg
        ]


parseGpa : String -> Maybe Float
parseGpa =
    String.toFloat >> mfilter (inRange 0 4)


parseId : Maybe Int -> List Student -> String -> Maybe Int
parseId mid students =
        String.toInt
        >>  mfilter (\x ->
                (case mid of
                    Just eid ->
                        x == eid
                    
                    Nothing ->
                        False
                )
                ||
                not (List.member x <| List.map .id students)
            )



studentMenu : (Value -> Msg) -> Maybe Int -> List Student -> Menu -> Element Msg
studentMenu msg mid students menu =
    El.column [El.spacing StyleVars.standardSpacing]
        [ entryRow
            { onChange = NameUpdate
            , text = menu.name
            , placeholderText = "First Last"
            , labelText = "Name"
            , parser = Name.fromString
            , badMsg = "⚠ Must contain at least first and last name"
            }
        , entryRow
            { onChange = EmailUpdate
            , text = menu.email
            , placeholderText = "name@example.com"
            , labelText = "Email"
            , parser = Email.fromString
            , badMsg = "⚠ Must be a valid email"
            }
        , entryRow
            { onChange = IdUpdate
            , text = menu.id
            , placeholderText = "Id #"
            , labelText = "Id Number"
            , parser = parseId mid students
            , badMsg = "⚠ Must be a number that a student doesn't already have"
            }
        , entryRow
            { onChange = GpaUpdate
            , text = menu.gpa
            , placeholderText = "GPA"
            , labelText = "GPA"
            , parser = parseGpa
            , badMsg = "⚠ Must be a float in the range 0.0-4.0"
            }
        , El.text "Address info"
        , entryRow
            { onChange = StreetUpdate
            , text = menu.street
            , placeholderText = "1234 Example St"
            , labelText = "Street"
            , parser = Just
            , badMsg = ""
            }
        , entryRow
            { onChange = CityUpdate
            , text = menu.city
            , placeholderText = "Springville"
            , labelText = "City"
            , parser = Just
            , badMsg = ""
            }
        , entryRow
            { onChange = StateUpdate
            , text = menu.state
            , placeholderText = "Statington"
            , labelText = "State"
            , parser = Just
            , badMsg = ""
            }
        , entryRow
            { onChange = ZipUpdate
            , text = menu.zip
            , placeholderText = "12345"
            , labelText = "Zip Code"
            , parser = String.toInt
            , badMsg = "⚠ Must be an integer"
            }
        , Inp.button
            [ Bg.color <| El.rgb255 0x08 0x7c 0x29
            , Font.color StyleVars.white
            , Border.rounded buttonRounding
            , El.mouseOver [Bg.color <| El.rgb255 0x3c 0xa1 0x56]
            , El.padding StyleVars.standardPadding
            ]
            { onPress = validateInputs msg mid students menu
            , label = El.text "Save"
            }
        ]


badCheck : (String -> Maybe a) -> String -> Bool
badCheck parse str =
    not <| maybeToBool (parse str) || String.isEmpty str


validateInputs : (Value -> Msg) -> Maybe Int -> List Student -> Menu -> Maybe Msg
validateInputs msg mid students menu =
    if String.isEmpty menu.name
        || String.isEmpty menu.email
        || String.isEmpty menu.id
        || String.isEmpty menu.gpa
        || String.isEmpty menu.street
        || String.isEmpty menu.city
        || String.isEmpty menu.state
        || String.isEmpty menu.zip
        || badCheck Name.fromString menu.name
        || badCheck (parseId mid students) menu.id
        || badCheck parseGpa menu.gpa
        || badCheck String.toInt menu.zip
    then
        Nothing
    else
        Just << msg <| Student.encode
            { name = Maybe.withDefault { first = "", last = "", middles = []} << Name.fromString <| menu.name
            , id = Maybe.withDefault 0 << parseId mid students <| menu.id
            , email = menu.email
            , gpa = Maybe.withDefault 0 << parseGpa <| menu.gpa
            , address =
                { street = menu.street
                , city = menu.city
                , state = menu.state
                , zipCode = Maybe.withDefault 0 << String.toInt <| menu.zip
                }
            }


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
init :
    { width : Int
    , students : List Student
    } -> Model
init
    { width
    , students
    } =
    { menu = AllClosed
    , data = students
    , width = width
    , search = ""
    }