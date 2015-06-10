
data Margin = Margin {
  date :: Date,
  number :: Float,
  description :: String
}

data Collection = Collection {
  date :: Date,
  collection ::   
}

type Margins = [Margin]

type Collections = [Collection]

collect :: Margins -> Collections

combine :: Margin -> Margin -> Margin

convert = (reduce collect) . (sortBy date) . (groupBy date combine)
