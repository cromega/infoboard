module App exposing (main)

import Browser
import Http
import Html exposing (..)
import Time

import WeatherPanel
import TubeStatusPanel
import ViewHelpers
import CommonTypes exposing (..)

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


-- MODEL


type alias Model =
  { weatherResult : Maybe HttpResult
  , tubeStatusResult : Maybe HttpResult
  , viewState : ViewState
  }

type ViewState
  = Starting
  | ShowWeather
  | ShowTubeStatus

type Msg
  = GotForecast HttpResult
  | GotTubeStatus HttpResult
  | Swap Time.Posix

init : () -> (Model, Cmd Msg)
init _ =
  (Model Nothing Nothing Starting, Cmd.batch [loadForecast, loadTubeStatus])



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotForecast result ->
      ({model | weatherResult = Just result, viewState = ShowWeather}, Cmd.none)
    GotTubeStatus result ->
      ({model | tubeStatusResult = Just result, viewState = ShowTubeStatus}, Cmd.none)
    Swap _->
      if model.viewState == ShowWeather then
        ({model | viewState = ShowTubeStatus}, Cmd.none)
      else
        ({model | viewState = ShowWeather}, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Time.every 3000 Swap

-- VIEW


view : Model -> Html Msg
view model =
  case model.viewState of
    Starting -> div [] [ h1 [] [ text "Fetching data" ] ]
    ShowWeather -> WeatherPanel.render model.weatherResult
    ShowTubeStatus -> TubeStatusPanel.render model.tubeStatusResult

-- HTTP


loadForecast : Cmd Msg
loadForecast =
  Http.get
    { url = "/weather"
    , expect = Http.expectString GotForecast
    }

loadTubeStatus : Cmd Msg
loadTubeStatus =
  Http.get
    { url = "/tube"
    , expect = Http.expectString GotTubeStatus
    }

