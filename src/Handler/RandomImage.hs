{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.RandomImage where

import Import
import Data.Text (replace)

import System.Random
import PolygonArt (randomizedPolygonArt, polygon, Vertex(Vertex))
import SvgDrawing (drawPolygon, drawSvg)

getRandomImageR :: Int -> Handler Text
getRandomImageR seed = sendResponse (typeSvg, toContent image)
  where
    image :: Text
    image = (
          fromString
        . generateImage
      )
        seed

generateImage :: Int -> String
generateImage seed = drawSvg size size (map drawPolygon art)
  where
    -- width and height of the image
    size = 1000.0 :: Double
    -- starting polygon: A rectangle
    rectangle = polygon [Vertex 0 0, Vertex size 0, Vertex size size, Vertex 0 size]
    poly = rectangle

    -- generate the image
    generator = mkStdGen seed
    art = randomizedPolygonArt generator 6 poly
