module bbp_trace

open util/ordering[Time]

enum TripState { Idle, Recording, Recorded }

sig Time {}

sig User {}
sig BikePath {}

sig Trip {
  user: one User,
  path: one BikePath,
  state: Time -> one TripState
}

fun st[t: Trip, tm: Time]: one TripState {
  t.state[tm]
}

fact InitialState {
  all t: Trip | st[t, first] = Idle
}

fact TripLifecycle {
  all t: Trip, tm: Time - last | {
    let s  = st[t, tm] |
    let s2 = st[t, tm.next] |
      (s = Idle      implies (s2 = Idle or s2 = Recording)) and
      (s = Recording implies (s2 = Recording or s2 = Recorded)) and
      (s = Recorded  implies (s2 = Recorded))
  }
}

assert RecordedImpliesWasRecording {
  all t: Trip |
    (some tm: Time | st[t, tm] = Recorded) implies
    (some tm: Time | st[t, tm] = Recording)
}

check RecordedImpliesWasRecording for 6 but exactly 4 Time

pred EventuallyRecorded {
  some t: Trip | st[t, last] = Recorded
}

run EventuallyRecorded for 6 but exactly 4 Time
