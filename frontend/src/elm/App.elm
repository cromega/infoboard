module App exposing (main)

import Browser
import Http
import Html exposing (..)
import Time

import Panels.WeatherPanel
import Panels.TubeStatusPanel
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
  { weatherResult : HttpResult
  , tubeStatusResult : HttpResult
  , viewState : ViewState
  }

type ViewState
  = Starting
  | ShowWeather
  | ShowTubeStatus

type Msg
  = GotForecast HttpResult
  | GotTubeStatus HttpResult
  | Refresh Time.Posix
  | Swap Time.Posix

refresh : Cmd Msg
refresh =
  Cmd.batch [loadForecast, loadTubeStatus]


init : () -> (Model, Cmd Msg)
init _ =
  (Model newHttpResult newHttpResult Starting, refresh)


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotForecast result ->
      ({model | weatherResult = result, viewState = ShowWeather}, Cmd.none)
    GotTubeStatus result ->
      ({model | tubeStatusResult = result, viewState = ShowTubeStatus}, Cmd.none)
    Swap _->
      if model.viewState == ShowWeather then
        ({model | viewState = ShowTubeStatus}, Cmd.none)
      else
        ({model | viewState = ShowWeather}, Cmd.none)
    Refresh _ ->
      (model, refresh)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
  [ Time.every 3000 Swap
  , Time.every (1000 * 10) Refresh
  ]

-- VIEW


view : Model -> Html Msg
view model =
  case model.viewState of
    Starting -> div [] [ h1 [] [ text "Fetching data" ] ]
    ShowWeather -> Panels.WeatherPanel.render model.weatherResult
    ShowTubeStatus -> Panels.TubeStatusPanel.render model.tubeStatusResult

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

