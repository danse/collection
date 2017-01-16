{-# LANGUAGE OverloadedStrings #-}
import CollectionGraph
import Data.Monoid ((<>))
import Data.Time.Calendar (fromGregorian)
import Data.Time.Clock

-- make an universal time value using year, month, day
makeUni :: Integer -> Int -> Int -> UTCTime
makeUni y m d = UTCTime (fromGregorian y m d) (secondsToDiffTime 0)


d = [("a", 10, makeUni 2017 1 1),
     ("b", 5, makeUni 2017 1 1),
     ("c", 30, makeUni 2017 1 1),
     ("a", 10, makeUni 2017 1 2),
     ("b", 10, makeUni 2017 1 2),
     ("c", 15, makeUni 2017 1 2),
     ("a", 10, makeUni 2017 1 3),
     ("b", 15, makeUni 2017 1 3),
     ("c", 20, makeUni 2017 1 3)]

main = collectionGraph 1 d
