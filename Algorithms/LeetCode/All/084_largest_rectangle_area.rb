# @param {Integer[]} heights
# @return {Integer}
# O(N ^ 2) => TLE
def largest_rectangle_area(heights)
  max_rect = 0
  i = 0
  while i < heights.length
    while i + 1 < heights.length && heights[i] <= heights[i + 1]
      i += 1
    end

    j = i
    while j >= 0
      h = [heights[i], heights[j]].min
      max_rect = [max_rect, h * (i - j + 1)]
      j -= 1
    end

    i += 1
  end

  max_rect
end