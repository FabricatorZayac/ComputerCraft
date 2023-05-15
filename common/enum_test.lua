local enum = require("enum")

Foo = enum {
  "BAR",
  "BAZ",
  "QUX",
  "QUUX",
}

local bar = Foo.BAR()
assert(bar:match {
  BAR = 6
} == 6)

local baz = Foo.BAZ({5, 6, 7})
assert(baz:match {
  BAZ = function (a, b, _)
    return b + 5 + a
  end
} == 16)

local qux = Foo.QUX {
  foo = "qwerty",
  bar = {
    baz = "asdf",
  },
}
assert(qux:match {
  BAR = 1,
  BAZ = 2,
  QUX = {
    {"foo", "bar"},
    function (x, y)
      return x .. 5 .. y.baz
    end,
  },
  QUUX = 4,
} == "qwerty5asdf")

local quux = Foo.QUUX(5)
assert(quux:match {
  QUUX = function (q)
    return q + 5
  end
} == 10)

assert(getmetatable(Foo) == "enum")
assert(getmetatable(Foo.BAR) == "enum_variant")
assert(getmetatable(Foo.BAR()) == "enum_variant_instance")

local garply = Enum.fromtable {
  BAR = {
    foo = 5
  },
}

assert(garply:match {
  BAR = {
    {"foo"},
    function (x)
      return x - 3
    end
  },
} == 2)
