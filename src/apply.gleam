import functor

pub type Apply(a) {
  Apply(functor.Functor(a))
}

pub fn apply(apply: Apply(a), f: Apply(fn(a) -> b)) -> Apply(b) {
  case apply, f {
    Apply(x), Apply(functor.Functor(g)) -> Apply(functor.fmap(x, g))
  }
}

pub fn to_functor(self: Apply(a)) -> functor.Functor(a) {
  case self {
    Apply(functor.Functor(x)) -> functor.Functor(x)
  }
}
