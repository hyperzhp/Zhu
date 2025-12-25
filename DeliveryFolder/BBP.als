sig User {}
sig BikePath {}

sig Trip {
    user: one User,
    path: one BikePath
}

sig PathInformation {
    author: one User,
    path: one BikePath,
    visibility: one Visibility
}

enum Visibility {
    Private,
    Shared
}

run {} for 5
