# @param {Integer[]} heights
# @return {Integer}
# O(N ^ 2)
def largest_rectangle_area(heights)
  max_rect = 0
  i = 0
  while i < heights.length
    while i + 1 < heights.length && heights[i] <= heights[i + 1]
      i += 1
    end

    j = i
    h = heights[i]
    while j >= 0
      h = [h, heights[j]].min
      max_rect = [max_rect, h * (i - j + 1)].max
      j -= 1
    end

    i += 1
  end

  max_rect
end

# O(N) - increasing stack data structure
def largest_rectangle_area(heights)
  stack = []
  max_area = 0
  i = 0

  while i < heights.length
    if stack.empty? || heights[i] >= heights[stack[-1]]
      stack << i
    else
      shortest = stack.pop
      left = stack.empty? ? 0 : stack[-1] + 1
      max_area = [max_area, heights[shortest] * (i - left)].max
      i -= 1
    end

    i += 1
  end

  current = heights.length
  while !stack.empty?
    shortest = stack.pop
    left = stack.empty? ? 0 : stack[-1] + 1
    max_area = [max_area, heights[shortest] * (current - left)].max
  end

  max_area
end




















