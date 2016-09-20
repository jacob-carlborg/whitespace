# Whitespace

Whitespace is a tool for validating and stripping trailing whitespace.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whitespace'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whitespace

## Usage

The `--ignored-paths` flag works for both the `validate` and the `strip`.
It's used to specify a list of paths that will be ignored. By default the
following paths are ignored: `.git`, `.svn` and `.hg`.

### Validate trailing whitespace

The `validate` command will check all files in the given path (or the current
directory) for trailing whitespace. If any trailing whitespace is found, the
filename, line number and line content will be printed, with the trailing
whitespace highlighted.

```bash
echo "foo " > foo.txt
ws validate
```

Will print something like:

```
./foo.txt:1:foo
```

### Strip trailing whitespace

The `strip` command will strip/remove trailing whitespace in all files in the
given path (or the current directory).

```bash
echo "foo " > foo.txt
ws strip
grep -E ' +$' foo.txt
```

The above `grep` command will not match anything.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `./travis.sh` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment. To run the actual command,
run `exe/ws`.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jacob-carlborg/whitespace.
