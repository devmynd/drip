
func cache<I, O>(function: I -> O) -> I -> O {
  var memo: O?

  return { input in
    memo = memo ?? function(input)
    return memo!
  }
}