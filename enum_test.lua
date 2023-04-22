local enum = require("enum")

Foo = enum {
  "BAR",
  "BAZ",
  "QUX",
  "QUUX",
}

local bar = Foo.BAR()
assert(bar.label == "BAR")

local baz = Foo.BAZ({5, 6, 7})
assert(baz.label == "BAZ")
assert(baz.body[1] == 5)
assert(baz.body[2] == 6)
assert(baz.body[3] == 7)

assert(baz:switch {
  BAZ = function (_, b, _)
    return b + 5
  end
} == 11)

local qux = Foo.QUX {
  foo = "qwerty",
  bar = {
    baz = "asdf",
  },
}
assert(qux.label == "QUX")
assert(qux.body.foo == "qwerty")
assert(qux.body.bar.baz == "asdf")

assert(qux:switch {
  BAR = 1,
  BAZ = 2,
  QUX = qux.body.foo .. 5,
  QUUX = 4,
} == "qwerty5")

local quux = Foo.QUUX(5)
assert(quux.label == "QUUX")
assert(quux.body == 5)

assert(quux:switch {
  QUUX = function (q)
    return q + 5
  end
} == 10)

assert(getmetatable(Foo) == "enum")
assert(getmetatable(Foo.BAR) == "variant")
assert(getmetatable(Foo.BAR()) == "variant_instance")
