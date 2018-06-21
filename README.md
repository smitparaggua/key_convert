# KeyConvert

[![Build Status](https://travis-ci.org/smitparaggua/key_convert.svg?branch=master)](https://travis-ci.org/smitparaggua/key_convert)
[![Coverage Status](https://coveralls.io/repos/github/smitparaggua/key_convert/badge.svg?branch=master)](https://coveralls.io/github/smitparaggua/key_convert?branch=master)

`KeyConvert` adds convenience methods for transforming keys in `Map`s.
Transformations are done recursively by default.

## Installation

The package can be installed by adding `key_convert` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:key_convert, "~> 0.2.0"}
  ]
end
```

## Basic Usage

### Snake Case

`snake_case` converts the keys into all lower case separated by an underscore.
`Atom` keys are converted into strings.

```elixir
KeyConvert.snake_case(%{
  contactInfo: %{emailAddress: "email@example.com"}
})
# %{"contact_info" => %{"email_address" => "email@example.com"}}
```

### Camelize

`camelize` converts the keys into camel-case. `Atom` keys are converted into
strings. It will retain the case of the first letter.

```elixir
KeyConvert.camelize(%{
  contact_info: %{email_address: "email@example.com"}
})
# %{"contactInfo" => %{"emailAddress" => "email@example.com"}}
```

### Rename

`rename` converts the keys via the `rename_map` which is used to
determine what keys are raplaced with. Keys that are not available
in the `rename_map` are unaffected.

```
KeyConvert.rename(
  %{amount: 500, currency: "PHP"},
  %{amount: :value}                # rename_map
)
# %{value: 500, currency: "PHP"}
```

### Convert

`convert` provides a way to transform keys based on a function supplied
by the user. The transformer function should be able to take a key as an input
and return a new key which will be used for the converted `Map`.

```elixir
# converter function that appends the string ".changed"
append_change = fn key -> key <> ".changed" end

KeyConvert.convert(%{"total_amount" => 500}, append_change)
# %{"total_amount.changed" => 500}
```
