import functor

pub type State(a) {
  State(a)
}

pub fn to_functor(self: State(a)) -> functor.Functor(a) {
  case self {
    State(x) -> functor.Functor(x)
  }
}
