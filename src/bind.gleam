import apply
import functor

pub type Bind(a) {
  Bind(apply.Apply(a))
}

pub fn bind(bind: Bind(a), f: fn(a) -> Bind(b)) -> Bind(b) {
  case bind {
    Bind(apply.Apply(functor.Functor(x))) -> f(x)
  }
}

pub fn to_apply(self: Bind(a)) -> apply.Apply(a) {
  case self {
    Bind(apply.Apply(functor.Functor(x))) -> apply.Apply(functor.Functor(x))
  }
}
