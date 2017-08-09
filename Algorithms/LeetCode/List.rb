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

# 15) 3 Sum
# Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.
# Note: The solution set must not contain duplicate triplets.
# For example, given array S = [-1, 0, 1, 2, -1, -4],
# A solution set is:
# [
#   [-1, 0, 1],
#   [-1, -1, 2]
# ]

def three_sum(nums)
  nums.sort!
  solution = []

  (0...nums.length).each do |idx|
    if idx == 0 || nums[idx] != nums[idx - 1]
      low = idx + 1
      high = nums.length - 1

      while low < high
        if nums[idx] + nums[low] + nums[high] == 0
          solution << [nums[idx], nums[low], nums[high]]
          low += 1
          high -= 1

          low += 1 while nums[low] == nums[low - 1]
          high -= 1 while nums[high] == nums[high + 1]
        elsif nums[idx] + nums[low] + nums[high] > 0
          high -= 1
        else
          low += 1
        end
      end
    end
  end

  solution
end

# 17) Letter Combinations of a Phone Number
# Given a digit string, return all possible letter combinations that the number could represent.
# A mapping of digit to letters (just like on the telephone buttons) is given below.
# Input:Digit string "23"
# Output: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"].

def letter_combinations(digits)
  return [] if digits.empty?

  keymap = {
    "1" => "",
    "2" => "abc",
    "3" => "def",
    "4" => "ghi",
    "5" => "jkl",
    "6" => "mno",
    "7" => "pqrs",
    "8" => "tuv",
    "9" => "wxyz",
    "0" => " "
  }

  combinations = keymap[digits[0]].chars
  stack = []

  (1...digits.length).each do |idx|
    stack = combinations
    combinations = []

    until stack.empty?
      current = stack.pop
      keymap[digits[idx]].each_char do |char|
        combinations << current + char
      end
    end
  end

  combinations
end

# 20) Valid Parentheses
# Given a string containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.
# The brackets must close in the correct order, "()" and "()[]{}" are all valid but "(]" and "([)]" are not.

def is_valid(s)
  stack = []
  pairs = {
    "(" => ")",
    "{" => "}",
    "[" => "]"
  }

  s.each_char do |char|
    if pairs[char]
      stack << char
    else
      current = stack.pop
      return false if char != pairs[current]
    end
  end

  stack.empty?
end

# 23) Merge k Sorted Lists
# Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity.

# Priority Queue 
# Time: O(nlogk)
# Space: O(logk)
class PriorityQueue
  attr_accessor :store, :prc

  def initialize(&prc)
    @store = []
  end

  def peek
    @store[0]
  end

  def count
    @store.length
  end

  def self.parent_index(child_index)
    raise "no parent" if (child_index - 1) / 2 < 0
    (child_index - 1) / 2
  end

  def self.child_indices(parent_index, length)
    children = [parent_index * 2 + 1, parent_index * 2 + 2]
    children.select { |child| child < length }
  end

  def self.heapify_up(array, child_index, &prc)
    return array if child_index == 0

    prc ||= Proc.new { |a, b| a <=> b }
    parent_index = parent_index(child_index)

    if prc.call(array[child_index][0], array[parent_index][0]) < 0
      array[child_index], array[parent_index] = array[parent_index], array[child_index]
      heapify_up(array, parent_index, &prc)
    end

    array
  end

  def self.heapify_down(array, parent_index, &prc)
    prc ||= Proc.new { |a, b| a <=> b }
    children = child_indices(parent_index, array.length)

    if children.length == 2
      child = prc.call(array[children[0]][0], array[children[1]][0]) < 1 ? children[0] : children[1]
    elsif children.length == 1
      child = children[0]
    else
      return array
    end

    if prc.call(array[child][0], array[parent_index][0]) < 0
      array[child], array[parent_index] = array[parent_index], array[child]
      heapify_down(array, child, &prc)
    end

    array
  end

  def push(val)
    @store << val
    PriorityQueue.heapify_up(@store, count - 1, &prc)
  end

  def extract
    @store[0], @store[count - 1] = @store[count - 1], @store[0]
    extracted = @store.pop
    PriorityQueue.heapify_down(@store, 0, &prc)
    extracted
  end
end

def merge_k_lists(lists)
  dummy = current = ListNode.new(nil)
  queue = PriorityQueue.new

  lists.each do |list|
    queue.push([list.val, list]) if list
  end

  until queue.count == 0
    smallest = queue.extract[1]
    current.next = smallest
    current = current.next
    queue.push([smallest.next.val, smallest.next]) if smallest.next
  end

  dummy.next
end

# Divide and Conquer
# Time: O(nlogk)
# Space: O(1)
def merge_two_lists(list1, list2)
  return list2 unless list1
  return list1 unless list2

  dummy = current = ListNode.new(nil)

  while list1 && list2
    if list1.val > list2.val
      current.next = list2
      list2 = list2.next
      current = current.next
    else
      current.next = list1
      list1 = list1.next
      current = current.next
    end
  end

  current.next = list1 if list1
  current.next = list2 if list2

  dummy.next
end

def merge_k_lists(lists)
  return [] if lists.empty?
  return lists[0] if lists.length == 1
  return merge_two_lists(lists[0], lists[1]) if lists.length == 2

  mid = lists.length / 2
  return merge_two_lists(merge_k_lists(lists[0...mid]), merge_k_lists(lists[mid..-1]))
end

# 25) Reverse Nodes in k-Group
# Given a linked list, reverse the nodes of a linked list k at a time and return its modified list.
# k is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of k then left-out nodes in the end should remain as it is.
# You may not alter the values in the nodes, only nodes itself may be changed.
# Only constant memory is allowed.
# For example,
# Given this linked list: 1->2->3->4->5
# For k = 2, you should return: 2->1->4->3->5
# For k = 3, you should return: 3->2->1->4->5

def reverse_k_group(head, k)
  # no need to reverse unless head and k > 1
  return head unless head || k > 1

  # create a dummy to start and refer to later when returning the result
  dummy = ListNode.new(0)
  dummy.next = head

  # 3 pointers:
    # pre for starting point that only changes after reversing segments
    # curr for current node that keeps on iterating
    # nex for node after the current (curr and nex required for reversing)
  pre = curr = nex = dummy
  count = 0

  # Find out the length of the list
  while curr.next
    curr = curr.next
    count += 1
  end

  # while there are segments with length of k in the list
  while count >= k
    # set current as the first node of the segment
    curr = pre.next
    # set nex as the last node of the segment
    nex = curr.next

    # iterate k - 1 times
    # swapping two numbers each time
    # always inserting the last of that specific segment to the first (pre.next)
    (k - 1).times do
      # connect current to node 2 after it
      curr.next = nex.next
      # node after current is connected with the first node
      nex.next = pre.next
      # reassign the first node of that segment
      pre.next = nex
      # nex is the only value that keeps changing
      nex = curr.next
    end

    # the starting point changes to current which is right before the first node of the next segment
    pre = curr
    # completing one k segment
    count -= k
  end

  dummy.next
end

# 26) Remove Duplicates from Sorted Array
# Given a sorted array, remove the duplicates in place such that each element appear only once and return the new length.
# Do not allocate extra space for another array, you must do this in place with constant memory.
# For example,
# Given input array nums = [1,1,2],
# Your function should return length = 2, with the first two elements of nums being 1 and 2 respectively. It doesn't matter what you leave beyond the new length.

def remove_duplicates(nums)
  return 0 if nums.empty? 

  slow = 0
  fast = 1

  while fast < nums.length
    if nums[slow] != nums[fast]
      slow += 1
      nums[slow] = nums[fast]
    end

    fast += 1
  end

  slow + 1
end

# 28) Implement strStr()
# Implement strStr().
# Returns the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.

# Brute-force 
# Time: O(NM)
def str_str(haystack, needle)
  return 0 if haystack.empty? && needle.empty?

  (0...haystack.length).each do |i|
    return i if haystack[i...i + needle.length] == needle
  end

  -1
end

# KMP Substring Search
# Within the pattern, is there a suffix that matches prefix?
# Build temp array O(n) for the pattern
def create_pattern(pattern)
  # prefix pointer
  j = 0
  # iterating pointer
  i = 1
  # temp array with first index as always 0
  arr = [0]

  # iterate O(n)
  while i < pattern.length
    # if values at two pointers match, store j + 1 and move both pointers
    if pattern[i] == pattern[j]
      arr[i] = j + 1
      j += 1
      i += 1
    else
      # if j is not 0 and still not the same, we look at previous index value and move j pointer
      if j != 0
        j = arr[j - 1]
      else
      # if j is 0 and pattern is different, we set the value to 0
      # iterate
        arr[i] = 0
        i += 1
      end
    end
  end

  arr
end

def str_str(string, pattern)
  return 0 if pattern.empty?

  temp = create_pattern(pattern)
  i, j = 0, 0

  while i < string.length && j < pattern.length
    if string[i] == pattern[j]
      j += 1
      i += 1
      return i - pattern.length if j == pattern.length
    else
      if j != 0
        j = temp[j - 1]
      else
        i += 1
      end
    end
  end

  -1
end

# 33) Search in Rotated Sorted Array
# Suppose an array sorted in ascending order is rotated at some pivot unknown to you beforehand.
# (i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2).
# You are given a target value to search. If found in the array return its index, otherwise return -1.
# You may assume no duplicate exists in the array.

# Brute force O(n)
def search(nums, target)
  nums.each_with_index do |num, idx|
    return idx if target == num
  end

  -1
end

# Binary Search O(log n)
def search(nums, target)
  low, high = 0, nums.length - 1

  while low <= high
    mid = (low + high) / 2
    return mid if nums[mid] == target

    if nums[low] <= nums[mid]
      if nums[low] <= target && target < nums[mid]
        high = mid - 1
      else
        low = mid + 1
      end
    else
      if nums[mid] < target && target <= nums[high]
        low = mid + 1
      else
        high = mid - 1
      end
    end
  end

  -1
end

# 38) Count and Say
# The count-and-say sequence is the sequence of integers with the first five terms as following:
# 1.     1
# 2.     11
# 3.     21
# 4.     1211
# 5.     111221
# 1 is read off as "one 1" or 11.
# 11 is read off as "two 1s" or 21.
# 21 is read off as "one 2, then one 1" or 1211.
# Given an integer n, generate the nth term of the count-and-say sequence.
# Note: Each term of the sequence of integers will be represented as a string.
# Example 1:
# Input: 1
# Output: "1"
# Example 2:
# Input: 4
# Output: "1211"

def count_and_say(n)
  output = current = "1"
  
  (n - 1).times do
    output = ""
    prev = current[0]
    count = 0
    idx = 0

    while idx < current.length
      if prev == current[idx]
        count += 1
      else
        output += count.to_s + prev
        prev = current[idx]
        count = 1
      end

      idx += 1
    end
    
    output += count.to_s + prev unless count == 0
    current = output
  end

  current
end
























