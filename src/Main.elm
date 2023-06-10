module Main exposing (main)


import Browser
import Browser.Navigation as Nav
import Element as El exposing (Element, Color)
import Element.Region as Reg
import Element.Background as Bg
import Element.Font as Font
import Json.Decode as D exposing (Value, Decoder)
import Page.Home as Home
import Route
import Url exposing (Url)
import Util exposing (uncurry)
import Platform.Cmd as Cmd
import StyleVars exposing (..)


-- MODEL
type alias Model =
    { key : Nav.Key 
    , width : Int
    , height : Int
    , page : Page
    }


type Page
    = Home Home.Model


-- UPDATE
type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | GotHomeMsg Home.Msg


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
                              | page = Home Home.init
                              }
                            , Cmd.map GotHomeMsg Home.getStudents
                            )

                _ -> (model, Cmd.none)

        GotHomeMsg hmsg ->
            let
                (Home homeModel) = model.page
            in
                ( { model
                  | page = Home <| Home.update hmsg homeModel
                  }
                , Cmd.none
                )


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


-- VIEW
navButton : String -> Element Msg
navButton labelText =
    El.link
        [ El.mouseOver
            [ Bg.color navMouseOverColor
            ]
        , Font.color white
        , El.padding standardPadding
        ]
        { url = labelText
            |> (\x -> if x == "Home" then Nothing else String.uncons x)
            >> Maybe.map
                (Tuple.mapFirst Char.toLower
                >> uncurry String.cons
                >> String.cons '/')
            >> Maybe.withDefault "/"
        , label = El.text labelText
        }


navColor : Color
navColor =
    El.rgb255 95 171 220


navMouseOverColor : Color
navMouseOverColor =
    El.rgb255 30 96 138


view : Model -> Browser.Document Msg
view model =
    { title = "ClassVault"
    , body =
        [ El.layout [] <| El.column
            [ El.spacing standardSpacing
            ]
            [ El.row
                [ El.width <| El.px model.width
                , El.spacing standardSpacing
                , Reg.navigation
                , Bg.color navColor
                ]
                [ navButton "Home"
                , navButton "Stats"
                , navButton "Calendar"
                ]
            ,   case model.page of
                    Home hmodel ->
                        El.map GotHomeMsg <| Home.view hmodel
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
          , page = Home Home.init
          }
        , Cmd.map GotHomeMsg Home.getStudents
        )


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