module Panels.TubeStatusPanel exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JD exposing (string, map2)
import Http exposing (Error)

import CommonTypes exposing (..)
import ViewHelpers exposing (..)

-- TYPES

type alias LineStatus =
  { line : String
  , status : String
  }
type alias TubeStatus = List LineStatus

render : HttpResult -> Html str
render result =
  case result of
    Ok json ->
      case JD.decodeString tubeStatusDecoder json of
        Ok tubeStatus -> renderTubeStatus tubeStatus
        Err err -> text <| "error: " ++ JD.errorToString err
    Err err ->
      text (formatHttpResponseError err)

-- VIEW

renderTubeStatus : TubeStatus -> Html str
renderTubeStatus lines =
  div [ id "tube-disruptions" ] <| List.map renderLine lines

renderLine : LineStatus -> Html str
renderLine line =
  div [ class line.line, class "column" ]
    [ p []
      [ text line.status ]
    ]

-- JSON

tubeStatusDecoder : JD.Decoder TubeStatus
tubeStatusDecoder =
  JD.list lineStatusDecoder

lineStatusDecoder : JD.Decoder LineStatus
lineStatusDecoder =
  JD.map2 LineStatus
    (JD.at [ "line" ] JD.string)
    (JD.at [ "status" ] JD.string)
