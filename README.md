# Scrapes

Scrapes is an iOS and a Mac Catalyst app that allows you to see and copy your
Kindle highlights nad notes in a clean and simple UI.

## TODO

- [x] Loading View when `viewModel.isLoading`
- [ ] Fetch Notes when a book is selected
- [ ] Notes have pagination on them, so we should check the cursor value.
- [x] Show an error overlay when an error occures
- [x] Figure out a way to do incremental syncs and persist books
  in SwiftData
    That's a very much tomorrow's problem. Books have `modifiedAt` on them,
    so we can check if a book's modification date is updated, and do a full
    sync of it's notes.
- [ ] Xcode Cloud setup
- [ ] TestFlight build
- [ ] Introduction article

