# AOC 2021: Ruby 3, Sorbet, RSpec

## Initial Setup
- Install ruby 3.0.3, `bundler` gem
- `bundle install`

## Run

### Run a level:
```
bundle exec ruby app.rb 1 a
```

### Run specs:
```
bundle exec rspec spec/1_a_spec.rb
```

### Check types with sorbet:
```
bundle exec srb tc 1_a.rb
```

### Linting:
```
bundle exec rubocop 1_a.rb
```

## Notes
The daily challenges here are solved independently in single files: `1_a.rb`, `1_b.rb`, etc.  Due to this and conflicting namespaces, these files are required independently after selection by `app.rb`.  Additionally, sorbet type checking must be done to each file individually, otherwise it thinks classes are being redefined.
