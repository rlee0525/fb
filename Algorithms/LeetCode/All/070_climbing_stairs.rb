def climb_stairs(n)
  return 1 if n == 1
  return 2 if n == 2

  climb_stairs(n - 1) + climb_stairs(n - 2)
end

def climb_stairs(n)
  dp = [0, 1, 2]
  i = 3
  (3..n).each do |i|
    dp[i] = dp[i - 1] + dp[i - 2]
  end

  dp[n]
end