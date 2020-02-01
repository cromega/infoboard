module App exposing (main)

import Browser
import Http
import Html exposing (..)

import WeatherPanel
import ViewHelpers

-- TYPES



-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type alias ForecastResponse = String


-- MODEL


type Model
  = Loading
  | Success ForecastResponse
  | Failure Http.Error

type Msg
  = GotForecast (Result Http.Error ForecastResponse)

init : () -> (Model, Cmd Msg)
init _ =
  (Loading, loadForecast)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
  case msg of
    GotForecast result ->
      case result of
        Ok body -> (Success body, Cmd.none)
        Err err -> (Failure err, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Loading -> div [] [ h1 [] [ text "Loading" ] ]
    Success body -> WeatherPanel.render body
    Failure err ->
      h2 [] [ text (ViewHelpers.formatHttpResponseError err) ]

-- HTTP


loadForecast : Cmd Msg
loadForecast =
  Http.get
    { url = "/weather"
    , expect = Http.expectString GotForecast
    }
