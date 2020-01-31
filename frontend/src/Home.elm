module Home exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, float, string, map4)

-- TYPES

type alias Forecast =
  { time : String
  , temp_min : Float
  , temp_max : Float
  , icon : String
  }

type alias Forecasts = List Forecast

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


type Model
  = Loading
  | Success Forecasts
  | Failure Http.Error

type Msg
  = GotForecast (Result Http.Error Forecasts)

init : () -> (Model, Cmd Msg)
init _ =
  (Loading, loadForecast)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
  case msg of
    GotForecast result ->
      case result of
        Ok forecasts -> (Success forecasts, Cmd.none)
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
    Success forecast -> renderWeather forecast
    Failure err ->
      h2 [] [ text (buildErrorMessage err) ]

renderWeather : Forecasts -> Html Msg
renderWeather forecasts =
  div [ id "weather-info" ]
    [ ul [ class "forecast" ] (List.map renderForecast forecasts) ]

renderForecast : Forecast -> Html Msg
renderForecast forecast =
  li [ class "forecast-entry" ]
    [ span [ class "time" ] [ text forecast.time ]
    , img [ class "icon", src (iconUrl forecast.icon) ] []
    , div [ class "clearfix" ] []
    , renderTemperature forecast.temp_min forecast.temp_max
    ]

renderTemperature : Float -> Float -> Html Msg
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

-- HTTP


loadForecast : Cmd Msg
loadForecast =
  Http.get
    { url = "/weather"
    , expect = Http.expectJson GotForecast forecastsDecoder
    }


forecastsDecoder : Decoder (List Forecast)
forecastsDecoder =
  Decode.list forecastDecoder

forecastDecoder : Decoder Forecast
forecastDecoder =
  Decode.map4 Forecast
    (Decode.at [ "time" ] Decode.string)
    (Decode.at [ "temp_min" ] Decode.float)
    (Decode.at [ "temp_max" ] Decode.float)
    (Decode.at [ "icon" ] Decode.string)



-- DEBUG

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
  case httpError of
    Http.BadUrl message ->
      message

    Http.Timeout ->
      "Server is taking too long to respond. Please try again later."

    Http.NetworkError ->
      "Unable to reach server."

    Http.BadStatus statusCode ->
      "Request failed with status code: " ++ String.fromInt statusCode

    Http.BadBody message ->
      message

