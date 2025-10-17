return {
  black = 0x002c2e42,
  white = 0xffffffff,
  red = 0xffffffff,
  green = 0xffffffff,
  blue = 0xffffffff,
  yellow = 0xffffffff,
  orange = 0xffffffff,
  magenta = 0xffffffff,
  grey = 0xccffffff,
  transparent = 0x00000000,

  bar = {
    bg = 0x00000000,
    border = 0x00000000,
  },
  popup = {
    bg = 0x802c2e42,
    border = 0x802c2e42,
  },
  bg1 = 0x402c2e42,
  bg2 = 0x00000000,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
