import Test.HUnit

import Convert

full = TestCase (
  do
    input <- readFile "input.json"
    output <- readFile "output.json"
    assertEqual (convert input) output
  )

tests = TestList [TestLabel "full transformation" full]
