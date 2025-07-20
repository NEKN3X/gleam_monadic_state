import applicative
import apply
import functor

pub type Bind(a) {
  Bind(apply.Apply(a))
}

/// 値をBindでラップします
pub fn pure(value: a) -> Bind(a) {
  Bind(apply.Apply(functor.Functor(value)))
}

/// ApplicativeからBindを作成します
pub fn from_applicative(app: applicative.Applicative(a)) -> Bind(a) {
  let apply_val = applicative.to_apply(app)
  Bind(apply_val)
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
