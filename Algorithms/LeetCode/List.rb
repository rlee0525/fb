# 1) Two Sum
# Given an array of integers, return indices of the two numbers such that they add up to a specific target.
# You may assume that each input would have exactly one solution, and you may not use the same element twice.

def two_sum(nums, target)
  seen = {}
  nums.each_with_index do |num, idx|
    return [seen[num], idx] if seen[num]
    seen[target - num] = idx
  end
end

# 10) Regex Matching
# Implement regular expression matching with support for '.' and '*'.
# '.' Matches any single character.
# '*' Matches zero or more of the preceding element.
# The matching should cover the entire input string (not partial).
# The function prototype should be:
# bool isMatch(const char *s, const char *p)
# Some examples:
# isMatch("aa","a") ? false
# isMatch("aa","aa") ? true
# isMatch("aaa","aa") ? false
# isMatch("aa", "a*") ? true
# isMatch("aa", ".*") ? true
# isMatch("ab", ".*") ? true
# isMatch("aab", "c*a*b") ? true

# Recursive solution - TLE
def is_match(string, pattern)
  # string has to be empty when pattern becomes empty
  # iterate through both till they both reach the end
  # pattern should always reach end before the string
  return string.empty? if pattern.empty?

  if pattern[1] == "*"
    # 1) recursively check next pattern (zero of preceding element)
    # 2) recursively check '*' did something
    is_match(string, pattern[2..-1]) ||
      !string.empty? &&
      (string[0] == pattern[0] || pattern[0] == ".") &&
      is_match(string[1..-1], pattern)
  else
    # 1) return false if string is empty and pattern isn't
    # 2) check if first char is the same for both or is '.'
    # 3) recursively call next chars
    !string.empty? && 
      (string[0] == pattern[0] || pattern[0] == ".") && 
      is_match(string[1..-1], pattern[1..-1])
  end
end

# DP solution

# T[i][j] = true => pattern matches!
# i = text
# j = pattern

# T[i - 1][j - 1] if str[i] == pattern[j] || pattern[j] == '.'
# value at i matches pattern at j => we can remove them

# T[i][j - 2] if pattern[j] == "*" && 0 occurrence
# T[i - 1][j] if pattern[j] == "*" && str[i] == pattern[j - 1] || pattern[j - 1] == '.'

# False
# T[0][0] = true for empty string edge case
# T[][0] = all false
# T[0][] = all false unless we have * in the second char of the pattern

def is_match(string, pattern)
  # row as string (i), col as pattern (j)
  # if pattern doesn't have "*" at index 1, all empty string / pattern == false
  # if pattern char dosen't match string char, it's false
  # set default as false
  table = Array.new(string.length + 1) { Array.new(pattern.length + 1, false) }

  # initialize empty string || pattern logic
  table[0][0] = true

  # pattern with empty string
  (1...table[0].length).each do |j|
    if pattern[j - 1] == "*"
      table[0][j] = table[0][j - 2]
    end
  end

  (1...table.length).each do |i|
    (1...table[0].length).each do |j|
      # if pattern matches, take previous values and set it
      if string[i - 1] == pattern[j - 1] || pattern[j - 1] == "."
        table[i][j] = table[i - 1][j - 1]
      # 2 cases for wildcard:
        # 1) 0 occurrences => take [i][j - 2]
        # 2) 1+ occurrences => take [i - 1][j]
        # => string[i] == pattern[j - 1] || pattern[j - 1] == ".""
      elsif pattern[j - 1] == "*"
        table[i][j] = table[i][j - 2]
        if string[i - 1] == pattern[j - 2] || pattern[j - 2] == "."
          # Whatever is true takes precedence
          table[i][j] = table[i][j] || table[i - 1][j]
        end
      end
    end
  end

  table[string.length][pattern.length]
end

# 13) Roman to Integer
# Given a roman numeral, convert it to an integer.
# Input is guaranteed to be within the range from 1 to 3999.

def roman_to_int(s)
  romans = {
    "I" => 1,
    "V" => 5,
    "X" => 10,
    "L" => 50,
    "C" => 100,
    "D" => 500,
    "M" => 1000
  }

  prev, result, idx = 0, 0, s.length - 1

  while idx >= 0
    current = romans[s[idx]]
    if current >= prev
      result += current
    else
      result -= current
    end

    prev = current
    idx -= 1
  end

  result
end





