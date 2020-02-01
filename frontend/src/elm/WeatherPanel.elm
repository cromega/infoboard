module WeatherPanel exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JD exposing (float, string, map4)

-- TYPES

type alias Forecast =
  { time : String
  , temp_min : Float
  , temp_max : Float
  , icon : String
  }

type alias Forecasts = List Forecast

render : String -> Html str
render json =
  case JD.decodeString forecastsDecoder json of
    Ok forecast -> renderWeather forecast
    Err err -> text "faszom error"

-- VIEW
renderWeather : Forecasts -> Html str
renderWeather forecasts =
  div [ id "weather-info" ]
    [ ul [ class "forecast" ] (List.map renderForecast forecasts) ]

renderForecast : Forecast -> Html str
renderForecast forecast =
  li [ class "forecast-entry" ]
    [ span [ class "time" ] [ text forecast.time ]
    , img [ class "icon", src (iconUrl forecast.icon) ] []
    , div [ class "clearfix" ] []
    , renderTemperature forecast.temp_min forecast.temp_max
    ]

renderTemperature : Float -> Float -> Html str
renderTemperature min max =
  let
    minStr = String.fromInt (round min)
    maxStr = String.fromInt (round max)
  in
    if minStr == maxStr then
      text (minStr ++ "C")
    else
      text (minStr ++ "-" ++ maxStr ++ "C")

iconUrl : String -> String
iconUrl icon =
  "http://openweathermap.org/img/w/" ++ icon ++ ".png"


-- JSON

forecastsDecoder : JD.Decoder (List Forecast)
forecastsDecoder =
  JD.list forecastDecoder

forecastDecoder : JD.Decoder Forecast
forecastDecoder =
  JD.map4 Forecast
    (JD.at [ "time" ] JD.string)
    (JD.at [ "temp_min" ] JD.float)
    (JD.at [ "temp_max" ] JD.float)
    (JD.at [ "icon" ] JD.string)