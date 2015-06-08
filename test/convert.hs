import Test.HUnit

import Convert

full = TestCase (
  do
    input <- readFile "1/input.json"
    output <- readFile "1/output.json"
    assertEqual (convert input) output
  )

tests = TestList [TestLabel "full transformation" full]
