module Login exposing (main)

import Browser
import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Http
import Json.Decode as JDecode
import Json.Encode as JEncode
import String



-- TODO adjust rootUrl as needed


--rootUrl ="http://localhost:8000/e/macid/"



rootUrl = "https://mac1xa3.ca/e/liuy363/"


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



{- -------------------------------------------------------------------------------------------
   - Model
   --------------------------------------------------------------------------------------------
-}


type alias Model =
    { name : String, password : String, error : String }


type Msg
    = NewName String -- Name text field changed
    | NewPassword String -- Password text field changed
    | GotLoginResponse (Result Http.Error String) -- Http Post Response Received
    | LoginButton -- Login Button Pressed


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = ""
      , password = ""
      , error = ""
      }
    , Cmd.none
    )



{- -------------------------------------------------------------------------------------------
   - View
   --------------------------------------------------------------------------------------------
-}


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ viewInput "text" "Name" model.name NewName
            , viewInput "password" "Password" model.password NewPassword
            ]
        , div []
            [ button [ Events.onClick LoginButton ] [ text "Login" ]
            , text model.error
            ]
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, Events.onInput toMsg ] []



{- -------------------------------------------------------------------------------------------
   - JSON Encode/Decode
   -   passwordEncoder turns a model name and password into a JSON value that can be used with
   -   Http.jsonBody
   --------------------------------------------------------------------------------------------
-}


passwordEncoder : Model -> JEncode.Value
passwordEncoder model =
    JEncode.object
        [ ( "username"
          , JEncode.string model.name
          )
        , ( "password"
          , JEncode.string model.password
          )
        ]


loginPost : Model -> Cmd Msg
loginPost model =
    Http.post
        { url = "https://mac1xa3.ca/e/liuy363/userlogin/"
        , body = Http.jsonBody <| passwordEncoder model
        , expect = Http.expectString GotLoginResponse
        }



{- -------------------------------------------------------------------------------------------
   - Update
   -   Sends a JSON Post with currently entered username and password upon button press
   -   Server send an Redirect Response that will automatically redirect to UserPage.html
   -   upon success
   --------------------------------------------------------------------------------------------
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewName name ->
            ( { model | name = name }, Cmd.none )

        NewPassword password ->
            ( { model | password = password }, Cmd.none )

        LoginButton ->
            ( model, loginPost model )

        GotLoginResponse result ->
            case result of
                Ok "LoginFailed" ->
                    ( { model | error = "Failed to login" }, Cmd.none )

                Ok "Success! Hello " ->
                    ( { model | error = "Successfully login, hello " }, Cmd.none )

                Ok _ ->
                    ( model, load ("https://mac1xa3.ca/u/liuy363/clientside.html") )

                Err error ->
                    ( handleError model error, Cmd.none )



-- put error message in model.error_response (rendered in view)


handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url ->
            { model | error = "bad url: " ++ url }

        Http.Timeout ->
            { model | error = "timeout" }

        Http.NetworkError ->
            { model | error = "network error" }

        Http.BadStatus i ->
            { model | error = "bad status " ++ String.fromInt i }

        Http.BadBody body ->
            { model | error = "bad body " ++ body }
