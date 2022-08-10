// output/Data.Functor/foreign.js
var arrayMap = function(f) {
  return function(arr) {
    var l = arr.length;
    var result = new Array(l);
    for (var i4 = 0; i4 < l; i4++) {
      result[i4] = f(arr[i4]);
    }
    return result;
  };
};

// output/Control.Semigroupoid/index.js
var semigroupoidFn = {
  compose: function(f) {
    return function(g) {
      return function(x) {
        return f(g(x));
      };
    };
  }
};

// output/Control.Category/index.js
var identity = function(dict) {
  return dict.identity;
};
var categoryFn = {
  identity: function(x) {
    return x;
  },
  Semigroupoid0: function() {
    return semigroupoidFn;
  }
};

// output/Data.Boolean/index.js
var otherwise = true;

// output/Data.Function/index.js
var flip = function(f) {
  return function(b) {
    return function(a) {
      return f(a)(b);
    };
  };
};
var $$const = function(a) {
  return function(v) {
    return a;
  };
};

// output/Data.Unit/foreign.js
var unit = void 0;

// output/Data.Functor/index.js
var map = function(dict) {
  return dict.map;
};
var $$void = function(dictFunctor) {
  return map(dictFunctor)($$const(unit));
};
var functorArray = {
  map: arrayMap
};

// output/Data.Semigroup/index.js
var append = function(dict) {
  return dict.append;
};
var semigroupFn = function(dictSemigroup) {
  var append13 = append(dictSemigroup);
  return {
    append: function(f) {
      return function(g) {
        return function(x) {
          return append13(f(x))(g(x));
        };
      };
    }
  };
};

// output/Control.Apply/foreign.js
var arrayApply = function(fs) {
  return function(xs) {
    var l = fs.length;
    var k = xs.length;
    var result = new Array(l * k);
    var n = 0;
    for (var i4 = 0; i4 < l; i4++) {
      var f = fs[i4];
      for (var j = 0; j < k; j++) {
        result[n++] = f(xs[j]);
      }
    }
    return result;
  };
};

// output/Control.Apply/index.js
var applyArray = {
  apply: arrayApply,
  Functor0: function() {
    return functorArray;
  }
};
var apply = function(dict) {
  return dict.apply;
};

// output/Control.Applicative/index.js
var pure = function(dict) {
  return dict.pure;
};
var applicativeArray = {
  pure: function(x) {
    return [x];
  },
  Apply0: function() {
    return applyArray;
  }
};

// output/Data.Bounded/foreign.js
var topInt = 2147483647;
var bottomInt = -2147483648;
var topChar = String.fromCharCode(65535);
var bottomChar = String.fromCharCode(0);
var topNumber = Number.POSITIVE_INFINITY;
var bottomNumber = Number.NEGATIVE_INFINITY;

// output/Data.Ord/foreign.js
var unsafeCompareImpl = function(lt) {
  return function(eq6) {
    return function(gt) {
      return function(x) {
        return function(y) {
          return x < y ? lt : x === y ? eq6 : gt;
        };
      };
    };
  };
};
var ordIntImpl = unsafeCompareImpl;
var ordNumberImpl = unsafeCompareImpl;

// output/Data.Eq/foreign.js
var refEq = function(r1) {
  return function(r2) {
    return r1 === r2;
  };
};
var eqIntImpl = refEq;
var eqNumberImpl = refEq;
var eqArrayImpl = function(f) {
  return function(xs) {
    return function(ys) {
      if (xs.length !== ys.length)
        return false;
      for (var i4 = 0; i4 < xs.length; i4++) {
        if (!f(xs[i4])(ys[i4]))
          return false;
      }
      return true;
    };
  };
};

// output/Data.Eq/index.js
var eqUnit = {
  eq: function(v) {
    return function(v1) {
      return true;
    };
  }
};
var eqNumber = {
  eq: eqNumberImpl
};
var eqInt = {
  eq: eqIntImpl
};
var eq = function(dict) {
  return dict.eq;
};
var eqArray = function(dictEq) {
  return {
    eq: eqArrayImpl(eq(dictEq))
  };
};

// output/Data.Ordering/index.js
var LT = /* @__PURE__ */ function() {
  function LT2() {
  }
  ;
  LT2.value = new LT2();
  return LT2;
}();
var GT = /* @__PURE__ */ function() {
  function GT2() {
  }
  ;
  GT2.value = new GT2();
  return GT2;
}();
var EQ = /* @__PURE__ */ function() {
  function EQ2() {
  }
  ;
  EQ2.value = new EQ2();
  return EQ2;
}();

// output/Data.Semiring/foreign.js
var numAdd = function(n1) {
  return function(n2) {
    return n1 + n2;
  };
};
var numMul = function(n1) {
  return function(n2) {
    return n1 * n2;
  };
};

// output/Data.Semiring/index.js
var zero = function(dict) {
  return dict.zero;
};
var semiringNumber = {
  add: numAdd,
  zero: 0,
  mul: numMul,
  one: 1
};
var add = function(dict) {
  return dict.add;
};

// output/Data.Ord/index.js
var ordNumber = /* @__PURE__ */ function() {
  return {
    compare: ordNumberImpl(LT.value)(EQ.value)(GT.value),
    Eq0: function() {
      return eqNumber;
    }
  };
}();
var ordInt = /* @__PURE__ */ function() {
  return {
    compare: ordIntImpl(LT.value)(EQ.value)(GT.value),
    Eq0: function() {
      return eqInt;
    }
  };
}();
var compare = function(dict) {
  return dict.compare;
};
var greaterThan = function(dictOrd) {
  var compare32 = compare(dictOrd);
  return function(a1) {
    return function(a2) {
      var v = compare32(a1)(a2);
      if (v instanceof GT) {
        return true;
      }
      ;
      return false;
    };
  };
};
var lessThan = function(dictOrd) {
  var compare32 = compare(dictOrd);
  return function(a1) {
    return function(a2) {
      var v = compare32(a1)(a2);
      if (v instanceof LT) {
        return true;
      }
      ;
      return false;
    };
  };
};
var lessThanOrEq = function(dictOrd) {
  var compare32 = compare(dictOrd);
  return function(a1) {
    return function(a2) {
      var v = compare32(a1)(a2);
      if (v instanceof GT) {
        return false;
      }
      ;
      return true;
    };
  };
};
var max = function(dictOrd) {
  var compare32 = compare(dictOrd);
  return function(x) {
    return function(y) {
      var v = compare32(x)(y);
      if (v instanceof LT) {
        return y;
      }
      ;
      if (v instanceof EQ) {
        return x;
      }
      ;
      if (v instanceof GT) {
        return x;
      }
      ;
      throw new Error("Failed pattern match at Data.Ord (line 181, column 3 - line 184, column 12): " + [v.constructor.name]);
    };
  };
};
var min = function(dictOrd) {
  var compare32 = compare(dictOrd);
  return function(x) {
    return function(y) {
      var v = compare32(x)(y);
      if (v instanceof LT) {
        return x;
      }
      ;
      if (v instanceof EQ) {
        return x;
      }
      ;
      if (v instanceof GT) {
        return y;
      }
      ;
      throw new Error("Failed pattern match at Data.Ord (line 172, column 3 - line 175, column 12): " + [v.constructor.name]);
    };
  };
};

// output/Data.Bounded/index.js
var top = function(dict) {
  return dict.top;
};
var boundedInt = {
  top: topInt,
  bottom: bottomInt,
  Ord0: function() {
    return ordInt;
  }
};
var bottom = function(dict) {
  return dict.bottom;
};

// output/Data.Show/foreign.js
var showIntImpl = function(n) {
  return n.toString();
};
var showNumberImpl = function(n) {
  var str = n.toString();
  return isNaN(str + ".0") ? str : str + ".0";
};

// output/Data.Show/index.js
var showNumber = {
  show: showNumberImpl
};
var showInt = {
  show: showIntImpl
};
var show = function(dict) {
  return dict.show;
};

// output/Data.Maybe/index.js
var identity2 = /* @__PURE__ */ identity(categoryFn);
var Nothing = /* @__PURE__ */ function() {
  function Nothing2() {
  }
  ;
  Nothing2.value = new Nothing2();
  return Nothing2;
}();
var Just = /* @__PURE__ */ function() {
  function Just2(value0) {
    this.value0 = value0;
  }
  ;
  Just2.create = function(value0) {
    return new Just2(value0);
  };
  return Just2;
}();
var maybe = function(v) {
  return function(v1) {
    return function(v2) {
      if (v2 instanceof Nothing) {
        return v;
      }
      ;
      if (v2 instanceof Just) {
        return v1(v2.value0);
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 237, column 1 - line 237, column 51): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
    };
  };
};
var isNothing = /* @__PURE__ */ maybe(true)(/* @__PURE__ */ $$const(false));
var functorMaybe = {
  map: function(v) {
    return function(v1) {
      if (v1 instanceof Just) {
        return new Just(v(v1.value0));
      }
      ;
      return Nothing.value;
    };
  }
};
var map2 = /* @__PURE__ */ map(functorMaybe);
var fromMaybe = function(a) {
  return maybe(a)(identity2);
};
var fromJust = function() {
  return function(v) {
    if (v instanceof Just) {
      return v.value0;
    }
    ;
    throw new Error("Failed pattern match at Data.Maybe (line 288, column 1 - line 288, column 46): " + [v.constructor.name]);
  };
};
var applyMaybe = {
  apply: function(v) {
    return function(v1) {
      if (v instanceof Just) {
        return map2(v.value0)(v1);
      }
      ;
      if (v instanceof Nothing) {
        return Nothing.value;
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 67, column 1 - line 69, column 30): " + [v.constructor.name, v1.constructor.name]);
    };
  },
  Functor0: function() {
    return functorMaybe;
  }
};
var bindMaybe = {
  bind: function(v) {
    return function(v1) {
      if (v instanceof Just) {
        return v1(v.value0);
      }
      ;
      if (v instanceof Nothing) {
        return Nothing.value;
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 125, column 1 - line 127, column 28): " + [v.constructor.name, v1.constructor.name]);
    };
  },
  Apply0: function() {
    return applyMaybe;
  }
};

// output/Data.String.Read/index.js
var read = function(dict) {
  return dict.read;
};

// output/CommonTypes/index.js
var compare2 = /* @__PURE__ */ compare(ordInt);
var fromJust2 = /* @__PURE__ */ fromJust();
var Married = /* @__PURE__ */ function() {
  function Married2() {
  }
  ;
  Married2.value = new Married2();
  return Married2;
}();
var HeadOfHousehold = /* @__PURE__ */ function() {
  function HeadOfHousehold2() {
  }
  ;
  HeadOfHousehold2.value = new HeadOfHousehold2();
  return HeadOfHousehold2;
}();
var Single = /* @__PURE__ */ function() {
  function Single2() {
  }
  ;
  Single2.value = new Single2();
  return Single2;
}();
var readFilingStatus = {
  read: function(s) {
    if (s === "Married") {
      return new Just(Married.value);
    }
    ;
    if (s === "HOH") {
      return new Just(HeadOfHousehold.value);
    }
    ;
    if (s === "HeadOfHousehold") {
      return new Just(HeadOfHousehold.value);
    }
    ;
    if (s === "Single") {
      return new Just(Single.value);
    }
    ;
    return Nothing.value;
  }
};
var read2 = /* @__PURE__ */ read(readFilingStatus);
var eqFilingStatus = {
  eq: function(x) {
    return function(y) {
      if (x instanceof Married && y instanceof Married) {
        return true;
      }
      ;
      if (x instanceof HeadOfHousehold && y instanceof HeadOfHousehold) {
        return true;
      }
      ;
      if (x instanceof Single && y instanceof Single) {
        return true;
      }
      ;
      return false;
    };
  }
};
var ordFilingStatus = {
  compare: function(x) {
    return function(y) {
      if (x instanceof Married && y instanceof Married) {
        return EQ.value;
      }
      ;
      if (x instanceof Married) {
        return LT.value;
      }
      ;
      if (y instanceof Married) {
        return GT.value;
      }
      ;
      if (x instanceof HeadOfHousehold && y instanceof HeadOfHousehold) {
        return EQ.value;
      }
      ;
      if (x instanceof HeadOfHousehold) {
        return LT.value;
      }
      ;
      if (y instanceof HeadOfHousehold) {
        return GT.value;
      }
      ;
      if (x instanceof Single && y instanceof Single) {
        return EQ.value;
      }
      ;
      throw new Error("Failed pattern match at CommonTypes (line 0, column 0 - line 0, column 0): " + [x.constructor.name, y.constructor.name]);
    };
  },
  Eq0: function() {
    return eqFilingStatus;
  }
};
var eqAge = {
  eq: function(x) {
    return function(y) {
      return x === y;
    };
  }
};
var ordAge = {
  compare: function(x) {
    return function(y) {
      return compare2(x)(y);
    };
  },
  Eq0: function() {
    return eqAge;
  }
};
var unsafeReadFilingStatus = function(s) {
  return fromJust2(read2(s));
};
var isUnmarried = function(v) {
  if (v instanceof Married) {
    return false;
  }
  ;
  return true;
};

// output/Data.Date/foreign.js
var createDate = function(y, m, d) {
  var date = new Date(Date.UTC(y, m, d));
  if (y >= 0 && y < 100) {
    date.setUTCFullYear(y);
  }
  return date;
};
function canonicalDateImpl(ctor, y, m, d) {
  var date = createDate(y, m - 1, d);
  return ctor(date.getUTCFullYear())(date.getUTCMonth() + 1)(date.getUTCDate());
}

// output/Control.Bind/foreign.js
var arrayBind = function(arr) {
  return function(f) {
    var result = [];
    for (var i4 = 0, l = arr.length; i4 < l; i4++) {
      Array.prototype.push.apply(result, f(arr[i4]));
    }
    return result;
  };
};

// output/Control.Bind/index.js
var bindArray = {
  bind: arrayBind,
  Apply0: function() {
    return applyArray;
  }
};
var bind = function(dict) {
  return dict.bind;
};

// output/Data.Monoid/index.js
var mempty = function(dict) {
  return dict.mempty;
};
var monoidFn = function(dictMonoid) {
  var mempty1 = mempty(dictMonoid);
  var semigroupFn2 = semigroupFn(dictMonoid.Semigroup0());
  return {
    mempty: function(v) {
      return mempty1;
    },
    Semigroup0: function() {
      return semigroupFn2;
    }
  };
};

// output/Data.Tuple/index.js
var Tuple = /* @__PURE__ */ function() {
  function Tuple2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Tuple2.create = function(value0) {
    return function(value1) {
      return new Tuple2(value0, value1);
    };
  };
  return Tuple2;
}();
var uncurry = function(f) {
  return function(v) {
    return f(v.value0)(v.value1);
  };
};
var snd = function(v) {
  return v.value1;
};
var fst = function(v) {
  return v.value0;
};
var eqTuple = function(dictEq) {
  var eq6 = eq(dictEq);
  return function(dictEq1) {
    var eq14 = eq(dictEq1);
    return {
      eq: function(x) {
        return function(y) {
          return eq6(x.value0)(y.value0) && eq14(x.value1)(y.value1);
        };
      }
    };
  };
};
var ordTuple = function(dictOrd) {
  var compare6 = compare(dictOrd);
  var eqTuple1 = eqTuple(dictOrd.Eq0());
  return function(dictOrd1) {
    var compare13 = compare(dictOrd1);
    var eqTuple2 = eqTuple1(dictOrd1.Eq0());
    return {
      compare: function(x) {
        return function(y) {
          var v = compare6(x.value0)(y.value0);
          if (v instanceof LT) {
            return LT.value;
          }
          ;
          if (v instanceof GT) {
            return GT.value;
          }
          ;
          return compare13(x.value1)(y.value1);
        };
      },
      Eq0: function() {
        return eqTuple2;
      }
    };
  };
};

// output/Data.Unfoldable/foreign.js
var unfoldrArrayImpl = function(isNothing2) {
  return function(fromJust13) {
    return function(fst2) {
      return function(snd2) {
        return function(f) {
          return function(b) {
            var result = [];
            var value = b;
            while (true) {
              var maybe2 = f(value);
              if (isNothing2(maybe2))
                return result;
              var tuple = fromJust13(maybe2);
              result.push(fst2(tuple));
              value = snd2(tuple);
            }
          };
        };
      };
    };
  };
};

// output/Data.Traversable/foreign.js
var traverseArrayImpl = function() {
  function array1(a) {
    return [a];
  }
  function array2(a) {
    return function(b) {
      return [a, b];
    };
  }
  function array3(a) {
    return function(b) {
      return function(c) {
        return [a, b, c];
      };
    };
  }
  function concat2(xs) {
    return function(ys) {
      return xs.concat(ys);
    };
  }
  return function(apply2) {
    return function(map7) {
      return function(pure4) {
        return function(f) {
          return function(array) {
            function go(bot, top3) {
              switch (top3 - bot) {
                case 0:
                  return pure4([]);
                case 1:
                  return map7(array1)(f(array[bot]));
                case 2:
                  return apply2(map7(array2)(f(array[bot])))(f(array[bot + 1]));
                case 3:
                  return apply2(apply2(map7(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                default:
                  var pivot = bot + Math.floor((top3 - bot) / 4) * 2;
                  return apply2(map7(concat2)(go(bot, pivot)))(go(pivot, top3));
              }
            }
            return go(0, array.length);
          };
        };
      };
    };
  };
}();

// output/Data.Foldable/foreign.js
var foldrArray = function(f) {
  return function(init) {
    return function(xs) {
      var acc = init;
      var len = xs.length;
      for (var i4 = len - 1; i4 >= 0; i4--) {
        acc = f(xs[i4])(acc);
      }
      return acc;
    };
  };
};
var foldlArray = function(f) {
  return function(init) {
    return function(xs) {
      var acc = init;
      var len = xs.length;
      for (var i4 = 0; i4 < len; i4++) {
        acc = f(acc)(xs[i4]);
      }
      return acc;
    };
  };
};

// output/Unsafe.Coerce/foreign.js
var unsafeCoerce2 = function(x) {
  return x;
};

// output/Safe.Coerce/index.js
var coerce = function() {
  return unsafeCoerce2;
};

// output/Data.Foldable/index.js
var identity3 = /* @__PURE__ */ identity(categoryFn);
var foldr = function(dict) {
  return dict.foldr;
};
var foldl = function(dict) {
  return dict.foldl;
};
var foldMapDefaultR = function(dictFoldable) {
  var foldr22 = foldr(dictFoldable);
  return function(dictMonoid) {
    var append7 = append(dictMonoid.Semigroup0());
    var mempty3 = mempty(dictMonoid);
    return function(f) {
      return foldr22(function(x) {
        return function(acc) {
          return append7(f(x))(acc);
        };
      })(mempty3);
    };
  };
};
var foldableArray = {
  foldr: foldrArray,
  foldl: foldlArray,
  foldMap: function(dictMonoid) {
    return foldMapDefaultR(foldableArray)(dictMonoid);
  }
};
var foldMap = function(dict) {
  return dict.foldMap;
};
var fold = function(dictFoldable) {
  var foldMap2 = foldMap(dictFoldable);
  return function(dictMonoid) {
    return foldMap2(dictMonoid)(identity3);
  };
};
var find = function(dictFoldable) {
  var foldl22 = foldl(dictFoldable);
  return function(p) {
    var go = function(v) {
      return function(v1) {
        if (v instanceof Nothing && p(v1)) {
          return new Just(v1);
        }
        ;
        return v;
      };
    };
    return foldl22(go)(Nothing.value);
  };
};

// output/Data.Monoid.Additive/index.js
var semigroupAdditive = function(dictSemiring) {
  var add2 = add(dictSemiring);
  return {
    append: function(v) {
      return function(v1) {
        return add2(v)(v1);
      };
    }
  };
};
var ordAdditive = function(dictOrd) {
  return dictOrd;
};
var monoidAdditive = function(dictSemiring) {
  var semigroupAdditive1 = semigroupAdditive(dictSemiring);
  return {
    mempty: zero(dictSemiring),
    Semigroup0: function() {
      return semigroupAdditive1;
    }
  };
};
var eqAdditive = function(dictEq) {
  return dictEq;
};

// output/Data.Unfoldable1/foreign.js
var unfoldr1ArrayImpl = function(isNothing2) {
  return function(fromJust13) {
    return function(fst2) {
      return function(snd2) {
        return function(f) {
          return function(b) {
            var result = [];
            var value = b;
            while (true) {
              var tuple = f(value);
              result.push(fst2(tuple));
              var maybe2 = snd2(tuple);
              if (isNothing2(maybe2))
                return result;
              value = fromJust13(maybe2);
            }
          };
        };
      };
    };
  };
};

// output/Data.Unfoldable1/index.js
var fromJust3 = /* @__PURE__ */ fromJust();
var unfoldable1Array = {
  unfoldr1: /* @__PURE__ */ unfoldr1ArrayImpl(isNothing)(fromJust3)(fst)(snd)
};

// output/Data.Unfoldable/index.js
var fromJust4 = /* @__PURE__ */ fromJust();
var unfoldr = function(dict) {
  return dict.unfoldr;
};
var unfoldableArray = {
  unfoldr: /* @__PURE__ */ unfoldrArrayImpl(isNothing)(fromJust4)(fst)(snd),
  Unfoldable10: function() {
    return unfoldable1Array;
  }
};

// output/Data.Enum/index.js
var toEnum = function(dict) {
  return dict.toEnum;
};
var fromEnum = function(dict) {
  return dict.fromEnum;
};

// output/Data.Date.Component/index.js
var $runtime_lazy = function(name2, moduleName, init) {
  var state = 0;
  var val;
  return function(lineNumber) {
    if (state === 2)
      return val;
    if (state === 1)
      throw new ReferenceError(name2 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
    state = 1;
    val = init();
    state = 2;
    return val;
  };
};
var show2 = /* @__PURE__ */ show(showInt);
var January = /* @__PURE__ */ function() {
  function January2() {
  }
  ;
  January2.value = new January2();
  return January2;
}();
var February = /* @__PURE__ */ function() {
  function February2() {
  }
  ;
  February2.value = new February2();
  return February2;
}();
var March = /* @__PURE__ */ function() {
  function March2() {
  }
  ;
  March2.value = new March2();
  return March2;
}();
var April = /* @__PURE__ */ function() {
  function April2() {
  }
  ;
  April2.value = new April2();
  return April2;
}();
var May = /* @__PURE__ */ function() {
  function May2() {
  }
  ;
  May2.value = new May2();
  return May2;
}();
var June = /* @__PURE__ */ function() {
  function June2() {
  }
  ;
  June2.value = new June2();
  return June2;
}();
var July = /* @__PURE__ */ function() {
  function July2() {
  }
  ;
  July2.value = new July2();
  return July2;
}();
var August = /* @__PURE__ */ function() {
  function August2() {
  }
  ;
  August2.value = new August2();
  return August2;
}();
var September = /* @__PURE__ */ function() {
  function September2() {
  }
  ;
  September2.value = new September2();
  return September2;
}();
var October = /* @__PURE__ */ function() {
  function October2() {
  }
  ;
  October2.value = new October2();
  return October2;
}();
var November = /* @__PURE__ */ function() {
  function November2() {
  }
  ;
  November2.value = new November2();
  return November2;
}();
var December = /* @__PURE__ */ function() {
  function December2() {
  }
  ;
  December2.value = new December2();
  return December2;
}();
var showYear = {
  show: function(v) {
    return "(Year " + (show2(v) + ")");
  }
};
var ordYear = ordInt;
var ordDay = ordInt;
var eqYear = eqInt;
var eqMonth = {
  eq: function(x) {
    return function(y) {
      if (x instanceof January && y instanceof January) {
        return true;
      }
      ;
      if (x instanceof February && y instanceof February) {
        return true;
      }
      ;
      if (x instanceof March && y instanceof March) {
        return true;
      }
      ;
      if (x instanceof April && y instanceof April) {
        return true;
      }
      ;
      if (x instanceof May && y instanceof May) {
        return true;
      }
      ;
      if (x instanceof June && y instanceof June) {
        return true;
      }
      ;
      if (x instanceof July && y instanceof July) {
        return true;
      }
      ;
      if (x instanceof August && y instanceof August) {
        return true;
      }
      ;
      if (x instanceof September && y instanceof September) {
        return true;
      }
      ;
      if (x instanceof October && y instanceof October) {
        return true;
      }
      ;
      if (x instanceof November && y instanceof November) {
        return true;
      }
      ;
      if (x instanceof December && y instanceof December) {
        return true;
      }
      ;
      return false;
    };
  }
};
var ordMonth = {
  compare: function(x) {
    return function(y) {
      if (x instanceof January && y instanceof January) {
        return EQ.value;
      }
      ;
      if (x instanceof January) {
        return LT.value;
      }
      ;
      if (y instanceof January) {
        return GT.value;
      }
      ;
      if (x instanceof February && y instanceof February) {
        return EQ.value;
      }
      ;
      if (x instanceof February) {
        return LT.value;
      }
      ;
      if (y instanceof February) {
        return GT.value;
      }
      ;
      if (x instanceof March && y instanceof March) {
        return EQ.value;
      }
      ;
      if (x instanceof March) {
        return LT.value;
      }
      ;
      if (y instanceof March) {
        return GT.value;
      }
      ;
      if (x instanceof April && y instanceof April) {
        return EQ.value;
      }
      ;
      if (x instanceof April) {
        return LT.value;
      }
      ;
      if (y instanceof April) {
        return GT.value;
      }
      ;
      if (x instanceof May && y instanceof May) {
        return EQ.value;
      }
      ;
      if (x instanceof May) {
        return LT.value;
      }
      ;
      if (y instanceof May) {
        return GT.value;
      }
      ;
      if (x instanceof June && y instanceof June) {
        return EQ.value;
      }
      ;
      if (x instanceof June) {
        return LT.value;
      }
      ;
      if (y instanceof June) {
        return GT.value;
      }
      ;
      if (x instanceof July && y instanceof July) {
        return EQ.value;
      }
      ;
      if (x instanceof July) {
        return LT.value;
      }
      ;
      if (y instanceof July) {
        return GT.value;
      }
      ;
      if (x instanceof August && y instanceof August) {
        return EQ.value;
      }
      ;
      if (x instanceof August) {
        return LT.value;
      }
      ;
      if (y instanceof August) {
        return GT.value;
      }
      ;
      if (x instanceof September && y instanceof September) {
        return EQ.value;
      }
      ;
      if (x instanceof September) {
        return LT.value;
      }
      ;
      if (y instanceof September) {
        return GT.value;
      }
      ;
      if (x instanceof October && y instanceof October) {
        return EQ.value;
      }
      ;
      if (x instanceof October) {
        return LT.value;
      }
      ;
      if (y instanceof October) {
        return GT.value;
      }
      ;
      if (x instanceof November && y instanceof November) {
        return EQ.value;
      }
      ;
      if (x instanceof November) {
        return LT.value;
      }
      ;
      if (y instanceof November) {
        return GT.value;
      }
      ;
      if (x instanceof December && y instanceof December) {
        return EQ.value;
      }
      ;
      throw new Error("Failed pattern match at Data.Date.Component (line 0, column 0 - line 0, column 0): " + [x.constructor.name, y.constructor.name]);
    };
  },
  Eq0: function() {
    return eqMonth;
  }
};
var eqDay = eqInt;
var boundedYear = /* @__PURE__ */ function() {
  return {
    bottom: -271820 | 0,
    top: 275759,
    Ord0: function() {
      return ordYear;
    }
  };
}();
var boundedMonth = /* @__PURE__ */ function() {
  return {
    bottom: January.value,
    top: December.value,
    Ord0: function() {
      return ordMonth;
    }
  };
}();
var boundedEnumYear = {
  cardinality: 547580,
  toEnum: function(n) {
    if (n >= (-271820 | 0) && n <= 275759) {
      return new Just(n);
    }
    ;
    if (otherwise) {
      return Nothing.value;
    }
    ;
    throw new Error("Failed pattern match at Data.Date.Component (line 35, column 1 - line 40, column 24): " + [n.constructor.name]);
  },
  fromEnum: function(v) {
    return v;
  },
  Bounded0: function() {
    return boundedYear;
  },
  Enum1: function() {
    return $lazy_enumYear(0);
  }
};
var $lazy_enumYear = /* @__PURE__ */ $runtime_lazy("enumYear", "Data.Date.Component", function() {
  return {
    succ: function() {
      var $55 = toEnum(boundedEnumYear);
      var $56 = fromEnum(boundedEnumYear);
      return function($57) {
        return $55(function(v) {
          return v + 1 | 0;
        }($56($57)));
      };
    }(),
    pred: function() {
      var $58 = toEnum(boundedEnumYear);
      var $59 = fromEnum(boundedEnumYear);
      return function($60) {
        return $58(function(v) {
          return v - 1 | 0;
        }($59($60)));
      };
    }(),
    Ord0: function() {
      return ordYear;
    }
  };
});
var boundedEnumMonth = {
  cardinality: 12,
  toEnum: function(v) {
    if (v === 1) {
      return new Just(January.value);
    }
    ;
    if (v === 2) {
      return new Just(February.value);
    }
    ;
    if (v === 3) {
      return new Just(March.value);
    }
    ;
    if (v === 4) {
      return new Just(April.value);
    }
    ;
    if (v === 5) {
      return new Just(May.value);
    }
    ;
    if (v === 6) {
      return new Just(June.value);
    }
    ;
    if (v === 7) {
      return new Just(July.value);
    }
    ;
    if (v === 8) {
      return new Just(August.value);
    }
    ;
    if (v === 9) {
      return new Just(September.value);
    }
    ;
    if (v === 10) {
      return new Just(October.value);
    }
    ;
    if (v === 11) {
      return new Just(November.value);
    }
    ;
    if (v === 12) {
      return new Just(December.value);
    }
    ;
    return Nothing.value;
  },
  fromEnum: function(v) {
    if (v instanceof January) {
      return 1;
    }
    ;
    if (v instanceof February) {
      return 2;
    }
    ;
    if (v instanceof March) {
      return 3;
    }
    ;
    if (v instanceof April) {
      return 4;
    }
    ;
    if (v instanceof May) {
      return 5;
    }
    ;
    if (v instanceof June) {
      return 6;
    }
    ;
    if (v instanceof July) {
      return 7;
    }
    ;
    if (v instanceof August) {
      return 8;
    }
    ;
    if (v instanceof September) {
      return 9;
    }
    ;
    if (v instanceof October) {
      return 10;
    }
    ;
    if (v instanceof November) {
      return 11;
    }
    ;
    if (v instanceof December) {
      return 12;
    }
    ;
    throw new Error("Failed pattern match at Data.Date.Component (line 87, column 14 - line 99, column 19): " + [v.constructor.name]);
  },
  Bounded0: function() {
    return boundedMonth;
  },
  Enum1: function() {
    return $lazy_enumMonth(0);
  }
};
var $lazy_enumMonth = /* @__PURE__ */ $runtime_lazy("enumMonth", "Data.Date.Component", function() {
  return {
    succ: function() {
      var $67 = toEnum(boundedEnumMonth);
      var $68 = fromEnum(boundedEnumMonth);
      return function($69) {
        return $67(function(v) {
          return v + 1 | 0;
        }($68($69)));
      };
    }(),
    pred: function() {
      var $70 = toEnum(boundedEnumMonth);
      var $71 = fromEnum(boundedEnumMonth);
      return function($72) {
        return $70(function(v) {
          return v - 1 | 0;
        }($71($72)));
      };
    }(),
    Ord0: function() {
      return ordMonth;
    }
  };
});
var boundedDay = {
  bottom: 1,
  top: 31,
  Ord0: function() {
    return ordDay;
  }
};
var boundedEnumDay = {
  cardinality: 31,
  toEnum: function(n) {
    if (n >= 1 && n <= 31) {
      return new Just(n);
    }
    ;
    if (otherwise) {
      return Nothing.value;
    }
    ;
    throw new Error("Failed pattern match at Data.Date.Component (line 133, column 1 - line 138, column 23): " + [n.constructor.name]);
  },
  fromEnum: function(v) {
    return v;
  },
  Bounded0: function() {
    return boundedDay;
  },
  Enum1: function() {
    return $lazy_enumDay(0);
  }
};
var $lazy_enumDay = /* @__PURE__ */ $runtime_lazy("enumDay", "Data.Date.Component", function() {
  return {
    succ: function() {
      var $73 = toEnum(boundedEnumDay);
      var $74 = fromEnum(boundedEnumDay);
      return function($75) {
        return $73(function(v) {
          return v + 1 | 0;
        }($74($75)));
      };
    }(),
    pred: function() {
      var $76 = toEnum(boundedEnumDay);
      var $77 = fromEnum(boundedEnumDay);
      return function($78) {
        return $76(function(v) {
          return v - 1 | 0;
        }($77($78)));
      };
    }(),
    Ord0: function() {
      return ordDay;
    }
  };
});

// output/Data.Int/foreign.js
var fromNumberImpl = function(just) {
  return function(nothing) {
    return function(n) {
      return (n | 0) === n ? just(n) : nothing;
    };
  };
};
var toNumber = function(n) {
  return n;
};

// output/Data.Number/foreign.js
var isFiniteImpl = isFinite;
var abs = Math.abs;
var round = Math.round;

// output/Data.Int/index.js
var top2 = /* @__PURE__ */ top(boundedInt);
var bottom2 = /* @__PURE__ */ bottom(boundedInt);
var fromNumber = /* @__PURE__ */ function() {
  return fromNumberImpl(Just.create)(Nothing.value);
}();
var unsafeClamp = function(x) {
  if (!isFiniteImpl(x)) {
    return 0;
  }
  ;
  if (x >= toNumber(top2)) {
    return top2;
  }
  ;
  if (x <= toNumber(bottom2)) {
    return bottom2;
  }
  ;
  if (otherwise) {
    return fromMaybe(0)(fromNumber(x));
  }
  ;
  throw new Error("Failed pattern match at Data.Int (line 72, column 1 - line 72, column 29): " + [x.constructor.name]);
};
var round2 = function($37) {
  return unsafeClamp(round($37));
};

// output/Data.Date/index.js
var fromEnum2 = /* @__PURE__ */ fromEnum(boundedEnumMonth);
var fromJust5 = /* @__PURE__ */ fromJust();
var eq12 = /* @__PURE__ */ eq(eqYear);
var eq2 = /* @__PURE__ */ eq(eqMonth);
var eq3 = /* @__PURE__ */ eq(eqDay);
var compare3 = /* @__PURE__ */ compare(ordYear);
var compare12 = /* @__PURE__ */ compare(ordMonth);
var compare22 = /* @__PURE__ */ compare(ordDay);
var toEnum2 = /* @__PURE__ */ toEnum(boundedEnumMonth);
var $$Date = /* @__PURE__ */ function() {
  function $$Date2(value0, value1, value2) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
  }
  ;
  $$Date2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return new $$Date2(value0, value1, value2);
      };
    };
  };
  return $$Date2;
}();
var eqDate = {
  eq: function(x) {
    return function(y) {
      return eq12(x.value0)(y.value0) && eq2(x.value1)(y.value1) && eq3(x.value2)(y.value2);
    };
  }
};
var ordDate = {
  compare: function(x) {
    return function(y) {
      var v = compare3(x.value0)(y.value0);
      if (v instanceof LT) {
        return LT.value;
      }
      ;
      if (v instanceof GT) {
        return GT.value;
      }
      ;
      var v1 = compare12(x.value1)(y.value1);
      if (v1 instanceof LT) {
        return LT.value;
      }
      ;
      if (v1 instanceof GT) {
        return GT.value;
      }
      ;
      return compare22(x.value2)(y.value2);
    };
  },
  Eq0: function() {
    return eqDate;
  }
};
var canonicalDate = function(y) {
  return function(m) {
    return function(d) {
      var mkDate = function(y$prime) {
        return function(m$prime) {
          return function(d$prime) {
            return new $$Date(y$prime, fromJust5(toEnum2(m$prime)), d$prime);
          };
        };
      };
      return canonicalDateImpl(mkDate, y, fromEnum2(m), d);
    };
  };
};

// output/Age/index.js
var fromEnum3 = /* @__PURE__ */ fromEnum(boundedEnumYear);
var fromJust6 = /* @__PURE__ */ fromJust();
var toEnum3 = /* @__PURE__ */ toEnum(boundedEnumYear);
var bottom3 = /* @__PURE__ */ bottom(boundedMonth);
var bottom1 = /* @__PURE__ */ bottom(boundedDay);
var lessThanOrEq2 = /* @__PURE__ */ lessThanOrEq(ordDate);
var isAge65OrOlder = function(bd) {
  return function(y) {
    var nextYear = fromEnum3(y) + 1 | 0;
    var nextYearMinus65 = fromJust6(toEnum3(nextYear - 65 | 0));
    var firstDayOfYear65DaysPrior = canonicalDate(nextYearMinus65)(bottom3)(bottom1);
    return lessThanOrEq2(bd)(firstDayOfYear65DaysPrior);
  };
};

// output/Data.FoldableWithIndex/index.js
var foldrWithIndex = function(dict) {
  return dict.foldrWithIndex;
};
var foldlWithIndex = function(dict) {
  return dict.foldlWithIndex;
};
var foldMapWithIndex = function(dict) {
  return dict.foldMapWithIndex;
};

// output/Data.List.Types/index.js
var Nil = /* @__PURE__ */ function() {
  function Nil3() {
  }
  ;
  Nil3.value = new Nil3();
  return Nil3;
}();
var Cons = /* @__PURE__ */ function() {
  function Cons3(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Cons3.create = function(value0) {
    return function(value1) {
      return new Cons3(value0, value1);
    };
  };
  return Cons3;
}();
var listMap = function(f) {
  var chunkedRevMap = function($copy_chunksAcc) {
    return function($copy_v) {
      var $tco_var_chunksAcc = $copy_chunksAcc;
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(chunksAcc, v) {
        if (v instanceof Cons && (v.value1 instanceof Cons && v.value1.value1 instanceof Cons)) {
          $tco_var_chunksAcc = new Cons(v, chunksAcc);
          $copy_v = v.value1.value1.value1;
          return;
        }
        ;
        var unrolledMap = function(v1) {
          if (v1 instanceof Cons && (v1.value1 instanceof Cons && v1.value1.value1 instanceof Nil)) {
            return new Cons(f(v1.value0), new Cons(f(v1.value1.value0), Nil.value));
          }
          ;
          if (v1 instanceof Cons && v1.value1 instanceof Nil) {
            return new Cons(f(v1.value0), Nil.value);
          }
          ;
          return Nil.value;
        };
        var reverseUnrolledMap = function($copy_v1) {
          return function($copy_acc) {
            var $tco_var_v1 = $copy_v1;
            var $tco_done1 = false;
            var $tco_result2;
            function $tco_loop2(v1, acc) {
              if (v1 instanceof Cons && (v1.value0 instanceof Cons && (v1.value0.value1 instanceof Cons && v1.value0.value1.value1 instanceof Cons))) {
                $tco_var_v1 = v1.value1;
                $copy_acc = new Cons(f(v1.value0.value0), new Cons(f(v1.value0.value1.value0), new Cons(f(v1.value0.value1.value1.value0), acc)));
                return;
              }
              ;
              $tco_done1 = true;
              return acc;
            }
            ;
            while (!$tco_done1) {
              $tco_result2 = $tco_loop2($tco_var_v1, $copy_acc);
            }
            ;
            return $tco_result2;
          };
        };
        $tco_done = true;
        return reverseUnrolledMap(chunksAcc)(unrolledMap(v));
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($tco_var_chunksAcc, $copy_v);
      }
      ;
      return $tco_result;
    };
  };
  return chunkedRevMap(Nil.value);
};
var functorList = {
  map: listMap
};
var map3 = /* @__PURE__ */ map(functorList);
var foldableList = {
  foldr: function(f) {
    return function(b) {
      var rev = function() {
        var go = function($copy_acc) {
          return function($copy_v) {
            var $tco_var_acc = $copy_acc;
            var $tco_done = false;
            var $tco_result;
            function $tco_loop(acc, v) {
              if (v instanceof Nil) {
                $tco_done = true;
                return acc;
              }
              ;
              if (v instanceof Cons) {
                $tco_var_acc = new Cons(v.value0, acc);
                $copy_v = v.value1;
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.List.Types (line 107, column 7 - line 107, column 23): " + [acc.constructor.name, v.constructor.name]);
            }
            ;
            while (!$tco_done) {
              $tco_result = $tco_loop($tco_var_acc, $copy_v);
            }
            ;
            return $tco_result;
          };
        };
        return go(Nil.value);
      }();
      var $281 = foldl(foldableList)(flip(f))(b);
      return function($282) {
        return $281(rev($282));
      };
    };
  },
  foldl: function(f) {
    var go = function($copy_b) {
      return function($copy_v) {
        var $tco_var_b = $copy_b;
        var $tco_done1 = false;
        var $tco_result;
        function $tco_loop(b, v) {
          if (v instanceof Nil) {
            $tco_done1 = true;
            return b;
          }
          ;
          if (v instanceof Cons) {
            $tco_var_b = f(b)(v.value0);
            $copy_v = v.value1;
            return;
          }
          ;
          throw new Error("Failed pattern match at Data.List.Types (line 111, column 12 - line 113, column 30): " + [v.constructor.name]);
        }
        ;
        while (!$tco_done1) {
          $tco_result = $tco_loop($tco_var_b, $copy_v);
        }
        ;
        return $tco_result;
      };
    };
    return go;
  },
  foldMap: function(dictMonoid) {
    var append22 = append(dictMonoid.Semigroup0());
    var mempty3 = mempty(dictMonoid);
    return function(f) {
      return foldl(foldableList)(function(acc) {
        var $283 = append22(acc);
        return function($284) {
          return $283(f($284));
        };
      })(mempty3);
    };
  }
};
var foldl2 = /* @__PURE__ */ foldl(foldableList);
var foldr2 = /* @__PURE__ */ foldr(foldableList);
var semigroupList = {
  append: function(xs) {
    return function(ys) {
      return foldr2(Cons.create)(ys)(xs);
    };
  }
};
var append1 = /* @__PURE__ */ append(semigroupList);
var unfoldable1List = {
  unfoldr1: function(f) {
    return function(b) {
      var go = function($copy_source) {
        return function($copy_memo) {
          var $tco_var_source = $copy_source;
          var $tco_done = false;
          var $tco_result;
          function $tco_loop(source, memo) {
            var v = f(source);
            if (v.value1 instanceof Just) {
              $tco_var_source = v.value1.value0;
              $copy_memo = new Cons(v.value0, memo);
              return;
            }
            ;
            if (v.value1 instanceof Nothing) {
              $tco_done = true;
              return foldl2(flip(Cons.create))(Nil.value)(new Cons(v.value0, memo));
            }
            ;
            throw new Error("Failed pattern match at Data.List.Types (line 135, column 22 - line 137, column 61): " + [v.constructor.name]);
          }
          ;
          while (!$tco_done) {
            $tco_result = $tco_loop($tco_var_source, $copy_memo);
          }
          ;
          return $tco_result;
        };
      };
      return go(b)(Nil.value);
    };
  }
};
var unfoldableList = {
  unfoldr: function(f) {
    return function(b) {
      var go = function($copy_source) {
        return function($copy_memo) {
          var $tco_var_source = $copy_source;
          var $tco_done = false;
          var $tco_result;
          function $tco_loop(source, memo) {
            var v = f(source);
            if (v instanceof Nothing) {
              $tco_done = true;
              return foldl2(flip(Cons.create))(Nil.value)(memo);
            }
            ;
            if (v instanceof Just) {
              $tco_var_source = v.value0.value1;
              $copy_memo = new Cons(v.value0.value0, memo);
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.List.Types (line 142, column 22 - line 144, column 52): " + [v.constructor.name]);
          }
          ;
          while (!$tco_done) {
            $tco_result = $tco_loop($tco_var_source, $copy_memo);
          }
          ;
          return $tco_result;
        };
      };
      return go(b)(Nil.value);
    };
  },
  Unfoldable10: function() {
    return unfoldable1List;
  }
};
var applyList = {
  apply: function(v) {
    return function(v1) {
      if (v instanceof Nil) {
        return Nil.value;
      }
      ;
      if (v instanceof Cons) {
        return append1(map3(v.value0)(v1))(apply(applyList)(v.value1)(v1));
      }
      ;
      throw new Error("Failed pattern match at Data.List.Types (line 157, column 1 - line 159, column 48): " + [v.constructor.name, v1.constructor.name]);
    };
  },
  Functor0: function() {
    return functorList;
  }
};
var bindList = {
  bind: function(v) {
    return function(v1) {
      if (v instanceof Nil) {
        return Nil.value;
      }
      ;
      if (v instanceof Cons) {
        return append1(v1(v.value0))(bind(bindList)(v.value1)(v1));
      }
      ;
      throw new Error("Failed pattern match at Data.List.Types (line 164, column 1 - line 166, column 37): " + [v.constructor.name, v1.constructor.name]);
    };
  },
  Apply0: function() {
    return applyList;
  }
};
var applicativeList = {
  pure: function(a) {
    return new Cons(a, Nil.value);
  },
  Apply0: function() {
    return applyList;
  }
};

// output/Data.List/index.js
var map4 = /* @__PURE__ */ map(functorMaybe);
var foldl3 = /* @__PURE__ */ foldl(foldableList);
var uncons = function(v) {
  if (v instanceof Nil) {
    return Nothing.value;
  }
  ;
  if (v instanceof Cons) {
    return new Just({
      head: v.value0,
      tail: v.value1
    });
  }
  ;
  throw new Error("Failed pattern match at Data.List (line 259, column 1 - line 259, column 66): " + [v.constructor.name]);
};
var toUnfoldable = function(dictUnfoldable) {
  return unfoldr(dictUnfoldable)(function(xs) {
    return map4(function(rec) {
      return new Tuple(rec.head, rec.tail);
    })(uncons(xs));
  });
};
var tail = function(v) {
  if (v instanceof Nil) {
    return Nothing.value;
  }
  ;
  if (v instanceof Cons) {
    return new Just(v.value1);
  }
  ;
  throw new Error("Failed pattern match at Data.List (line 245, column 1 - line 245, column 43): " + [v.constructor.name]);
};
var singleton4 = function(a) {
  return new Cons(a, Nil.value);
};
var reverse = /* @__PURE__ */ function() {
  var go = function($copy_acc) {
    return function($copy_v) {
      var $tco_var_acc = $copy_acc;
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(acc, v) {
        if (v instanceof Nil) {
          $tco_done = true;
          return acc;
        }
        ;
        if (v instanceof Cons) {
          $tco_var_acc = new Cons(v.value0, acc);
          $copy_v = v.value1;
          return;
        }
        ;
        throw new Error("Failed pattern match at Data.List (line 368, column 3 - line 368, column 19): " + [acc.constructor.name, v.constructor.name]);
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($tco_var_acc, $copy_v);
      }
      ;
      return $tco_result;
    };
  };
  return go(Nil.value);
}();
var zipWith = function(f) {
  return function(xs) {
    return function(ys) {
      var go = function($copy_v) {
        return function($copy_v1) {
          return function($copy_acc) {
            var $tco_var_v = $copy_v;
            var $tco_var_v1 = $copy_v1;
            var $tco_done = false;
            var $tco_result;
            function $tco_loop(v, v1, acc) {
              if (v instanceof Nil) {
                $tco_done = true;
                return acc;
              }
              ;
              if (v1 instanceof Nil) {
                $tco_done = true;
                return acc;
              }
              ;
              if (v instanceof Cons && v1 instanceof Cons) {
                $tco_var_v = v.value1;
                $tco_var_v1 = v1.value1;
                $copy_acc = new Cons(f(v.value0)(v1.value0), acc);
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.List (line 779, column 3 - line 779, column 21): " + [v.constructor.name, v1.constructor.name, acc.constructor.name]);
            }
            ;
            while (!$tco_done) {
              $tco_result = $tco_loop($tco_var_v, $tco_var_v1, $copy_acc);
            }
            ;
            return $tco_result;
          };
        };
      };
      return reverse(go(xs)(ys)(Nil.value));
    };
  };
};
var zip = /* @__PURE__ */ function() {
  return zipWith(Tuple.create);
}();
var range2 = function(start) {
  return function(end) {
    if (start === end) {
      return singleton4(start);
    }
    ;
    if (otherwise) {
      var go = function($copy_s) {
        return function($copy_e) {
          return function($copy_step) {
            return function($copy_rest) {
              var $tco_var_s = $copy_s;
              var $tco_var_e = $copy_e;
              var $tco_var_step = $copy_step;
              var $tco_done = false;
              var $tco_result;
              function $tco_loop(s, e, step2, rest) {
                if (s === e) {
                  $tco_done = true;
                  return new Cons(s, rest);
                }
                ;
                if (otherwise) {
                  $tco_var_s = s + step2 | 0;
                  $tco_var_e = e;
                  $tco_var_step = step2;
                  $copy_rest = new Cons(s, rest);
                  return;
                }
                ;
                throw new Error("Failed pattern match at Data.List (line 148, column 3 - line 149, column 65): " + [s.constructor.name, e.constructor.name, step2.constructor.name, rest.constructor.name]);
              }
              ;
              while (!$tco_done) {
                $tco_result = $tco_loop($tco_var_s, $tco_var_e, $tco_var_step, $copy_rest);
              }
              ;
              return $tco_result;
            };
          };
        };
      };
      return go(end)(start)(function() {
        var $312 = start > end;
        if ($312) {
          return 1;
        }
        ;
        return -1 | 0;
      }())(Nil.value);
    }
    ;
    throw new Error("Failed pattern match at Data.List (line 144, column 1 - line 144, column 32): " + [start.constructor.name, end.constructor.name]);
  };
};
var length2 = /* @__PURE__ */ foldl3(function(acc) {
  return function(v) {
    return acc + 1 | 0;
  };
})(0);
var index = function($copy_v) {
  return function($copy_v1) {
    var $tco_var_v = $copy_v;
    var $tco_done = false;
    var $tco_result;
    function $tco_loop(v, v1) {
      if (v instanceof Nil) {
        $tco_done = true;
        return Nothing.value;
      }
      ;
      if (v instanceof Cons && v1 === 0) {
        $tco_done = true;
        return new Just(v.value0);
      }
      ;
      if (v instanceof Cons) {
        $tco_var_v = v.value1;
        $copy_v1 = v1 - 1 | 0;
        return;
      }
      ;
      throw new Error("Failed pattern match at Data.List (line 281, column 1 - line 281, column 44): " + [v.constructor.name, v1.constructor.name]);
    }
    ;
    while (!$tco_done) {
      $tco_result = $tco_loop($tco_var_v, $copy_v1);
    }
    ;
    return $tco_result;
  };
};

// output/Effect.Exception/foreign.js
function error(msg) {
  return new Error(msg);
}
function throwException(e) {
  return function() {
    throw e;
  };
}

// output/Effect.Unsafe/foreign.js
var unsafePerformEffect = function(f) {
  return f();
};

// output/Effect.Exception.Unsafe/index.js
var unsafeThrowException = function($1) {
  return unsafePerformEffect(throwException($1));
};
var unsafeThrow = function($2) {
  return unsafeThrowException(error($2));
};

// output/Data.Array/foreign.js
var replicateFill = function(count) {
  return function(value) {
    if (count < 1) {
      return [];
    }
    var result = new Array(count);
    return result.fill(value);
  };
};
var replicatePolyfill = function(count) {
  return function(value) {
    var result = [];
    var n = 0;
    for (var i4 = 0; i4 < count; i4++) {
      result[n++] = value;
    }
    return result;
  };
};
var replicate = typeof Array.prototype.fill === "function" ? replicateFill : replicatePolyfill;
var fromFoldableImpl = function() {
  function Cons3(head2, tail2) {
    this.head = head2;
    this.tail = tail2;
  }
  var emptyList = {};
  function curryCons(head2) {
    return function(tail2) {
      return new Cons3(head2, tail2);
    };
  }
  function listToArray(list) {
    var result = [];
    var count = 0;
    var xs = list;
    while (xs !== emptyList) {
      result[count++] = xs.head;
      xs = xs.tail;
    }
    return result;
  }
  return function(foldr3) {
    return function(xs) {
      return listToArray(foldr3(curryCons)(emptyList)(xs));
    };
  };
}();
var length3 = function(xs) {
  return xs.length;
};
var indexImpl = function(just) {
  return function(nothing) {
    return function(xs) {
      return function(i4) {
        return i4 < 0 || i4 >= xs.length ? nothing : just(xs[i4]);
      };
    };
  };
};
var filter = function(f) {
  return function(xs) {
    return xs.filter(f);
  };
};
var sortByImpl = function() {
  function mergeFromTo(compare6, fromOrdering, xs1, xs2, from, to) {
    var mid;
    var i4;
    var j;
    var k;
    var x;
    var y;
    var c;
    mid = from + (to - from >> 1);
    if (mid - from > 1)
      mergeFromTo(compare6, fromOrdering, xs2, xs1, from, mid);
    if (to - mid > 1)
      mergeFromTo(compare6, fromOrdering, xs2, xs1, mid, to);
    i4 = from;
    j = mid;
    k = from;
    while (i4 < mid && j < to) {
      x = xs2[i4];
      y = xs2[j];
      c = fromOrdering(compare6(x)(y));
      if (c > 0) {
        xs1[k++] = y;
        ++j;
      } else {
        xs1[k++] = x;
        ++i4;
      }
    }
    while (i4 < mid) {
      xs1[k++] = xs2[i4++];
    }
    while (j < to) {
      xs1[k++] = xs2[j++];
    }
  }
  return function(compare6) {
    return function(fromOrdering) {
      return function(xs) {
        var out;
        if (xs.length < 2)
          return xs;
        out = xs.slice(0);
        mergeFromTo(compare6, fromOrdering, out, xs.slice(0), 0, xs.length);
        return out;
      };
    };
  };
}();

// output/Data.Array.ST/foreign.js
var sortByImpl2 = function() {
  function mergeFromTo(compare6, fromOrdering, xs1, xs2, from, to) {
    var mid;
    var i4;
    var j;
    var k;
    var x;
    var y;
    var c;
    mid = from + (to - from >> 1);
    if (mid - from > 1)
      mergeFromTo(compare6, fromOrdering, xs2, xs1, from, mid);
    if (to - mid > 1)
      mergeFromTo(compare6, fromOrdering, xs2, xs1, mid, to);
    i4 = from;
    j = mid;
    k = from;
    while (i4 < mid && j < to) {
      x = xs2[i4];
      y = xs2[j];
      c = fromOrdering(compare6(x)(y));
      if (c > 0) {
        xs1[k++] = y;
        ++j;
      } else {
        xs1[k++] = x;
        ++i4;
      }
    }
    while (i4 < mid) {
      xs1[k++] = xs2[i4++];
    }
    while (j < to) {
      xs1[k++] = xs2[j++];
    }
  }
  return function(compare6) {
    return function(fromOrdering) {
      return function(xs) {
        return function() {
          if (xs.length < 2)
            return xs;
          mergeFromTo(compare6, fromOrdering, xs, xs.slice(0), 0, xs.length);
          return xs;
        };
      };
    };
  };
}();

// output/Data.Array/index.js
var fold1 = /* @__PURE__ */ fold(foldableArray);
var sortBy = function(comp) {
  return sortByImpl(comp)(function(v) {
    if (v instanceof GT) {
      return 1;
    }
    ;
    if (v instanceof EQ) {
      return 0;
    }
    ;
    if (v instanceof LT) {
      return -1 | 0;
    }
    ;
    throw new Error("Failed pattern match at Data.Array (line 829, column 31 - line 832, column 11): " + [v.constructor.name]);
  });
};
var index2 = /* @__PURE__ */ function() {
  return indexImpl(Just.create)(Nothing.value);
}();
var last = function(xs) {
  return index2(xs)(length3(xs) - 1 | 0);
};
var fromFoldable = function(dictFoldable) {
  return fromFoldableImpl(foldr(dictFoldable));
};
var fold2 = function(dictMonoid) {
  return fold1(dictMonoid);
};

// output/Data.Map.Internal/index.js
var Leaf = /* @__PURE__ */ function() {
  function Leaf2() {
  }
  ;
  Leaf2.value = new Leaf2();
  return Leaf2;
}();
var Two = /* @__PURE__ */ function() {
  function Two2(value0, value1, value2, value3) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
  }
  ;
  Two2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return function(value3) {
          return new Two2(value0, value1, value2, value3);
        };
      };
    };
  };
  return Two2;
}();
var Three = /* @__PURE__ */ function() {
  function Three2(value0, value1, value2, value3, value4, value5, value6) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
    this.value4 = value4;
    this.value5 = value5;
    this.value6 = value6;
  }
  ;
  Three2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return function(value3) {
          return function(value4) {
            return function(value5) {
              return function(value6) {
                return new Three2(value0, value1, value2, value3, value4, value5, value6);
              };
            };
          };
        };
      };
    };
  };
  return Three2;
}();
var TwoLeft = /* @__PURE__ */ function() {
  function TwoLeft2(value0, value1, value2) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
  }
  ;
  TwoLeft2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return new TwoLeft2(value0, value1, value2);
      };
    };
  };
  return TwoLeft2;
}();
var TwoRight = /* @__PURE__ */ function() {
  function TwoRight2(value0, value1, value2) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
  }
  ;
  TwoRight2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return new TwoRight2(value0, value1, value2);
      };
    };
  };
  return TwoRight2;
}();
var ThreeLeft = /* @__PURE__ */ function() {
  function ThreeLeft2(value0, value1, value2, value3, value4, value5) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
    this.value4 = value4;
    this.value5 = value5;
  }
  ;
  ThreeLeft2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return function(value3) {
          return function(value4) {
            return function(value5) {
              return new ThreeLeft2(value0, value1, value2, value3, value4, value5);
            };
          };
        };
      };
    };
  };
  return ThreeLeft2;
}();
var ThreeMiddle = /* @__PURE__ */ function() {
  function ThreeMiddle2(value0, value1, value2, value3, value4, value5) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
    this.value4 = value4;
    this.value5 = value5;
  }
  ;
  ThreeMiddle2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return function(value3) {
          return function(value4) {
            return function(value5) {
              return new ThreeMiddle2(value0, value1, value2, value3, value4, value5);
            };
          };
        };
      };
    };
  };
  return ThreeMiddle2;
}();
var ThreeRight = /* @__PURE__ */ function() {
  function ThreeRight2(value0, value1, value2, value3, value4, value5) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
    this.value4 = value4;
    this.value5 = value5;
  }
  ;
  ThreeRight2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return function(value3) {
          return function(value4) {
            return function(value5) {
              return new ThreeRight2(value0, value1, value2, value3, value4, value5);
            };
          };
        };
      };
    };
  };
  return ThreeRight2;
}();
var KickUp = /* @__PURE__ */ function() {
  function KickUp2(value0, value1, value2, value3) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
  }
  ;
  KickUp2.create = function(value0) {
    return function(value1) {
      return function(value2) {
        return function(value3) {
          return new KickUp2(value0, value1, value2, value3);
        };
      };
    };
  };
  return KickUp2;
}();
var singleton5 = function(k) {
  return function(v) {
    return new Two(Leaf.value, k, v, Leaf.value);
  };
};
var toUnfoldable2 = function(dictUnfoldable) {
  var unfoldr2 = unfoldr(dictUnfoldable);
  return function(m) {
    var go = function($copy_v) {
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(v) {
        if (v instanceof Nil) {
          $tco_done = true;
          return Nothing.value;
        }
        ;
        if (v instanceof Cons) {
          if (v.value0 instanceof Leaf) {
            $copy_v = v.value1;
            return;
          }
          ;
          if (v.value0 instanceof Two && (v.value0.value0 instanceof Leaf && v.value0.value3 instanceof Leaf)) {
            $tco_done = true;
            return new Just(new Tuple(new Tuple(v.value0.value1, v.value0.value2), v.value1));
          }
          ;
          if (v.value0 instanceof Two && v.value0.value0 instanceof Leaf) {
            $tco_done = true;
            return new Just(new Tuple(new Tuple(v.value0.value1, v.value0.value2), new Cons(v.value0.value3, v.value1)));
          }
          ;
          if (v.value0 instanceof Two) {
            $copy_v = new Cons(v.value0.value0, new Cons(singleton5(v.value0.value1)(v.value0.value2), new Cons(v.value0.value3, v.value1)));
            return;
          }
          ;
          if (v.value0 instanceof Three) {
            $copy_v = new Cons(v.value0.value0, new Cons(singleton5(v.value0.value1)(v.value0.value2), new Cons(v.value0.value3, new Cons(singleton5(v.value0.value4)(v.value0.value5), new Cons(v.value0.value6, v.value1)))));
            return;
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 624, column 18 - line 633, column 71): " + [v.value0.constructor.name]);
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 623, column 3 - line 623, column 19): " + [v.constructor.name]);
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($copy_v);
      }
      ;
      return $tco_result;
    };
    return unfoldr2(go)(new Cons(m, Nil.value));
  };
};
var toAscArray = /* @__PURE__ */ toUnfoldable2(unfoldableArray);
var lookup = function(dictOrd) {
  var compare6 = compare(dictOrd);
  return function(k) {
    var go = function($copy_v) {
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(v) {
        if (v instanceof Leaf) {
          $tco_done = true;
          return Nothing.value;
        }
        ;
        if (v instanceof Two) {
          var v2 = compare6(k)(v.value1);
          if (v2 instanceof EQ) {
            $tco_done = true;
            return new Just(v.value2);
          }
          ;
          if (v2 instanceof LT) {
            $copy_v = v.value0;
            return;
          }
          ;
          $copy_v = v.value3;
          return;
        }
        ;
        if (v instanceof Three) {
          var v3 = compare6(k)(v.value1);
          if (v3 instanceof EQ) {
            $tco_done = true;
            return new Just(v.value2);
          }
          ;
          var v4 = compare6(k)(v.value4);
          if (v4 instanceof EQ) {
            $tco_done = true;
            return new Just(v.value5);
          }
          ;
          if (v3 instanceof LT) {
            $copy_v = v.value0;
            return;
          }
          ;
          if (v4 instanceof GT) {
            $copy_v = v.value6;
            return;
          }
          ;
          $copy_v = v.value3;
          return;
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 241, column 5 - line 241, column 22): " + [v.constructor.name]);
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($copy_v);
      }
      ;
      return $tco_result;
    };
    return go;
  };
};
var functorMap = {
  map: function(v) {
    return function(v1) {
      if (v1 instanceof Leaf) {
        return Leaf.value;
      }
      ;
      if (v1 instanceof Two) {
        return new Two(map(functorMap)(v)(v1.value0), v1.value1, v(v1.value2), map(functorMap)(v)(v1.value3));
      }
      ;
      if (v1 instanceof Three) {
        return new Three(map(functorMap)(v)(v1.value0), v1.value1, v(v1.value2), map(functorMap)(v)(v1.value3), v1.value4, v(v1.value5), map(functorMap)(v)(v1.value6));
      }
      ;
      throw new Error("Failed pattern match at Data.Map.Internal (line 116, column 1 - line 119, column 110): " + [v.constructor.name, v1.constructor.name]);
    };
  }
};
var fromZipper = function($copy_dictOrd) {
  return function($copy_v) {
    return function($copy_tree) {
      var $tco_var_dictOrd = $copy_dictOrd;
      var $tco_var_v = $copy_v;
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(dictOrd, v, tree) {
        if (v instanceof Nil) {
          $tco_done = true;
          return tree;
        }
        ;
        if (v instanceof Cons) {
          if (v.value0 instanceof TwoLeft) {
            $tco_var_dictOrd = dictOrd;
            $tco_var_v = v.value1;
            $copy_tree = new Two(tree, v.value0.value0, v.value0.value1, v.value0.value2);
            return;
          }
          ;
          if (v.value0 instanceof TwoRight) {
            $tco_var_dictOrd = dictOrd;
            $tco_var_v = v.value1;
            $copy_tree = new Two(v.value0.value0, v.value0.value1, v.value0.value2, tree);
            return;
          }
          ;
          if (v.value0 instanceof ThreeLeft) {
            $tco_var_dictOrd = dictOrd;
            $tco_var_v = v.value1;
            $copy_tree = new Three(tree, v.value0.value0, v.value0.value1, v.value0.value2, v.value0.value3, v.value0.value4, v.value0.value5);
            return;
          }
          ;
          if (v.value0 instanceof ThreeMiddle) {
            $tco_var_dictOrd = dictOrd;
            $tco_var_v = v.value1;
            $copy_tree = new Three(v.value0.value0, v.value0.value1, v.value0.value2, tree, v.value0.value3, v.value0.value4, v.value0.value5);
            return;
          }
          ;
          if (v.value0 instanceof ThreeRight) {
            $tco_var_dictOrd = dictOrd;
            $tco_var_v = v.value1;
            $copy_tree = new Three(v.value0.value0, v.value0.value1, v.value0.value2, v.value0.value3, v.value0.value4, v.value0.value5, tree);
            return;
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 462, column 3 - line 467, column 88): " + [v.value0.constructor.name]);
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 459, column 1 - line 459, column 80): " + [v.constructor.name, tree.constructor.name]);
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($tco_var_dictOrd, $tco_var_v, $copy_tree);
      }
      ;
      return $tco_result;
    };
  };
};
var insert = function(dictOrd) {
  var fromZipper1 = fromZipper(dictOrd);
  var compare6 = compare(dictOrd);
  return function(k) {
    return function(v) {
      var up = function($copy_v1) {
        return function($copy_v2) {
          var $tco_var_v1 = $copy_v1;
          var $tco_done = false;
          var $tco_result;
          function $tco_loop(v1, v2) {
            if (v1 instanceof Nil) {
              $tco_done = true;
              return new Two(v2.value0, v2.value1, v2.value2, v2.value3);
            }
            ;
            if (v1 instanceof Cons) {
              if (v1.value0 instanceof TwoLeft) {
                $tco_done = true;
                return fromZipper1(v1.value1)(new Three(v2.value0, v2.value1, v2.value2, v2.value3, v1.value0.value0, v1.value0.value1, v1.value0.value2));
              }
              ;
              if (v1.value0 instanceof TwoRight) {
                $tco_done = true;
                return fromZipper1(v1.value1)(new Three(v1.value0.value0, v1.value0.value1, v1.value0.value2, v2.value0, v2.value1, v2.value2, v2.value3));
              }
              ;
              if (v1.value0 instanceof ThreeLeft) {
                $tco_var_v1 = v1.value1;
                $copy_v2 = new KickUp(new Two(v2.value0, v2.value1, v2.value2, v2.value3), v1.value0.value0, v1.value0.value1, new Two(v1.value0.value2, v1.value0.value3, v1.value0.value4, v1.value0.value5));
                return;
              }
              ;
              if (v1.value0 instanceof ThreeMiddle) {
                $tco_var_v1 = v1.value1;
                $copy_v2 = new KickUp(new Two(v1.value0.value0, v1.value0.value1, v1.value0.value2, v2.value0), v2.value1, v2.value2, new Two(v2.value3, v1.value0.value3, v1.value0.value4, v1.value0.value5));
                return;
              }
              ;
              if (v1.value0 instanceof ThreeRight) {
                $tco_var_v1 = v1.value1;
                $copy_v2 = new KickUp(new Two(v1.value0.value0, v1.value0.value1, v1.value0.value2, v1.value0.value3), v1.value0.value4, v1.value0.value5, new Two(v2.value0, v2.value1, v2.value2, v2.value3));
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.Map.Internal (line 498, column 5 - line 503, column 108): " + [v1.value0.constructor.name, v2.constructor.name]);
            }
            ;
            throw new Error("Failed pattern match at Data.Map.Internal (line 495, column 3 - line 495, column 56): " + [v1.constructor.name, v2.constructor.name]);
          }
          ;
          while (!$tco_done) {
            $tco_result = $tco_loop($tco_var_v1, $copy_v2);
          }
          ;
          return $tco_result;
        };
      };
      var down = function($copy_ctx) {
        return function($copy_v1) {
          var $tco_var_ctx = $copy_ctx;
          var $tco_done1 = false;
          var $tco_result;
          function $tco_loop(ctx, v1) {
            if (v1 instanceof Leaf) {
              $tco_done1 = true;
              return up(ctx)(new KickUp(Leaf.value, k, v, Leaf.value));
            }
            ;
            if (v1 instanceof Two) {
              var v2 = compare6(k)(v1.value1);
              if (v2 instanceof EQ) {
                $tco_done1 = true;
                return fromZipper1(ctx)(new Two(v1.value0, k, v, v1.value3));
              }
              ;
              if (v2 instanceof LT) {
                $tco_var_ctx = new Cons(new TwoLeft(v1.value1, v1.value2, v1.value3), ctx);
                $copy_v1 = v1.value0;
                return;
              }
              ;
              $tco_var_ctx = new Cons(new TwoRight(v1.value0, v1.value1, v1.value2), ctx);
              $copy_v1 = v1.value3;
              return;
            }
            ;
            if (v1 instanceof Three) {
              var v3 = compare6(k)(v1.value1);
              if (v3 instanceof EQ) {
                $tco_done1 = true;
                return fromZipper1(ctx)(new Three(v1.value0, k, v, v1.value3, v1.value4, v1.value5, v1.value6));
              }
              ;
              var v4 = compare6(k)(v1.value4);
              if (v4 instanceof EQ) {
                $tco_done1 = true;
                return fromZipper1(ctx)(new Three(v1.value0, v1.value1, v1.value2, v1.value3, k, v, v1.value6));
              }
              ;
              if (v3 instanceof LT) {
                $tco_var_ctx = new Cons(new ThreeLeft(v1.value1, v1.value2, v1.value3, v1.value4, v1.value5, v1.value6), ctx);
                $copy_v1 = v1.value0;
                return;
              }
              ;
              if (v3 instanceof GT && v4 instanceof LT) {
                $tco_var_ctx = new Cons(new ThreeMiddle(v1.value0, v1.value1, v1.value2, v1.value4, v1.value5, v1.value6), ctx);
                $copy_v1 = v1.value3;
                return;
              }
              ;
              $tco_var_ctx = new Cons(new ThreeRight(v1.value0, v1.value1, v1.value2, v1.value3, v1.value4, v1.value5), ctx);
              $copy_v1 = v1.value6;
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.Map.Internal (line 478, column 3 - line 478, column 55): " + [ctx.constructor.name, v1.constructor.name]);
          }
          ;
          while (!$tco_done1) {
            $tco_result = $tco_loop($tco_var_ctx, $copy_v1);
          }
          ;
          return $tco_result;
        };
      };
      return down(Nil.value);
    };
  };
};
var foldableMap = {
  foldr: function(f) {
    return function(z) {
      return function(m) {
        if (m instanceof Leaf) {
          return z;
        }
        ;
        if (m instanceof Two) {
          return foldr(foldableMap)(f)(f(m.value2)(foldr(foldableMap)(f)(z)(m.value3)))(m.value0);
        }
        ;
        if (m instanceof Three) {
          return foldr(foldableMap)(f)(f(m.value2)(foldr(foldableMap)(f)(f(m.value5)(foldr(foldableMap)(f)(z)(m.value6)))(m.value3)))(m.value0);
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 133, column 17 - line 136, column 85): " + [m.constructor.name]);
      };
    };
  },
  foldl: function(f) {
    return function(z) {
      return function(m) {
        if (m instanceof Leaf) {
          return z;
        }
        ;
        if (m instanceof Two) {
          return foldl(foldableMap)(f)(f(foldl(foldableMap)(f)(z)(m.value0))(m.value2))(m.value3);
        }
        ;
        if (m instanceof Three) {
          return foldl(foldableMap)(f)(f(foldl(foldableMap)(f)(f(foldl(foldableMap)(f)(z)(m.value0))(m.value2))(m.value3))(m.value5))(m.value6);
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 137, column 17 - line 140, column 85): " + [m.constructor.name]);
      };
    };
  },
  foldMap: function(dictMonoid) {
    var mempty3 = mempty(dictMonoid);
    var append22 = append(dictMonoid.Semigroup0());
    return function(f) {
      return function(m) {
        if (m instanceof Leaf) {
          return mempty3;
        }
        ;
        if (m instanceof Two) {
          return append22(foldMap(foldableMap)(dictMonoid)(f)(m.value0))(append22(f(m.value2))(foldMap(foldableMap)(dictMonoid)(f)(m.value3)));
        }
        ;
        if (m instanceof Three) {
          return append22(foldMap(foldableMap)(dictMonoid)(f)(m.value0))(append22(f(m.value2))(append22(foldMap(foldableMap)(dictMonoid)(f)(m.value3))(append22(f(m.value5))(foldMap(foldableMap)(dictMonoid)(f)(m.value6)))));
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 141, column 17 - line 144, column 93): " + [m.constructor.name]);
      };
    };
  }
};
var foldableWithIndexMap = {
  foldrWithIndex: function(f) {
    return function(z) {
      return function(m) {
        if (m instanceof Leaf) {
          return z;
        }
        ;
        if (m instanceof Two) {
          return foldrWithIndex(foldableWithIndexMap)(f)(f(m.value1)(m.value2)(foldrWithIndex(foldableWithIndexMap)(f)(z)(m.value3)))(m.value0);
        }
        ;
        if (m instanceof Three) {
          return foldrWithIndex(foldableWithIndexMap)(f)(f(m.value1)(m.value2)(foldrWithIndex(foldableWithIndexMap)(f)(f(m.value4)(m.value5)(foldrWithIndex(foldableWithIndexMap)(f)(z)(m.value6)))(m.value3)))(m.value0);
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 147, column 26 - line 150, column 120): " + [m.constructor.name]);
      };
    };
  },
  foldlWithIndex: function(f) {
    return function(z) {
      return function(m) {
        if (m instanceof Leaf) {
          return z;
        }
        ;
        if (m instanceof Two) {
          return foldlWithIndex(foldableWithIndexMap)(f)(f(m.value1)(foldlWithIndex(foldableWithIndexMap)(f)(z)(m.value0))(m.value2))(m.value3);
        }
        ;
        if (m instanceof Three) {
          return foldlWithIndex(foldableWithIndexMap)(f)(f(m.value4)(foldlWithIndex(foldableWithIndexMap)(f)(f(m.value1)(foldlWithIndex(foldableWithIndexMap)(f)(z)(m.value0))(m.value2))(m.value3))(m.value5))(m.value6);
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 151, column 26 - line 154, column 120): " + [m.constructor.name]);
      };
    };
  },
  foldMapWithIndex: function(dictMonoid) {
    var mempty3 = mempty(dictMonoid);
    var append22 = append(dictMonoid.Semigroup0());
    return function(f) {
      return function(m) {
        if (m instanceof Leaf) {
          return mempty3;
        }
        ;
        if (m instanceof Two) {
          return append22(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value0))(append22(f(m.value1)(m.value2))(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value3)));
        }
        ;
        if (m instanceof Three) {
          return append22(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value0))(append22(f(m.value1)(m.value2))(append22(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value3))(append22(f(m.value4)(m.value5))(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value6)))));
        }
        ;
        throw new Error("Failed pattern match at Data.Map.Internal (line 155, column 26 - line 158, column 128): " + [m.constructor.name]);
      };
    };
  },
  Foldable0: function() {
    return foldableMap;
  }
};
var foldrWithIndex2 = /* @__PURE__ */ foldrWithIndex(foldableWithIndexMap);
var keys = /* @__PURE__ */ function() {
  return foldrWithIndex2(function(k) {
    return function(v) {
      return function(acc) {
        return new Cons(k, acc);
      };
    };
  })(Nil.value);
}();
var values = /* @__PURE__ */ function() {
  return foldr(foldableMap)(Cons.create)(Nil.value);
}();
var eqMap = function(dictEq) {
  var eqTuple2 = eqTuple(dictEq);
  return function(dictEq1) {
    var eq14 = eq(eqArray(eqTuple2(dictEq1)));
    return {
      eq: function(m1) {
        return function(m2) {
          return eq14(toAscArray(m1))(toAscArray(m2));
        };
      }
    };
  };
};
var empty2 = /* @__PURE__ */ function() {
  return Leaf.value;
}();
var fromFoldable2 = function(dictOrd) {
  var insert1 = insert(dictOrd);
  return function(dictFoldable) {
    return foldl(dictFoldable)(function(m) {
      return function(v) {
        return insert1(v.value0)(v.value1)(m);
      };
    })(empty2);
  };
};

// output/Data.Set/index.js
var $$Set = function(x) {
  return x;
};
var toList = function(v) {
  return keys(v);
};
var toUnfoldable3 = function(dictUnfoldable) {
  var $127 = toUnfoldable(dictUnfoldable);
  return function($128) {
    return $127(toList($128));
  };
};
var fromMap = $$Set;
var eqSet = function(dictEq) {
  var eq6 = eq(eqMap(dictEq)(eqUnit));
  return {
    eq: function(v) {
      return function(v1) {
        return eq6(v)(v1);
      };
    }
  };
};

// output/Data.Map/index.js
var keys2 = /* @__PURE__ */ function() {
  var $38 = $$void(functorMap);
  return function($39) {
    return fromMap($38($39));
  };
}();

// output/TaxRate/index.js
var zeroRate = function(dict) {
  return dict.zeroRate;
};
var rateToNumber = function(dict) {
  return dict.rateToNumber;
};
var absoluteDifference = function(dict) {
  return dict.absoluteDifference;
};

// output/Moneys/index.js
var show3 = /* @__PURE__ */ show(showNumber);
var coerce2 = /* @__PURE__ */ coerce();
var showMoney = {
  show: function(v) {
    return show3(v);
  }
};
var showTaxPayable = showMoney;
var showTaxableIncome = showMoney;
var showIncome = showMoney;
var showDeduction = showMoney;
var semigroupMoney = /* @__PURE__ */ semigroupAdditive(semiringNumber);
var semigroupTaxPayable = semigroupMoney;
var semigroupTaxableIncome = semigroupMoney;
var semigroupIncome = semigroupMoney;
var semigroupDeduction = semigroupMoney;
var ordMoney = /* @__PURE__ */ ordAdditive(ordNumber);
var compare4 = /* @__PURE__ */ compare(ordMoney);
var greaterThan2 = /* @__PURE__ */ greaterThan(ordMoney);
var lessThan1 = /* @__PURE__ */ lessThan(ordMoney);
var monoidMoney = /* @__PURE__ */ monoidAdditive(semiringNumber);
var monoidTaxPayable = monoidMoney;
var monoidIncomeThreshold = monoidMoney;
var monoidDeduction = monoidMoney;
var eqMoney = /* @__PURE__ */ eqAdditive(eqNumber);
var eq4 = /* @__PURE__ */ eq(eqMoney);
var eqIncome = {
  eq: function(x) {
    return function(y) {
      return eq4(x)(y);
    };
  }
};
var ordIncome = {
  compare: function(x) {
    return function(y) {
      return compare4(x)(y);
    };
  },
  Eq0: function() {
    return eqIncome;
  }
};
var eqDeduction = {
  eq: function(x) {
    return function(y) {
      return eq4(x)(y);
    };
  }
};
var ordDeduction = {
  compare: function(x) {
    return function(y) {
      return compare4(x)(y);
    };
  },
  Eq0: function() {
    return eqDeduction;
  }
};
var timesImpl = function() {
  return function(i4) {
    return function(m) {
      return coerce2(toNumber(i4) * coerce2(m));
    };
  };
};
var hasTimesDeduction = {
  times: /* @__PURE__ */ timesImpl(),
  Coercible0: function() {
    return void 0;
  }
};
var times = function(dict) {
  return dict.times;
};
var taxableAsIncome = coerce2;
var roundHalfUp = function($141) {
  return toNumber(round2($141));
};
var nonZeroImpl = function() {
  return function(m) {
    return coerce2(m) !== 0;
  };
};
var hasNonZeroIncomeThreshold = {
  nonZero: /* @__PURE__ */ nonZeroImpl(),
  Coercible0: function() {
    return void 0;
  }
};
var nonZero = function(dict) {
  return dict.nonZero;
};
var noMoneyImpl = function(dictMonoid) {
  return mempty(dictMonoid);
};
var hasNoMoneyDeduction = {
  noMoney: /* @__PURE__ */ noMoneyImpl(monoidDeduction),
  Monoid0: function() {
    return monoidDeduction;
  }
};
var noMoney = function(dict) {
  return dict.noMoney;
};
var mulImpl = function() {
  return function(m) {
    return function(n) {
      return coerce2(n * coerce2(m));
    };
  };
};
var mulImpl1 = /* @__PURE__ */ mulImpl();
var hasMulDeduction = {
  mul: mulImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var hasMulIncome = {
  mul: mulImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var mul2 = function(dict) {
  return dict.mul;
};
var mkMoney = function(d) {
  if (d < 0) {
    return unsafeThrow("Money can't be negative");
  }
  ;
  if (otherwise) {
    return coerce2(d);
  }
  ;
  throw new Error("Failed pattern match at Moneys (line 100, column 1 - line 100, column 27): " + [d.constructor.name]);
};
var monus = function(m1) {
  return function(m2) {
    if (greaterThan2(m1)(m2)) {
      return coerce2(coerce2(m1) - coerce2(m2));
    }
    ;
    if (otherwise) {
      return mkMoney(0);
    }
    ;
    throw new Error("Failed pattern match at Moneys (line 105, column 1 - line 105, column 33): " + [m1.constructor.name, m2.constructor.name]);
  };
};
var reduceBy = function(x) {
  return function(y) {
    return coerce2(monus(coerce2(x))(coerce2(y)));
  };
};
var makeFromIntImpl = function() {
  return function(i4) {
    return coerce2(toNumber(i4));
  };
};
var makeFromIntImpl1 = /* @__PURE__ */ makeFromIntImpl();
var hasMakeFromIntDeduction = {
  makeFromInt: makeFromIntImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var hasMakeFromIntIncome = {
  makeFromInt: makeFromIntImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var hasMakeFromIntIncomeThres = {
  makeFromInt: makeFromIntImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var makeFromInt = function(dict) {
  return dict.makeFromInt;
};
var isBelow = function(i4) {
  return function(it) {
    return lessThan1(coerce2(i4))(coerce2(it));
  };
};
var inflateThreshold = function(factor) {
  return function(threshold) {
    return coerce2(roundHalfUp(coerce2(threshold) * factor));
  };
};
var divideImpl = function() {
  return function(left) {
    return function(right) {
      return coerce2(left) / coerce2(right);
    };
  };
};
var hasDivideIncomeThreshold = {
  divide: /* @__PURE__ */ divideImpl(),
  Coercible0: function() {
    return void 0;
  }
};
var divide = function(dict) {
  return dict.divide;
};
var divInt = function(ti) {
  return function(i4) {
    return coerce2(coerce2(ti) / toNumber(i4));
  };
};
var diff = function(m1) {
  return function(m2) {
    return coerce2(abs(coerce2(m1) - coerce2(m2)));
  };
};
var thresholdDifference = function(it1) {
  return function(it2) {
    return coerce2(diff(coerce2(it1))(coerce2(it2)));
  };
};
var asTaxable = coerce2;
var applyTaxRate = function(dictTaxRate) {
  var rateToNumber2 = rateToNumber(dictTaxRate);
  return function(rate) {
    return function(income) {
      return coerce2(coerce2(income) * rateToNumber2(rate));
    };
  };
};
var applyDeductions = function(income) {
  return function(deductions) {
    return coerce2(monus(coerce2(income))(coerce2(deductions)));
  };
};
var amountOverThresholdImpl = function() {
  return function(m) {
    return function(threshold) {
      return coerce2(monus(coerce2(m))(coerce2(threshold)));
    };
  };
};
var amountOverThresholdImpl1 = /* @__PURE__ */ amountOverThresholdImpl();
var hasAmountOverThresholdInc = {
  amountOverThreshold: amountOverThresholdImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var hasAmountOverThresholdTax = {
  amountOverThreshold: amountOverThresholdImpl1,
  Coercible0: function() {
    return void 0;
  }
};
var amountOverThreshold = function(dict) {
  return dict.amountOverThreshold;
};

// output/Brackets/index.js
var toUnfoldable4 = /* @__PURE__ */ toUnfoldable2(unfoldableArray);
var toUnfoldable1 = /* @__PURE__ */ toUnfoldable3(unfoldableList);
var bind2 = /* @__PURE__ */ bind(bindMaybe);
var find3 = /* @__PURE__ */ find(foldableList);
var fromJust7 = /* @__PURE__ */ fromJust();
var map1 = /* @__PURE__ */ map(functorMap);
var makeFromInt2 = /* @__PURE__ */ makeFromInt(hasMakeFromIntIncomeThres);
var map22 = /* @__PURE__ */ map(functorArray);
var toPairs = function(dictTaxRate) {
  return function(brackets) {
    return toUnfoldable4(brackets);
  };
};
var safeBracketWidth = function(dictTaxRate) {
  var Ord0 = dictTaxRate.Ord0();
  var eq6 = eq(Ord0.Eq0());
  var lookup4 = lookup(Ord0);
  return function(brackets) {
    return function(rate) {
      var rates = toUnfoldable1(keys2(brackets));
      return bind2(tail(rates))(function(ratesTail) {
        var pairs = zip(rates)(ratesTail);
        return bind2(find3(function(p) {
          return eq6(fst(p))(rate);
        })(pairs))(function(pair) {
          var successor = snd(pair);
          return bind2(lookup4(rate)(brackets))(function(rateStart) {
            return bind2(lookup4(successor)(brackets))(function(successorStart) {
              return new Just(thresholdDifference(successorStart)(rateStart));
            });
          });
        });
      });
    };
  };
};
var inflateThresholds = function(dictTaxRate) {
  return function(factor) {
    return map1(inflateThreshold(factor));
  };
};
var fromRPairs = function(dictTaxRate) {
  var fromFoldable12 = fromFoldable2(dictTaxRate.Ord0())(foldableArray);
  return function(tuples) {
    return function(mkRate) {
      var f = function(v) {
        return new Tuple(mkRate(v.value1 / 100), makeFromInt2(v.value0));
      };
      return fromFoldable12(map22(f)(tuples));
    };
  };
};
var bracketWidth = function(dictTaxRate) {
  var safeBracketWidth1 = safeBracketWidth(dictTaxRate);
  return function(brackets) {
    return function(rate) {
      return fromJust7(safeBracketWidth1(brackets)(rate));
    };
  };
};

// output/Data.Interpolate/index.js
var interpString = {
  interp: function(a) {
    return a;
  }
};
var interp = function(dict) {
  return dict.interp;
};
var interpStringFunction = function(dictInterp) {
  var interp1 = interp(dictInterp);
  return {
    interp: function(a) {
      return function(b) {
        return interp1(a + b);
      };
    }
  };
};
var i = function(dictInterp) {
  return interp(dictInterp)("");
};

// output/Federal.FederalTaxRate/index.js
var i2 = /* @__PURE__ */ i(/* @__PURE__ */ interpStringFunction(/* @__PURE__ */ interpStringFunction(interpString)));
var show4 = /* @__PURE__ */ show(showNumber);
var ordFederalTaxRate = ordNumber;
var eqFederalTaxRate = eqNumber;
var mkFederalTaxRate = function(d) {
  if (d < 0) {
    return unsafeThrow(i2("Invalid FederalTaxRate ")(show4(d)));
  }
  ;
  if (d > 0.9) {
    return unsafeThrow(i2("Invalid FederalTaxRate ")(show4(d)));
  }
  ;
  if (otherwise) {
    return d;
  }
  ;
  throw new Error("Failed pattern match at Federal.FederalTaxRate (line 17, column 1 - line 17, column 45): " + [d.constructor.name]);
};
var taxRateFederalTaxRate = {
  zeroRate: /* @__PURE__ */ mkFederalTaxRate(0),
  rateToNumber: function(v) {
    return v;
  },
  absoluteDifference: function(v) {
    return function(v1) {
      return abs(v - v1);
    };
  },
  Ord0: function() {
    return ordFederalTaxRate;
  }
};

// output/TaxFunction/index.js
var amountOverThreshold2 = /* @__PURE__ */ amountOverThreshold(hasAmountOverThresholdTax);
var toUnfoldable5 = /* @__PURE__ */ toUnfoldable2(unfoldableList);
var map5 = /* @__PURE__ */ map(functorList);
var mempty2 = /* @__PURE__ */ mempty(monoidIncomeThreshold);
var fold3 = /* @__PURE__ */ fold(foldableList)(/* @__PURE__ */ monoidFn(monoidTaxPayable));
var thresholdTaxFunction = function(dictTaxRate) {
  var applyTaxRate2 = applyTaxRate(dictTaxRate);
  return function(threshold) {
    return function(rate) {
      return function(ti) {
        return applyTaxRate2(rate)(amountOverThreshold2(ti)(threshold));
      };
    };
  };
};
var rateDeltasForBrackets = function(dictTaxRate) {
  var absoluteDifference2 = absoluteDifference(dictTaxRate);
  var zeroRate2 = zeroRate(dictTaxRate);
  return function(brackets) {
    var pairs = toUnfoldable5(brackets);
    var rates = map5(fst)(pairs);
    var thresholds = map5(snd)(pairs);
    var deltas = zipWith(absoluteDifference2)(new Cons(zeroRate2, rates))(rates);
    return zip(thresholds)(deltas);
  };
};
var flatTaxFunction = function(dictTaxRate) {
  return thresholdTaxFunction(dictTaxRate)(mempty2);
};
var bracketsTaxFunction = function(dictTaxRate) {
  var rateDeltasForBrackets1 = rateDeltasForBrackets(dictTaxRate);
  var thresholdTaxFunction1 = thresholdTaxFunction(dictTaxRate);
  return function(brackets) {
    var pairs = rateDeltasForBrackets1(brackets);
    var taxFuncs = map5(uncurry(thresholdTaxFunction1))(pairs);
    return fold3(taxFuncs);
  };
};

// output/Federal.OrdinaryBrackets/index.js
var toPairs1 = /* @__PURE__ */ toPairs(taxRateFederalTaxRate);
var coerce3 = /* @__PURE__ */ coerce();
var bracketsTaxFunction2 = /* @__PURE__ */ bracketsTaxFunction(taxRateFederalTaxRate);
var bracketWidth2 = /* @__PURE__ */ bracketWidth(taxRateFederalTaxRate);
var inflateThresholds1 = /* @__PURE__ */ inflateThresholds(taxRateFederalTaxRate);
var fromRPairs1 = /* @__PURE__ */ fromRPairs(taxRateFederalTaxRate);
var toPairs2 = function(v) {
  return toPairs1(v);
};
var taxFunctionFor = function(v) {
  return bracketsTaxFunction2(v);
};
var ordinaryIncomeBracketWidth = function(brackets) {
  return bracketWidth2(coerce3(brackets));
};
var inflateThresholds2 = function(factor) {
  return function(v) {
    return coerce3(inflateThresholds1(factor)(v));
  };
};
var fromRPairs2 = function(pairs) {
  return coerce3(fromRPairs1(pairs)(mkFederalTaxRate));
};

// output/Federal.QualifiedBrackets/index.js
var toPairs12 = /* @__PURE__ */ toPairs(taxRateFederalTaxRate);
var coerce4 = /* @__PURE__ */ coerce();
var bracketsTaxFunction3 = /* @__PURE__ */ bracketsTaxFunction(taxRateFederalTaxRate);
var fromJust8 = /* @__PURE__ */ fromJust();
var inflateThresholds12 = /* @__PURE__ */ inflateThresholds(taxRateFederalTaxRate);
var fromRPairs12 = /* @__PURE__ */ fromRPairs(taxRateFederalTaxRate);
var toPairs3 = function(v) {
  return toPairs12(v);
};
var taxFunctionFor2 = function(v) {
  return bracketsTaxFunction3(v);
};
var startOfNonZeroQualifiedRateBracket = function(v) {
  return fromJust8(index(values(v))(1));
};
var inflateThresholds3 = function(factor) {
  return function(v) {
    return coerce4(inflateThresholds12(factor)(v));
  };
};
var fromRPairs3 = function(pairs) {
  return coerce4(fromRPairs12(pairs)(mkFederalTaxRate));
};

// output/Federal.Regime/index.js
var fromJust9 = /* @__PURE__ */ fromJust();
var Trump = /* @__PURE__ */ function() {
  function Trump2() {
  }
  ;
  Trump2.value = new Trump2();
  return Trump2;
}();
var PreTrump = /* @__PURE__ */ function() {
  function PreTrump2() {
  }
  ;
  PreTrump2.value = new PreTrump2();
  return PreTrump2;
}();
var readRegime = {
  read: function(s) {
    if (s === "Trump") {
      return new Just(Trump.value);
    }
    ;
    if (s === "PreTrump") {
      return new Just(PreTrump.value);
    }
    ;
    return Nothing.value;
  }
};
var read5 = /* @__PURE__ */ read(readRegime);
var eqRegime = {
  eq: function(x) {
    return function(y) {
      if (x instanceof Trump && y instanceof Trump) {
        return true;
      }
      ;
      if (x instanceof PreTrump && y instanceof PreTrump) {
        return true;
      }
      ;
      return false;
    };
  }
};
var unsafeReadRegime = function(s) {
  return fromJust9(read5(s));
};

// output/UnsafeDates/index.js
var fromJust10 = /* @__PURE__ */ fromJust();
var toEnum4 = /* @__PURE__ */ toEnum(boundedEnumYear);
var toEnum1 = /* @__PURE__ */ toEnum(boundedEnumMonth);
var toEnum22 = /* @__PURE__ */ toEnum(boundedEnumDay);
var unsafeMakeYear = function(i4) {
  return fromJust10(toEnum4(i4));
};
var unsafeMakeMonth = function(i4) {
  return fromJust10(toEnum1(i4));
};
var unsafeMakeDay = function(i4) {
  return fromJust10(toEnum22(i4));
};
var unsafeMakeDate = function(y) {
  return function(m) {
    return function(d) {
      return canonicalDate(unsafeMakeYear(y))(unsafeMakeMonth(m))(unsafeMakeDay(d));
    };
  };
};

// output/Federal.Yearly.Year2016/index.js
var makeFromInt3 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values2 = /* @__PURE__ */ function() {
  return {
    regime: PreTrump.value,
    year: unsafeMakeYear(2016),
    perPersonExemption: makeFromInt3(4050),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt3(12600);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt3(9300);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt3(6300);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2016 (line 20, column 7 - line 23, column 35): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt3(1250),
    adjustmentWhenOver65AndSingle: makeFromInt3(300),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(18550, 15), new Tuple(75300, 25), new Tuple(151900, 28), new Tuple(231450, 33), new Tuple(413350, 35), new Tuple(466950, 39.6)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(13250, 15), new Tuple(50400, 25), new Tuple(130150, 28), new Tuple(210800, 33), new Tuple(413350, 35), new Tuple(441e3, 39.6)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(9275, 15), new Tuple(37650, 25), new Tuple(91150, 28), new Tuple(190150, 33), new Tuple(413350, 35), new Tuple(415050, 39.6)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2016 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(75300, 15), new Tuple(466950, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(50400, 15), new Tuple(441e3, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(37650, 15), new Tuple(415050, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2016 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.Year2017/index.js
var makeFromInt4 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values3 = /* @__PURE__ */ function() {
  return {
    regime: PreTrump.value,
    year: unsafeMakeYear(2017),
    perPersonExemption: makeFromInt4(4050),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt4(12700);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt4(9350);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt4(6350);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2017 (line 20, column 7 - line 23, column 35): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt4(1250),
    adjustmentWhenOver65AndSingle: makeFromInt4(300),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(18650, 15), new Tuple(75900, 25), new Tuple(153100, 28), new Tuple(233350, 33), new Tuple(416700, 35), new Tuple(470700, 39.6)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(13350, 15), new Tuple(50800, 25), new Tuple(131200, 28), new Tuple(212500, 33), new Tuple(416700, 35), new Tuple(444550, 39.6)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(9325, 15), new Tuple(37950, 25), new Tuple(91900, 28), new Tuple(191650, 33), new Tuple(416700, 35), new Tuple(418400, 39.6)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2017 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(75900, 15), new Tuple(470700, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(50800, 15), new Tuple(444550, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(37950, 15), new Tuple(418400, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2017 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.Year2018/index.js
var makeFromInt5 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values4 = /* @__PURE__ */ function() {
  return {
    regime: Trump.value,
    year: unsafeMakeYear(2018),
    perPersonExemption: makeFromInt5(0),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt5(24e3);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt5(18e3);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt5(12e3);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2018 (line 20, column 7 - line 23, column 36): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt5(1300),
    adjustmentWhenOver65AndSingle: makeFromInt5(300),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(19050, 12), new Tuple(77400, 22), new Tuple(165e3, 24), new Tuple(315e3, 32), new Tuple(4e5, 35), new Tuple(6e5, 37)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(13600, 12), new Tuple(51800, 22), new Tuple(82500, 24), new Tuple(157500, 32), new Tuple(2e5, 35), new Tuple(5e5, 37)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(9525, 12), new Tuple(38700, 22), new Tuple(82500, 24), new Tuple(157500, 32), new Tuple(2e5, 35), new Tuple(5e5, 37)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2018 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(77200, 15), new Tuple(479e3, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(51700, 15), new Tuple(452400, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(38600, 15), new Tuple(425800, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2018 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.Year2019/index.js
var makeFromInt6 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values5 = /* @__PURE__ */ function() {
  return {
    regime: Trump.value,
    year: unsafeMakeYear(2019),
    perPersonExemption: makeFromInt6(0),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt6(24400);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt6(18350);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt6(12200);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2019 (line 20, column 7 - line 23, column 36): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt6(1300),
    adjustmentWhenOver65AndSingle: makeFromInt6(350),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(19400, 12), new Tuple(78950, 22), new Tuple(168400, 24), new Tuple(321450, 32), new Tuple(408200, 35), new Tuple(612350, 37)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(13850, 12), new Tuple(52850, 22), new Tuple(84200, 24), new Tuple(160700, 32), new Tuple(204100, 35), new Tuple(510300, 37)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(9700, 12), new Tuple(39475, 22), new Tuple(84200, 24), new Tuple(160725, 32), new Tuple(204100, 35), new Tuple(510300, 37)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2019 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(78750, 15), new Tuple(488850, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(52750, 15), new Tuple(461700, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(39375, 15), new Tuple(434550, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2019 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.Year2020/index.js
var makeFromInt7 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values6 = /* @__PURE__ */ function() {
  return {
    regime: Trump.value,
    year: unsafeMakeYear(2020),
    perPersonExemption: makeFromInt7(0),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt7(24800);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt7(18650);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt7(12400);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2020 (line 20, column 7 - line 23, column 36): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt7(1300),
    adjustmentWhenOver65AndSingle: makeFromInt7(350),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(19750, 12), new Tuple(80250, 22), new Tuple(171050, 24), new Tuple(326600, 32), new Tuple(414700, 35), new Tuple(622050, 37)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(14100, 12), new Tuple(53700, 22), new Tuple(85500, 24), new Tuple(163300, 32), new Tuple(207350, 35), new Tuple(518400, 37)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(9875, 12), new Tuple(40125, 22), new Tuple(85525, 24), new Tuple(163300, 32), new Tuple(207350, 35), new Tuple(518400, 37)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2020 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(8e4, 15), new Tuple(496600, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(53600, 15), new Tuple(469050, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(4e4, 15), new Tuple(442450, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2020 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.Year2021/index.js
var makeFromInt8 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values7 = /* @__PURE__ */ function() {
  return {
    regime: Trump.value,
    year: unsafeMakeYear(2021),
    perPersonExemption: makeFromInt8(0),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt8(25100);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt8(18800);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt8(12550);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2021 (line 20, column 7 - line 23, column 36): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt8(1350),
    adjustmentWhenOver65AndSingle: makeFromInt8(350),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(19900, 12), new Tuple(81050, 22), new Tuple(172750, 24), new Tuple(329850, 32), new Tuple(418850, 35), new Tuple(628300, 37)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(14200, 12), new Tuple(54200, 22), new Tuple(86350, 24), new Tuple(164900, 32), new Tuple(209400, 35), new Tuple(523600, 37)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(9950, 12), new Tuple(40525, 22), new Tuple(86375, 24), new Tuple(164925, 32), new Tuple(209425, 35), new Tuple(523600, 37)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2021 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(80800, 15), new Tuple(501600, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(54100, 15), new Tuple(473750, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(40400, 15), new Tuple(445850, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2021 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.Year2022/index.js
var makeFromInt9 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var values8 = /* @__PURE__ */ function() {
  return {
    regime: Trump.value,
    year: unsafeMakeYear(2022),
    perPersonExemption: makeFromInt9(0),
    unadjustedStandardDeduction: function(v) {
      if (v instanceof Married) {
        return makeFromInt9(25900);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return makeFromInt9(19400);
      }
      ;
      if (v instanceof Single) {
        return makeFromInt9(12950);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2022 (line 20, column 7 - line 23, column 36): " + [v.constructor.name]);
    },
    adjustmentWhenOver65: makeFromInt9(1400),
    adjustmentWhenOver65AndSingle: makeFromInt9(350),
    ordinaryBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(20550, 12), new Tuple(83550, 22), new Tuple(178150, 24), new Tuple(340100, 32), new Tuple(431900, 35), new Tuple(647850, 37)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(14650, 12), new Tuple(55900, 22), new Tuple(89050, 24), new Tuple(170050, 32), new Tuple(215950, 35), new Tuple(539900, 37)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs2([new Tuple(0, 10), new Tuple(10275, 12), new Tuple(41775, 22), new Tuple(89075, 24), new Tuple(170050, 32), new Tuple(215950, 35), new Tuple(539900, 37)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2022 (line 27, column 7 - line 57, column 14): " + [v.constructor.name]);
    },
    qualifiedBrackets: function(v) {
      if (v instanceof Married) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(83350, 15), new Tuple(517200, 20)]);
      }
      ;
      if (v instanceof HeadOfHousehold) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(55800, 15), new Tuple(488500, 20)]);
      }
      ;
      if (v instanceof Single) {
        return fromRPairs3([new Tuple(0, 0), new Tuple(41675, 15), new Tuple(459750, 20)]);
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.Year2022 (line 59, column 7 - line 77, column 14): " + [v.constructor.name]);
    }
  };
}();

// output/Federal.Yearly.YearlyValues/index.js
var nonZero2 = /* @__PURE__ */ nonZero(hasNonZeroIncomeThreshold);
var bind3 = /* @__PURE__ */ bind(bindArray);
var pure2 = /* @__PURE__ */ pure(applicativeArray);
var fromFoldable3 = /* @__PURE__ */ fromFoldable2(/* @__PURE__ */ ordTuple(ordFilingStatus)(ordFederalTaxRate))(foldableArray);
var eq5 = /* @__PURE__ */ eq(/* @__PURE__ */ eqSet(/* @__PURE__ */ eqTuple(eqFilingStatus)(eqFederalTaxRate)));
var fromFoldable1 = /* @__PURE__ */ fromFoldable2(ordYear);
var fromJust11 = /* @__PURE__ */ fromJust();
var lookup2 = /* @__PURE__ */ lookup(ordYear);
var compare5 = /* @__PURE__ */ compare(ordYear);
var lessThan2 = /* @__PURE__ */ lessThan(ordYear);
var eq13 = /* @__PURE__ */ eq(eqRegime);
var toUnfoldable6 = /* @__PURE__ */ toUnfoldable2(unfoldableList);
var map6 = /* @__PURE__ */ map(functorList);
var append2 = /* @__PURE__ */ append(semigroupList);
var divide2 = /* @__PURE__ */ divide(hasDivideIncomeThreshold);
var foldl4 = /* @__PURE__ */ foldl(foldableList);
var hasNonZeroThreshold = function(v) {
  return nonZero2(v.value1);
};
var ordinaryNonZeroThresholdsMap = function(yv) {
  var pairs = bind3([Single.value, HeadOfHousehold.value, Married.value])(function(fs) {
    var obs = yv.ordinaryBrackets(fs);
    return bind3(filter(hasNonZeroThreshold)(toPairs2(obs)))(function(v) {
      return pure2(new Tuple(new Tuple(fs, v.value0), v.value1));
    });
  });
  return fromFoldable3(pairs);
};
var haveCongruentOrdinaryBrackets = function(left) {
  return function(right) {
    return eq5(keys2(ordinaryNonZeroThresholdsMap(left)))(keys2(ordinaryNonZeroThresholdsMap(right)));
  };
};
var qualifiedNonZeroThresholdsMap = function(yv) {
  var pairs = bind3([Single.value, HeadOfHousehold.value, Married.value])(function(fs) {
    var qbs = yv.qualifiedBrackets(fs);
    return bind3(filter(hasNonZeroThreshold)(toPairs3(qbs)))(function(v) {
      return pure2(new Tuple(new Tuple(fs, v.value0), v.value1));
    });
  });
  return fromFoldable3(pairs);
};
var haveCongruentQualifiedBrackets = function(left) {
  return function(right) {
    return eq5(keys2(qualifiedNonZeroThresholdsMap(left)))(keys2(qualifiedNonZeroThresholdsMap(right)));
  };
};
var forYear = /* @__PURE__ */ function() {
  return fromFoldable1(foldableArray)(map(functorArray)(function(v) {
    return new Tuple(unsafeMakeYear(v.value0), v.value1);
  })([new Tuple(2016, values2), new Tuple(2017, values3), new Tuple(2018, values4), new Tuple(2019, values5), new Tuple(2020, values6), new Tuple(2021, values7), new Tuple(2022, values8)]));
}();
var unsafeValuesForYear = function(y) {
  return fromJust11(lookup2(y)(forYear));
};
var valuesAscendingByYear = /* @__PURE__ */ function() {
  var cmp = function(yv1) {
    return function(yv2) {
      return compare5(yv1.year)(yv2.year);
    };
  };
  return sortBy(cmp)(fromFoldable(foldableList)(values(forYear)));
}();
var mostRecent = /* @__PURE__ */ fromJust11(/* @__PURE__ */ last(valuesAscendingByYear));
var yearIsFuture = function(y) {
  return lessThan2(mostRecent.year)(y);
};
var valuesAscendingByYearForRegime = function(reg) {
  return filter(function(yv) {
    return eq13(yv.regime)(reg);
  })(valuesAscendingByYear);
};
var mostRecentForRegime = function(reg) {
  return fromJust11(last(valuesAscendingByYearForRegime(reg)));
};
var averageThresholdChange = function(left) {
  return function(right) {
    var valuesByAscendingKey = function(m) {
      var orderedEntries = toUnfoldable6(m);
      return map6(function(v) {
        return v.value1;
      })(orderedEntries);
    };
    var qualPairs = function() {
      if (haveCongruentQualifiedBrackets(left)(right)) {
        return zip(valuesByAscendingKey(qualifiedNonZeroThresholdsMap(left)))(valuesByAscendingKey(qualifiedNonZeroThresholdsMap(right)));
      }
      ;
      if (otherwise) {
        return Nil.value;
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.YearlyValues (line 142, column 5 - line 146, column 29): " + []);
    }();
    var ordPairs = function() {
      if (haveCongruentOrdinaryBrackets(left)(right)) {
        return zip(valuesByAscendingKey(ordinaryNonZeroThresholdsMap(left)))(valuesByAscendingKey(ordinaryNonZeroThresholdsMap(right)));
      }
      ;
      if (otherwise) {
        return Nil.value;
      }
      ;
      throw new Error("Failed pattern match at Federal.Yearly.YearlyValues (line 136, column 5 - line 140, column 29): " + []);
    }();
    var pairs = append2(ordPairs)(qualPairs);
    var changes = map6(function(v) {
      return divide2(v.value1)(v.value0);
    })(pairs);
    var changesSum = foldl4(function(x) {
      return function(y) {
        return x + y;
      };
    })(0)(changes);
    var averageChange = changesSum / toNumber(length2(changes));
    return averageChange;
  };
};
var memoizedAverageThresholdChanges = /* @__PURE__ */ function() {
  var yvs = values(forYear);
  var yvPairs = zip(yvs)(fromJust11(tail(yvs)));
  var mapPairs = map6(function(v) {
    return new Tuple(v.value1.year, averageThresholdChange(v.value0)(v.value1));
  })(yvPairs);
  return fromFoldable1(foldableList)(mapPairs);
}();
var averageThresholdChangeOverPrevious = function(y) {
  return lookup2(y)(memoizedAverageThresholdChanges);
};

// output/Federal.BoundRegime/index.js
var append3 = /* @__PURE__ */ append(semigroupDeduction);
var noMoney2 = /* @__PURE__ */ noMoney(hasNoMoneyDeduction);
var times2 = /* @__PURE__ */ times(hasTimesDeduction);
var max3 = /* @__PURE__ */ max(ordDeduction);
var mul3 = /* @__PURE__ */ mul2(hasMulDeduction);
var show5 = /* @__PURE__ */ show(showYear);
var fromEnum4 = /* @__PURE__ */ fromEnum(boundedEnumYear);
var bind4 = /* @__PURE__ */ bind(bindList);
var pure3 = /* @__PURE__ */ pure(applicativeList);
var foldl5 = /* @__PURE__ */ foldl(foldableList);
var BoundRegime = function(x) {
  return x;
};
var standardDeduction = function(v) {
  return function(birthDate) {
    return append3(v.unadjustedStandardDeduction)(function() {
      var $59 = isAge65OrOlder(birthDate)(v.year);
      if ($59) {
        return append3(v.adjustmentWhenOver65)(function() {
          var $60 = isUnmarried(v.filingStatus);
          if ($60) {
            return v.adjustmentWhenOver65AndSingle;
          }
          ;
          return noMoney2;
        }());
      }
      ;
      return noMoney2;
    }());
  };
};
var personalExemptionDeduction = function(v) {
  return function(personalExemptions) {
    return times2(personalExemptions)(v.perPersonExemption);
  };
};
var netDeduction = function(br) {
  return function(birthDate) {
    return function(personalExemptions) {
      return function(itemized) {
        return append3(personalExemptionDeduction(br)(personalExemptions))(max3(itemized)(standardDeduction(br)(birthDate)));
      };
    };
  };
};
var mkBoundRegime = function(r) {
  return function(y) {
    return function(fs) {
      return function(ppe) {
        return function(uasd) {
          return function(a65) {
            return function(a65s) {
              return function(ob) {
                return function(qb) {
                  return {
                    regime: r,
                    year: y,
                    filingStatus: fs,
                    perPersonExemption: ppe,
                    unadjustedStandardDeduction: uasd,
                    adjustmentWhenOver65: a65,
                    adjustmentWhenOver65AndSingle: a65s,
                    ordinaryBrackets: ob,
                    qualifiedBrackets: qb
                  };
                };
              };
            };
          };
        };
      };
    };
  };
};
var withEstimatedNetInflationFactor = function(futureYear) {
  return function(netInflationFactor) {
    return function(v) {
      return mkBoundRegime(v.regime)(futureYear)(v.filingStatus)(mul3(v.perPersonExemption)(netInflationFactor))(mul3(v.unadjustedStandardDeduction)(netInflationFactor))(mul3(v.adjustmentWhenOver65)(netInflationFactor))(mul3(v.adjustmentWhenOver65AndSingle)(netInflationFactor))(inflateThresholds2(netInflationFactor)(v.ordinaryBrackets))(inflateThresholds3(netInflationFactor)(v.qualifiedBrackets));
    };
  };
};
var boundRegimeForKnownYear = function(y) {
  return function(fs) {
    var yvs = unsafeValuesForYear(y);
    return {
      regime: yvs.regime,
      year: y,
      filingStatus: fs,
      perPersonExemption: yvs.perPersonExemption,
      unadjustedStandardDeduction: yvs.unadjustedStandardDeduction(fs),
      adjustmentWhenOver65: yvs.adjustmentWhenOver65,
      adjustmentWhenOver65AndSingle: yvs.adjustmentWhenOver65AndSingle,
      ordinaryBrackets: yvs.ordinaryBrackets(fs),
      qualifiedBrackets: yvs.qualifiedBrackets(fs)
    };
  };
};
var boundRegimeForFutureYear = function(r) {
  return function(y) {
    return function(annualInflationFactor) {
      return function(fs) {
        var v = function() {
          var $66 = yearIsFuture(y);
          if ($66) {
            return unit;
          }
          ;
          return unsafeThrow("Year must be in the future: " + show5(y));
        }();
        var baseValues = mostRecentForRegime(r);
        var baseYear = fromEnum4(baseValues.year);
        var yearsWithInflation = range2(baseYear + 1 | 0)(fromEnum4(y));
        var inflationFactors = bind4(yearsWithInflation)(function(ywi) {
          var factor = fromMaybe(annualInflationFactor)(averageThresholdChangeOverPrevious(unsafeMakeYear(ywi)));
          return pure3(factor);
        });
        var netInflationFactor = foldl5(function(a) {
          return function(b) {
            return a * b;
          };
        })(1)(inflationFactors);
        var baseRegime = boundRegimeForKnownYear(baseValues.year)(fs);
        return withEstimatedNetInflationFactor(y)(netInflationFactor)(baseRegime);
      };
    };
  };
};

// output/Federal.TaxFunctions/index.js
var append4 = /* @__PURE__ */ append(semigroupTaxableIncome);
var taxDueOnQualifiedIncome = function(brackets) {
  return function(taxableOrdinaryIncome) {
    return function(qualifiedIncome) {
      var taxFunction2 = taxFunctionFor2(brackets);
      var taxOnBoth = taxFunction2(append4(taxableOrdinaryIncome)(qualifiedIncome));
      var taxOnOrdinary = taxFunction2(taxableOrdinaryIncome);
      return reduceBy(taxOnBoth)(taxOnOrdinary);
    };
  };
};
var taxDueOnOrdinaryIncome = taxFunctionFor;

// output/Federal.TaxableSocialSecurity/index.js
var makeFromInt10 = /* @__PURE__ */ makeFromInt(hasMakeFromIntIncome);
var mul4 = /* @__PURE__ */ mul2(hasMulIncome);
var min3 = /* @__PURE__ */ min(ordIncome);
var amountOverThreshold3 = /* @__PURE__ */ amountOverThreshold(hasAmountOverThresholdInc);
var append5 = /* @__PURE__ */ append(semigroupIncome);
var makeFromInt1 = /* @__PURE__ */ makeFromInt(hasMakeFromIntIncomeThres);
var fromEnum5 = /* @__PURE__ */ fromEnum(boundedEnumYear);
var amountTaxable = function(filingStatus) {
  return function(ssBenefits) {
    return function(relevantIncome) {
      var f = function(combinedIncome2) {
        return function(v) {
          if (isBelow(combinedIncome2)(v.value0)) {
            return makeFromInt10(0);
          }
          ;
          if (isBelow(combinedIncome2)(v.value1)) {
            var maxSocSecTaxable = mul4(ssBenefits)(0.5);
            return min3(mul4(amountOverThreshold3(combinedIncome2)(v.value0))(0.5))(maxSocSecTaxable);
          }
          ;
          if (true) {
            var halfMiddleBracketWidth = divInt(thresholdDifference(v.value1)(v.value0))(2);
            var maxSocSecTaxable = mul4(ssBenefits)(0.85);
            return min3(append5(taxableAsIncome(halfMiddleBracketWidth))(mul4(amountOverThreshold3(combinedIncome2)(v.value1))(0.85)))(maxSocSecTaxable);
          }
          ;
          throw new Error("Failed pattern match at Federal.TaxableSocialSecurity (line 49, column 3 - line 49, column 73): " + [combinedIncome2.constructor.name, v.constructor.name]);
        };
      };
      var lowThreshold = makeFromInt1(function() {
        if (filingStatus instanceof Married) {
          return 32e3;
        }
        ;
        if (filingStatus instanceof HeadOfHousehold) {
          return 25e3;
        }
        ;
        if (filingStatus instanceof Single) {
          return 25e3;
        }
        ;
        throw new Error("Failed pattern match at Federal.TaxableSocialSecurity (line 30, column 9 - line 33, column 26): " + [filingStatus.constructor.name]);
      }());
      var highThreshold = makeFromInt1(function() {
        if (filingStatus instanceof Married) {
          return 44e3;
        }
        ;
        if (filingStatus instanceof HeadOfHousehold) {
          return 34e3;
        }
        ;
        if (filingStatus instanceof Single) {
          return 34e3;
        }
        ;
        throw new Error("Failed pattern match at Federal.TaxableSocialSecurity (line 38, column 9 - line 41, column 26): " + [filingStatus.constructor.name]);
      }());
      var combinedIncome = append5(relevantIncome)(mul4(ssBenefits)(0.5));
      return f(combinedIncome)(new Tuple(lowThreshold, highThreshold));
    };
  };
};
var amountTaxableInflationAdjusted = function(year) {
  return function(filingStatus) {
    return function(ssBenefits) {
      return function(relevantIncome) {
        var unadjusted = amountTaxable(filingStatus)(ssBenefits)(relevantIncome);
        var adjustmentFactor = 1 + 0.03 * toNumber(fromEnum5(year) - 2021 | 0);
        var adjusted = mul4(unadjusted)(adjustmentFactor);
        return min3(adjusted)(mul4(ssBenefits)(0.85));
      };
    };
  };
};

// output/Federal.Calculator/index.js
var show6 = /* @__PURE__ */ show(showIncome);
var show1 = /* @__PURE__ */ show(showDeduction);
var show22 = /* @__PURE__ */ show(showTaxableIncome);
var show32 = /* @__PURE__ */ show(showTaxPayable);
var append6 = /* @__PURE__ */ append(semigroupTaxPayable);
var append12 = /* @__PURE__ */ append(semigroupIncome);
var resultsAsTable = function(v) {
  return [["ssRelevantOtherIncome: ", show6(v.ssRelevantOtherIncome)], ["taxableSocSec: ", show6(v.taxableSocSec)], ["finalStandardDeduction: ", show1(v.finalStandardDeduction)], ["finalNetDeduction: ", show1(v.finalNetDeduction)], ["taxableOrdinaryIncome: ", show22(v.taxableOrdinaryIncome)], ["taxOnOrdinaryIncome: ", show32(v.taxOnOrdinaryIncome)], ["taxOnQualifiedIncome: ", show32(v.taxOnQualifiedIncome)], ["totalTaxDue: ", show32(append6(v.taxOnOrdinaryIncome)(v.taxOnQualifiedIncome))]];
};
var makeCalculator = function(br) {
  return function(birthDate) {
    return function(personalExemptions) {
      return function(socSec) {
        return function(ordinaryIncome) {
          return function(qualifiedIncome) {
            return function(itemized) {
              var ssRelevantOtherIncome = append12(ordinaryIncome)(qualifiedIncome);
              var taxableSocSec = amountTaxable(br.filingStatus)(socSec)(ssRelevantOtherIncome);
              var netDeds = netDeduction(br)(birthDate)(personalExemptions)(itemized);
              var taxableOrdinaryIncome = applyDeductions(append12(taxableSocSec)(ordinaryIncome))(netDeds);
              var taxOnOrdinaryIncome = taxDueOnOrdinaryIncome(br.ordinaryBrackets)(taxableOrdinaryIncome);
              var taxOnQualifiedIncome = taxDueOnQualifiedIncome(br.qualifiedBrackets)(taxableOrdinaryIncome)(asTaxable(qualifiedIncome));
              return {
                boundRegime: br,
                ssRelevantOtherIncome,
                taxableSocSec,
                finalStandardDeduction: standardDeduction(br)(birthDate),
                finalPersonalExemptionDeduction: personalExemptionDeduction(br)(personalExemptions),
                finalNetDeduction: netDeds,
                taxableOrdinaryIncome,
                taxOnOrdinaryIncome,
                taxOnQualifiedIncome
              };
            };
          };
        };
      };
    };
  };
};
var taxResultsForFutureYear = function(reg) {
  return function(futureYear) {
    return function(estimate) {
      return function(filingStatus) {
        return function(birthDate) {
          return function(personalExemptions) {
            return function(socSec) {
              return function(ordinaryIncome) {
                return function(qualifiedIncome) {
                  return function(itemized) {
                    var boundRegime = boundRegimeForFutureYear(reg)(futureYear)(estimate)(filingStatus);
                    var calculator = makeCalculator(boundRegime)(birthDate)(personalExemptions);
                    return calculator(socSec)(ordinaryIncome)(qualifiedIncome)(itemized);
                  };
                };
              };
            };
          };
        };
      };
    };
  };
};
var taxDueForFutureYear = function(regime) {
  return function(futureYear) {
    return function(inflationEstimate) {
      return function(filingStatus) {
        return function(birthDate) {
          return function(personalExemptions) {
            return function(socSec) {
              return function(ordinaryIncome) {
                return function(qualifiedIncome) {
                  return function(itemized) {
                    var v = taxResultsForFutureYear(regime)(futureYear)(inflationEstimate)(filingStatus)(birthDate)(personalExemptions)(socSec)(ordinaryIncome)(qualifiedIncome)(itemized);
                    return append6(v.taxOnOrdinaryIncome)(v.taxOnQualifiedIncome);
                  };
                };
              };
            };
          };
        };
      };
    };
  };
};
var taxResultsForFutureYearAsTable = function(reg) {
  return function(futureYear) {
    return function(estimate) {
      return function(filingStatus) {
        return function(birthDate) {
          return function(personalExemptions) {
            return function(socSec) {
              return function(ordinaryIncome) {
                return function(qualifiedIncome) {
                  return function(itemized) {
                    return resultsAsTable(taxResultsForFutureYear(reg)(futureYear)(estimate)(filingStatus)(birthDate)(personalExemptions)(socSec)(ordinaryIncome)(qualifiedIncome)(itemized));
                  };
                };
              };
            };
          };
        };
      };
    };
  };
};
var taxResultsForKnownYear = function(year) {
  return function(filingStatus) {
    return function(birthDate) {
      return function(personalExemptions) {
        return function(socSec) {
          return function(ordinaryIncome) {
            return function(qualifiedIncome) {
              return function(itemized) {
                var boundRegime = boundRegimeForKnownYear(year)(filingStatus);
                var calculator = makeCalculator(boundRegime)(birthDate)(personalExemptions);
                return calculator(socSec)(ordinaryIncome)(qualifiedIncome)(itemized);
              };
            };
          };
        };
      };
    };
  };
};
var taxDueForKnownYear = function(year) {
  return function(filingStatus) {
    return function(birthDate) {
      return function(personalExemptions) {
        return function(socSec) {
          return function(ordinaryIncome) {
            return function(qualifiedIncome) {
              return function(itemized) {
                var v = taxResultsForKnownYear(year)(filingStatus)(birthDate)(personalExemptions)(socSec)(ordinaryIncome)(qualifiedIncome)(itemized);
                return append6(v.taxOnOrdinaryIncome)(v.taxOnQualifiedIncome);
              };
            };
          };
        };
      };
    };
  };
};
var taxResultsForKnownYearAsTable = function(year) {
  return function(filingStatus) {
    return function(birthDate) {
      return function(personalExemptions) {
        return function(socSec) {
          return function(ordinaryIncome) {
            return function(qualifiedIncome) {
              return function(itemized) {
                return resultsAsTable(taxResultsForKnownYear(year)(filingStatus)(birthDate)(personalExemptions)(socSec)(ordinaryIncome)(qualifiedIncome)(itemized));
              };
            };
          };
        };
      };
    };
  };
};

// output/Federal.RMDs/index.js
var bind5 = /* @__PURE__ */ bind(bindMaybe);
var lookup3 = /* @__PURE__ */ lookup(ordAge);
var fromJust12 = /* @__PURE__ */ fromJust();
var distributionPeriods = /* @__PURE__ */ function() {
  return fromFoldable2(ordAge)(foldableArray)([new Tuple(70, 27.4), new Tuple(71, 26.5), new Tuple(72, 25.6), new Tuple(73, 24.7), new Tuple(74, 23.8), new Tuple(75, 22.9), new Tuple(76, 22), new Tuple(77, 21.2), new Tuple(78, 20.3), new Tuple(79, 19.5), new Tuple(80, 18.7), new Tuple(81, 17.9), new Tuple(82, 17.1), new Tuple(83, 16.3), new Tuple(84, 15.5), new Tuple(85, 14.8), new Tuple(86, 14.1), new Tuple(87, 13.4), new Tuple(88, 12.7), new Tuple(89, 12), new Tuple(90, 11.4), new Tuple(91, 10.8), new Tuple(92, 10.2), new Tuple(93, 9.6), new Tuple(94, 9.1), new Tuple(95, 8.6), new Tuple(96, 8.1), new Tuple(97, 7.6), new Tuple(98, 7.1), new Tuple(99, 6.7), new Tuple(100, 6.3), new Tuple(101, 5.9), new Tuple(102, 5.5), new Tuple(103, 5.2), new Tuple(104, 4.9), new Tuple(105, 4.5), new Tuple(106, 4.2), new Tuple(107, 3.9), new Tuple(108, 3.7), new Tuple(109, 3.4), new Tuple(110, 3.1), new Tuple(111, 2.9), new Tuple(112, 2.6), new Tuple(113, 2.4), new Tuple(114, 2.1)]);
}();
var rmdFractionForAge = function(age) {
  return bind5(lookup3(age)(distributionPeriods))(function(distributionPeriod) {
    return new Just(1 / distributionPeriod);
  });
};
var unsafeRmdFractionForAge = function(age) {
  return fromJust12(rmdFractionForAge(age));
};

// output/StateMA.StateMATaxRate/index.js
var i3 = /* @__PURE__ */ i(/* @__PURE__ */ interpStringFunction(/* @__PURE__ */ interpStringFunction(interpString)));
var show7 = /* @__PURE__ */ show(showNumber);
var ordStateMATaxRate = ordNumber;
var mkStateMATaxRate = function(d) {
  if (d < 0) {
    return unsafeThrow(i3("Invalid StaateMARaxRate ")(show7(d)));
  }
  ;
  if (d > 0.9) {
    return unsafeThrow(i3("Invalid StaateMARaxRate ")(show7(d)));
  }
  ;
  if (otherwise) {
    return d;
  }
  ;
  throw new Error("Failed pattern match at StateMA.StateMATaxRate (line 16, column 1 - line 16, column 45): " + [d.constructor.name]);
};
var taxRateStateMATaxRate = {
  zeroRate: /* @__PURE__ */ mkStateMATaxRate(0),
  rateToNumber: function(v) {
    return v;
  },
  absoluteDifference: function(v) {
    return function(v1) {
      return abs(v - v1);
    };
  },
  Ord0: function() {
    return ordStateMATaxRate;
  }
};

// output/StateMA.Calculator/index.js
var fromEnum6 = /* @__PURE__ */ fromEnum(boundedEnumYear);
var makeFromInt11 = /* @__PURE__ */ makeFromInt(hasMakeFromIntDeduction);
var fold4 = /* @__PURE__ */ fold2(monoidDeduction);
var taxRate = function(year) {
  var selectRate = function(i4) {
    if (i4 === 2020) {
      return 0.05;
    }
    ;
    if (i4 === 2019) {
      return 0.0505;
    }
    ;
    if (i4 === 2018) {
      return 0.051;
    }
    ;
    if (i4 < 2018) {
      return 0.051;
    }
    ;
    if (otherwise) {
      return 0.05;
    }
    ;
    throw new Error("Failed pattern match at StateMA.Calculator (line 19, column 3 - line 24, column 23): " + [i4.constructor.name]);
  };
  return mkStateMATaxRate(selectRate(fromEnum6(year)));
};
var taxFunction = /* @__PURE__ */ function() {
  var $14 = flatTaxFunction(taxRateStateMATaxRate);
  return function($15) {
    return $14(taxRate($15));
  };
}();
var personalExemptionFor = function(v) {
  return function(v1) {
    if (v1 instanceof Married) {
      return makeFromInt11(8800);
    }
    ;
    if (v1 instanceof HeadOfHousehold) {
      return makeFromInt11(6800);
    }
    ;
    if (v1 instanceof Single) {
      return makeFromInt11(4400);
    }
    ;
    throw new Error("Failed pattern match at StateMA.Calculator (line 29, column 1 - line 29, column 58): " + [v.constructor.name, v1.constructor.name]);
  };
};
var taxDue = function(year) {
  return function(filingStatus) {
    return function(bd) {
      return function(dependents) {
        return function(maGrossIncome) {
          var personalExemption = personalExemptionFor(year)(filingStatus);
          var dependentsExemption = makeFromInt11(1e3 * dependents | 0);
          var ageExemption = makeFromInt11(function() {
            var $13 = isAge65OrOlder(bd)(year);
            if ($13) {
              return 700;
            }
            ;
            return 0;
          }());
          var deductions = fold4([personalExemption, ageExemption, dependentsExemption]);
          var taxableIncome = applyDeductions(maGrossIncome)(deductions);
          return taxFunction(year)(taxableIncome);
        };
      };
    };
  };
};

// output/GoogleSheetModule/index.js
var maStateTaxRate = taxRate;
var maStateTaxDue = taxDue;
// JavaScript shim for Purescript code for Taxes In Retirement library.
// Note: This file must be loaded AFTER the code compiled from Purescript.

// TODO: validate params in the shim and provide better error messages when invalid.
// TODO: provide a way to return the results record.

/**
 * Standard deduction for a known year.
 * Example: TIR_STD_DEDUCTION(2022, "HeadOfHousehold", 1955-10-02)
 *
 * @param {number} year the tax regime to use, one of "Trump", "PreTrump"
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @returns {number} The standard deduction
 * @customfunction
 */
function TIR_STD_DEDUCTION(year, filingStatus, birthDate) {
  const br = bindRegimeForKnownYear(year, filingStatus);  
  const psBirthDate = toPurescriptDate(birthDate);

  return standardDeduction(br)(psBirthDate);
}

/**
 * Standard deduction for a future year.
 * Example: TIR_FUTURE_STD_DEDUCTION("Trump", 3%, 2030, "HeadOfHousehold", 1955-10-02)
 *
 * @param {string} regime  the tax regime to use, one of "Trump", "PreTrump"
 * @param {number} year a year in the future, after the current year
 * @param {number} bracketInflationRate estimate of future tax bracket inflation, e.g. 2%
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @returns {number} The standard deduction
 * @customfunction
 */
function TIR_FUTURE_STD_DEDUCTION(regime, year, bracketInflationRate, filingStatus, birthDate) {
  const br = bindRegimeForFutureYear(regime, year, bracketInflationRate, filingStatus);  
  const psBirthDate = toPurescriptDate(birthDate);

  return standardDeduction(br)(psBirthDate);
}

/**
 * Width of an ordinary income tax bracket for a known year.
 * Example: TIR_ORDINARY_BRACKET_WIDTH(2022, "Single", 10)
 * 
 * @param {number} year a year between 2016 and tthe current year
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {number} ordinaryRatePercentage rate for a tax bracket e.g. 22
 * @returns {number} The width of the specified ordinary income tax bracket.
 * @customfunction
 */
function TIR_ORDINARY_BRACKET_WIDTH(year, filingStatus, ordinaryRatePercentage) {
  const br = bindRegimeForKnownYear(year, filingStatus);  
  const rate = ordinaryRatePercentage / 100.0;

  return ordinaryIncomeBracketWidth(br.ordinaryBrackets)(rate);
}

/**
 * Width of an ordinary income tax bracket for a future year.
 * Example: TIR_FUTURE_ORDINARY_BRACKET_WIDTH("PreTrump", 2030, "HeadOfHousehold", 10)
 * 
 * @param {string} regime the tax regime to use, one of "Trump", "PreTrump"
 * @param {number} year a year in the future, after the current year
 * @param {number} bracketInflationRate estimate of future tax bracket inflation, e.g. 2%
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {number} ordinaryRatePercentage rate for a tax bracket e.g. 22
 * @returns {number} The width of the specified ordinary income bracket.
 * @customfunction
 */
function TIR_FUTURE_ORDINARY_BRACKET_WIDTH(regime, year, bracketInflationRate, filingStatus, ordinaryRatePercentage) {
  const br = bindRegimeForFutureYear(regime, year, bracketInflationRate, filingStatus);  
  const rate = ordinaryRatePercentage / 100.0;

  return ordinaryIncomeBracketWidth(br.ordinaryBrackets)(rate);
}


/**
 * Threshold above which long term capital gains are taxed, for a known year.
 * Example: TIR_LTCG_TAX_START(2022, "HeadOfHousehold")
 * 
 * @param {number} year a year between 2016 and tthe current year
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @returns {number} the end of the zero tax rate on qualified investment income
 * @customfunction
 */
function TIR_LTCG_TAX_START(year, filingStatus) {
  const br = bindRegimeForKnownYear(year, filingStatus);  
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * Threshold above which long term capital gains are taxed, for a future year
 * Example: TIR_FUTURE_LTCG_TAX_START("PreTrump", 2027, 3.4%, "HeadOfHousehold")
 * 
 * @param {string} regime the tax regime to use, one of "Trump", "PreTrump"
 * @param {number} year a year in the future, after the current year
 * @param {number} bracketInflationRate estimate of future tax bracket inflation, e.g. 2%
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @returns {number} the end of the zero tax rate on qualified investment income
 * @customfunction
 */
function TIR_FUTURE_LTCG_TAX_START(regime, year, bracketInflationRate, filingStatus) {
  const br = bindRegimeForFutureYear(regime, year, bracketInflationRate, filingStatus);  
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * The RMD fraction for a given age.
 * Example: TIR_RMD_FRACTION_FOR_AGE(76)
 * 
 * @param {number} age age of the taxpayer
 * @returns {number} the RMD fraction
 * @customfunction
 */
function TIR_RMD_FRACTION_FOR_AGE(age) {
  return unsafeRmdFractionForAge(age);
}

/**
 * The Federal tax due for a known year.
 * Example: TIR_FEDERAL_TAX_DUE(2022, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {number} year a year between 2016 and tthe current year
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @param {number} personalExemptions self plus dependents, only relevant in a PreTrump year
 * @param {number} socSec Social Security benefits received
 * @param {number} ordinaryIncomeNonSS ordinary income excluding Social Security
 * @param {number} qualifiedIncome qualified dividends and long term capital gains
 * @param {number} itemizedDeductions total of any itemized deductions
 * @returns {number} the Federal tax due
 * @customfunction
 */
function TIR_FEDERAL_TAX_DUE(
  year, 
  filingStatus, 
  birthDate,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const psYear = unsafeMakeYear(year);
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  return taxDueForKnownYear(
    psYear)(
    psFilingStatus)(
    psBirthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}

 function TIR_FEDERAL_TAX_RESULTS(
  year, 
  filingStatus, 
  birthDate,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const psYear = unsafeMakeYear(year);
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  const res = taxResultsForKnownYearAsTable(
    psYear)(
    psFilingStatus)(
    psBirthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);

  return res;
}


/**
 * The Federal tax due for a future year.
 * Example: TIR_FUTURE_FEDERAL_TAX_DUE("Trump", 2023, 0.034, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {string} regime the tax regime to use, one of "Trump", "PreTrump"
 * @param {number} year a year in the future, after the current year
 * @param {number} bracketInflationRate estimate of future tax bracket inflation, e.g. 2%
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @param {number} personalExemptions self plus dependents, only relevant in a PreTrump year
 * @param {number} socSec Social Security benefits received
 * @param {number} ordinaryIncomeNonSS  ordinary income excluding Social Security
 * @param {number} qualifiedIncome qualified dividends and long term capital gains
 * @param {number} itemizedDeductions total of any itemized deductions
 * @returns {number} the Federal tax due
 * @customfunction
 */
function TIR_FUTURE_FEDERAL_TAX_DUE(
  regime,
  year, 
  bracketInflationRate,
  filingStatus, 
  birthDate,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const psRegime = unsafeReadRegime(regime);
  const psYear = unsafeMakeYear(year);
  const inflationFactorEstimate = 1.0 + bracketInflationRate;
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  return taxDueForFutureYear(
    psRegime)(
    psYear)(
    inflationFactorEstimate)(
    psFilingStatus)(
    psBirthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}


/**
 * The marginal tax rate for a known year.
 * Example: TIR_FEDERAL_TAX_SLOPE(2022, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {number} year a year between 2016 and tthe current year
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @param {number} personalExemptions self plus dependents, only relevant in a PreTrump year
 * @param {number} socSec Social Security benefits received
 * @param {number} ordinaryIncomeNonSS  ordinary income excluding Social Security
 * @param {number} qualifiedIncome qualified dividends and long term capital gains
 * @param {number} itemizedDeductions total of any itemized deductions
 * @returns {number} the marginal tax rate.
 * @customfunction
 */
function TIR_FEDERAL_TAX_SLOPE(
  year, 
  filingStatus, 
  birthDate, 
  personalExemptions,
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
    const deltaX = 1000.0

  const federalTaxAtStart = TIR_FEDERAL_TAX_DUE(
    year, 
    filingStatus, 
    birthDate,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome,
    itemizedDeductions
  );
  const federalTaxAtEnd = TIR_FEDERAL_TAX_DUE(
    year, 
    filingStatus, 
    birthDate,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS + deltaX, 
    qualifiedIncome,
    itemizedDeductions
  );
  const deltaY = (federalTaxAtEnd - federalTaxAtStart);

  return deltaY/deltaX;
}

/**
 * The marginal tax rate for a future year.
 * Example: TIR_FUTURE_FEDERAL_TAX_SLOPE("Trump", 2023, 0.034, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {string} regime the tax regime to use, one of "Trump", "PreTrump"
 * @param {number} year a year in the future, after the current year
 * @param {number} bracketInflationRate estimate of future tax bracket inflation, e.g. 2%
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @param {number} personalExemptions self plus dependents, only relevant in a PreTrump year
 * @param {number} socSec Social Security benefits received
 * @param {number} ordinaryIncomeNonSS  ordinary income excluding Social Security
 * @param {number} qualifiedIncome qualified dividends and long term capital gains
 * @param {number} itemizedDeductions total of any itemized deductions
 * @returns the marginal tax rate.
 * @customfunction
 */
function TIR_FUTURE_FEDERAL_TAX_SLOPE(
  regime,
  year, 
  bracketInflationRate,
  filingStatus, 
  birthDate, 
  personalExemptions,
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const deltaX = 1000.0;

  const federalTaxAtStart = TIR_FUTURE_FEDERAL_TAX_DUE(
    regime,
    year, 
    bracketInflationRate,
    filingStatus, 
    birthDate,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome,
    itemizedDeductions
  );
  const federalTaxAtEnd = TIR_FUTURE_FEDERAL_TAX_DUE(
    regime,
    year, 
    bracketInflationRate,
    filingStatus, 
    birthDate,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS + deltaX, 
    qualifiedIncome,
    itemizedDeductions
  );
  const deltaY = (federalTaxAtEnd - federalTaxAtStart);

  return deltaY/deltaX;
}

/**
 * The amount of Social Security income that is taxable.
 * Example: TIR_TAXABLE_SOCIAL_SECURITY("HeadOfHousehold", 20000, 52000)
 * 
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {number} ssRelevantOtherIncome all income apart from Social Security
 * @param {number} socSec Social Security benefits received
 * @returns {number} the amount of Social Security income that is taxable
 * @customfunction
 */
function TIR_TAXABLE_SOCIAL_SECURITY(filingStatus, ssRelevantOtherIncome, socSec) {
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);

  return amountTaxable(psFilingStatus)(socSec)(ssRelevantOtherIncome);
}

/***
 * The MA state income tax due.
 * Example: TIR_MA_STATE_TAX_DUE(2022, "Married", 1955-10-02, 0, 130000)
 * 
 * @param {number} year a year between 2016 and tthe current year
 * @param {string} filingStatus one of "Single", "HeadOfHousehold", "Married"
 * @param {object} birthDate tax payer's date of birth
 * @param {number} dependents 
 * @param {number} massachusettsGrossIncome 
 * @returns {number} the MA state income tax due.
 * @customfunction
 */
function TIR_MA_STATE_TAX_DUE(
  year, 
  filingStatus, 
  birthDate, 
  dependents, 
  massachusettsGrossIncome
  ) {
  const psYear = unsafeMakeYear(year);
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  return maStateTaxDue(
    psYear)(
    psFilingStatus)(
    psBirthDate)(
    dependents)(
    massachusettsGrossIncome);
}

function bindRegimeForKnownYear(yearAsNumber, filingStatusName) {
  const psFilingStatus = unsafeReadFilingStatus(filingStatusName);
  const psYear = unsafeMakeYear(yearAsNumber);

  return boundRegimeForKnownYear(psYear)(psFilingStatus);
}

function bindRegimeForFutureYear(regimeName, yearAsNumber, bracketInflationRate, filingStatusName) {
  const psRegime = unsafeReadRegime(regimeName);
  const psYear = unsafeMakeYear(yearAsNumber);
  const inflationFactorEstimate = 1.0 + bracketInflationRate;
  const psFilingStatus = unsafeReadFilingStatus(filingStatusName);
  
  return boundRegimeForFutureYear(psRegime)(psYear)(inflationFactorEstimate)(psFilingStatus);  
}

function toPurescriptDate(dateObject) {
  if (typeof(dateObject) != "object")
    throw "Date object required";
  if (! dateObject instanceof Date)
    throw "Date object required";
  const year = 1900 + dateObject.getYear();
  const month = 1 + dateObject.getMonth();
  const dayOfMonth = dateObject.getDate();
  return unsafeMakeDate(year)(month)(dayOfMonth);
}
