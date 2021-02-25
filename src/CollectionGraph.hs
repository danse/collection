{-# LANGUAGE DeriveDataTypeable,DeriveGeneric #-}
module CollectionGraph where

import Visie
import Visie.ToTimeSeries (convert, Timestamped(..))
import Visie.Data
import Data.DateTime (DateTime, getCurrentTime)
import Data.Time.Clock (NominalDiffTime, UTCTime)
import Data.Aeson (encode, eitherDecode, FromJSON, ToJSON)
import Data.Functor (fmap)
import Data.Typeable
import Data.Data
import GHC.Generics
import Data.ByteString.Lazy (ByteString, toStrict)
import Data.Either (rights, Either(Right))
import Paths_collection_graph (getDataFileName)
import Data.Text.Encoding (decodeUtf8)
import Data.Text (Text)

data Average = Average {
  size :: Int,
  value :: Float
} deriving (Show, Typeable, Data, Generic, Eq)

instance FromJSON Average
instance ToJSON Average

data Analysis = Analysis {
  date :: DateTime,
  averages :: [Average]
} deriving (Show, Typeable, Data, Generic, Eq)

instance FromJSON Analysis
instance ToJSON Analysis

collectionToAverage :: [Timestamped TextFloat] -> Average
collectionToAverage c = Average { size=l, value=v}
  where l = length c
        s = sum $ map (getFloat . getStamped) c
        v = s / (fromIntegral l)

collectionToAverages :: [Timestamped TextFloat] -> [Average]
collectionToAverages [] = []
collectionToAverages coll = a:as
  where a = collectionToAverage coll
        as = collectionToAverages $ tail coll

analyse :: [Timestamped TextFloat] -> Analysis
analyse collection = Analysis { date=date, averages=averages }
  where date = getTime (head collection)
        averages = reverse $ collectionToAverages $ reverse collection

collect :: [Timestamped TextFloat] -> [Analysis]
collect [] = []
collect points = ((collect . tail) points) ++ [analyse points]

analyseAll :: Int -> [Timestamped TextFloat] -> [Analysis]
analyseAll days = collect . reverse . convert (fromIntegral days * oneDay)
  where oneDay = 60 * 60 * 24 :: NominalDiffTime

transform :: Int -> Bool -> UTCTime -> [(Text, Float, UTCTime)] -> Text
transform days fill curr = decodeUtf8
                      . toStrict
                      . encode
                      . analyseAll days
                      . (if fill then (Timestamped mempty curr:) else id)
                      . map toTimestampedTextFloat

options = defaultOptions { d3Version = Version3 }

collectionGraph :: Int -> Bool -> [(Text, Float, UTCTime)] -> IO ()
collectionGraph days fill d = do
  curr <- getCurrentTime
  customVisie options getDataFileName (transform days fill curr) d
