
data Margin = Margin {
  date :: Date,
  number :: Float,
  description :: String
}

data Average = Average {
  size :: Int,
  value :: Float
}

data Analysis = Analysis {
  date :: Date,
  averages :: [Average]
}

analyse :: [Margin

collect :: [Margin] -> [Analysis]
collect = 

combine :: Margin -> Margin -> Margin

convert = (reduce collect) . (sortBy date) . (groupBy date combine)
