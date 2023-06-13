module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Element as El exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import Element.Region as Reg
import Http
import Json.Decode as D exposing (Value, Decoder)
import Json.Encode as E
import Page.Home as Home
import Page.Stats as Stats
import Platform.Cmd as Cmd
import Route
import Url exposing (Url)
import Util exposing (uncurry, flip)
import Types.Student as Student exposing (Student)
import StyleVars
import Page.Stats as Stats


-- MODEL
type alias Model =
    { key : Nav.Key 
    , width : Int
    , height : Int
    , page : Page
    , data : List Student
    }


type Page
    = Home Home.Model
    | Stats Stats.Model
    | Error String
    | Loading


-- UPDATE
type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | GotHomeMsg Home.Msg
    | GotStatsMsg Stats.Msg
    | GotStudents (Result Http.Error (List Student))
    | StudentCreated (Result Http.Error Student)
    | StudentDeleted (Result Http.Error (List Int))
    | StudentUpdated (Result Http.Error StudentUpdateRecord)
    | QuickChartResponse (Result Http.Error String)


type alias StudentUpdateRecord =
    { id : Int
    , student : Student
    }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked urlRequest ->
            ( model
            , case urlRequest of
                Browser.Internal url ->
                    Nav.pushUrl model.key <| Url.toString url
                        
                Browser.External href ->
                    Nav.load href
            )

        UrlChanged url ->
            case Route.fromUrl url of
                Just route ->
                    case route of
                        Route.Home ->
                            ( { model
                              | page = Home <| Home.init { width = model.width, data = model.data }
                              }
                            , Cmd.none
                            )
                        
                        Route.Stats ->
                            ( { model
                              | page = Stats <| Stats.init model.data
                              }
                            , Cmd.none
                            )

                _ -> (model, Cmd.none)

        GotHomeMsg hmsg ->
            case model.page of
                Home homeModel ->
                    ( { model
                      | page = Home <| Home.update hmsg homeModel
                      }
                    , case hmsg of
                        Home.SubmitStudent data ->
                            submitStudent data

                        Home.DeleteStudent idList ->
                            deleteStudent idList

                        Home.UpdateStudent id data ->
                            updateStudent id data
                        
                        _ ->
                            Cmd.none
                    )
                
                _ ->
                    (model, Cmd.none)

        GotStatsMsg smsg ->
            case model.page of
                Stats _ ->
                    ( model
                    , case smsg of
                        Stats.GenerateChart json ->
                            pingQuickChart json

                        _ ->
                            Cmd.none
                    )
                
                _ ->
                    (model, Cmd.none)

        GotStudents result ->
            case result of
                Ok students ->
                    ( { model
                      | data = students
                      , page = Home <| Home.init { width = model.width, data = students }
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                      | data = []
                      , page = Error "Something went wrong"
                      }
                    , Cmd.none
                    )

        StudentCreated result ->
            case result of
                Ok student ->
                    let
                        newStudents = student :: model.data
                    in
                        ( { model
                        | data = newStudents
                        , page = case model.page of
                                Home hmodel ->
                                    Home <| Home.update (Home.ListUpdated newStudents) hmodel

                                _ ->
                                    model.page
                        }
                        , Cmd.none
                        )
                
                Err _ ->
                    (model, Cmd.none)

        StudentDeleted result ->
            case result of
                Ok idList ->
                    let
                        newStudents = List.filter (.id >> flip List.member idList >> not) model.data
                    in
                        ( { model
                          | data = newStudents
                          , page = case model.page of
                                Home hmodel ->
                                    Home <| Home.update (Home.ListUpdated newStudents) hmodel
                            
                                _ ->
                                    model.page
                          }
                        , Cmd.none
                        )

                Err _ ->
                    (model, Cmd.none)
        
        StudentUpdated result ->
            case result of
                Ok studentUpdate ->
                    let
                        newStudents = List.map (\s ->
                                if s.id == studentUpdate.id then
                                    studentUpdate.student
                                else
                                    s
                            )
                            model.data
                    in
                        ( { model
                          | data = newStudents
                          , page = case model.page of
                                Home hmodel ->
                                    Home <| Home.update (Home.ListUpdated newStudents) hmodel
                                
                                _ ->
                                    model.page
                          }
                        , Cmd.none
                        )
                
                Err _ ->
                    (model, Cmd.none)

        QuickChartResponse result ->
            case result of
                Ok url ->
                    ( { model
                      | page = case model.page of
                            Stats smodel ->
                                Stats <| Stats.update (Stats.UpdateChart url) smodel

                            _ ->
                                model.page
                      }
                    , Cmd.none
                    )
                
                Err _ ->
                    ( { model
                      | page = Error "Fix the quickchart API call"
                      }
                    , Cmd.none
                    )



submitStudent : Value -> Cmd Msg
submitStudent data =
    Http.post
        { url = "/create"
        , body = Http.jsonBody data
        , expect = Http.expectJson StudentCreated Student.decode
        }

    
deleteStudent : List Int -> Cmd Msg
deleteStudent idList =
    Http.post
        { url = "/delete"
        , body = Http.jsonBody <| E.list E.int idList
        , expect = Http.expectJson StudentDeleted <| D.list D.int
        }


updateStudent : Int -> Value -> Cmd Msg
updateStudent id data =
    Http.post
        { url = "/update"
        , body = Http.jsonBody <| E.object
            [ ("id", E.int id)
            , ("student", data)
            ]
        , expect = Http.expectJson StudentUpdated <|
            D.map2
                StudentUpdateRecord
                    (D.field "id" D.int)
                    (D.field "student" Student.decode)
        }


pingQuickChart : Value -> Cmd Msg
pingQuickChart json =
    Http.post
        { url = "https://quickchart.io/chart"
        , body = Http.jsonBody json
        , expect = Http.expectJson QuickChartResponse <| D.field "url" D.string
        }


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


-- VIEW
navButton : String -> Element Msg
navButton labelText =
    El.link
        [ El.mouseOver
            [ Bg.color StyleVars.interactibleMouseOverColor
            ]
        , Font.color StyleVars.white
        , El.padding StyleVars.standardPadding
        ]
        { url = labelText
            |> (\x -> if x == "Home" then Nothing else String.uncons x)
            >> Maybe.map
                (  Tuple.mapFirst Char.toLower
                >> uncurry String.cons
                >> String.cons '/'
                )
            >> Maybe.withDefault "/"
        , label = El.text labelText
        }


view : Model -> Browser.Document Msg
view model =
    { title = "ClassVault"
    , body =
        [ El.layout [] <| El.column
            [ El.spacing StyleVars.standardSpacing
            ]
            [ El.row
                [ El.width <| El.px model.width
                , El.spacing StyleVars.standardSpacing
                , Reg.navigation
                , Bg.color StyleVars.interactibleColor
                ]
                [ navButton "Home"
                , navButton "Stats"
                ]
            ,   case model.page of
                    Home hmodel ->
                        El.map GotHomeMsg <| Home.view hmodel

                    Stats smodel ->
                        El.map GotStatsMsg <| Stats.view smodel

                    Loading ->
                        El.el [El.padding StyleVars.standardPadding] <| El.text "Loading..."

                    Error error ->
                        El.el [El.padding StyleVars.standardPadding] <| El.text error
            ]
        ]
    }


-- INIT
init : Value -> Url -> Nav.Key -> (Model, Cmd Msg)
init flags _ navKey =
    let
        decodedFlags = case D.decodeValue decode flags of
            Ok fs ->
                fs

            Err _ ->
                { width = 1920
                , height = 955
                }
    in
        ( { width = decodedFlags.width
          , height = decodedFlags.height
          , key = navKey
          , page = Loading
          , data = []
          }
        , getStudents
        )


getStudents : Cmd Msg
getStudents =
    Http.get
        { url = "/read"
        , expect = Http.expectJson GotStudents <| D.list Student.decode
        }


type alias Flags =
    { width : Int
    , height : Int
    }

    
decode : Decoder Flags
decode =
    D.map2 Flags
        (D.field "width" D.int)
        (D.field "height" D.int)


-- MAIN
main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }