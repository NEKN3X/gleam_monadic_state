import applicative
import bind

pub type Monad(a) {
  Monad(applicative.Applicative(a), bind.Bind(a))
}

pub fn to_bind(m: Monad(a)) -> bind.Bind(a) {
  case m {
    Monad(_, bind.Bind(b)) -> bind.Bind(b)
  }
}
