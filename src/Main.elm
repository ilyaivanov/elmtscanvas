port module Main exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Debug exposing (log)
import Html exposing (Html, button, canvas, div, h1, img, text)
import Html.Attributes exposing (class, height, id, src, style, width)
import Html.Events exposing (onClick)


type alias Rect =
    { x : Float
    , y : Float
    }


port sendMessage : Rect -> Cmd msg



---- MODEL ----


type alias Model =
    { isRunning : Bool
    , x : Float
    , y : Float
    }


start : Model
start =
    { isRunning = False, x = 50, y = 50 }


init : ( Model, Cmd Msg )
init =
    ( start, sendMessage { x = start.x, y = start.y } )



---- UPDATE ----


type Msg
    = NoOp
    | ToggleWabble
    | Tick Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleWabble ->
            ( { model | isRunning = not model.isRunning }, Cmd.none )

        Tick deltaTime ->
            let
                newModel =
                    { model | x = model.x + deltaTime / 10 }
            in
            ( newModel, sendMessage { x = newModel.x, y = newModel.y } )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewButton model
        , canvas [ id "rootCanvas", width 800, height 800 ] []
        ]


viewButton model =
    button [ onClick ToggleWabble ] [ text (ifElse model.isRunning "stop" "start") ]


ifElse condition trueVal falseVal =
    if condition then
        trueVal

    else
        falseVal


numberToPixels number =
    String.fromFloat number ++ "px"



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isRunning then
        onAnimationFrameDelta Tick

    else
        Sub.none
