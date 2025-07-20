import apply
import functor

pub type Applicative(a) {
  Applicative(apply.Apply(a))
}

pub fn pure(x: a) -> Applicative(a) {
  Applicative(apply.Apply(functor.Functor(x)))
}

/// BindからApplicativeを作成します
pub fn from_bind(bind_apply: apply.Apply(a)) -> Applicative(a) {
  Applicative(bind_apply)
}

pub fn to_apply(self: Applicative(a)) -> apply.Apply(a) {
  case self {
    Applicative(apply.Apply(functor.Functor(x))) ->
      apply.Apply(functor.Functor(x))
  }
}
