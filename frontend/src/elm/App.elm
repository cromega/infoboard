module App exposing (main)

import Browser
import Http
import Html exposing (..)
import Time

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


type alias PanelResponse = String
type alias PanelData =
  { data : PanelResponse
  , error : Http.Error
  }


-- MODEL


type Model
  = Starting
  | ShowingWeatherForecast PanelData
  | ShowingTubeStatus PanelData
  -- | FetchSuccess PanelData
  -- | FetchFailed Http.Error

type Msg
  = GotForecast (Result Http.Error PanelResponse)
  | ShowNextPanel Time.Posix

init : () -> (Model, Cmd Msg)
init _ =
  (Starting, loadForecast)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
  case msg of
    GotForecast paneldata ->
      (ShowingWeatherForecast paneldata)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Time.every 2000 ShowNextPanel



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Starting -> div [] [ h1 [] [ text "Starting up" ] ]
    ShowingWeatherForecast data -> WeatherPanel.render data.Data

-- HTTP


loadForecast : Cmd Msg
loadForecast =
  Http.get
    { url = "/weather"
    , expect = Http.expectString GotForecast
    }
