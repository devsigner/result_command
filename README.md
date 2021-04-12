# Functionnal world with Result::Command

## What is SupperSimple::Command?
## Command partern ? Like SimpleCommand 
### not only
 
It's an object with very simple API based on its state like SimpleCommand:

- `.success?`
- `.failure?`

```ruby
o = MyCommand.call(:a)

o.success? # => true
o.failure? # => false
o.result # => :a
```

## But It's container, like Monad (Result)?!

Using Result::Command as an **atomiq object**. 
We can easily implement **Monad Result** with **Result::Command** and used it like a container:

```ruby
module Result
  class Result
    def self.inherited(subclass)
      subclass.prepend Command
      subclass.include Chainable
    end

    def call
      @content
    end
  end

  class Success < Result
  end

  class Params < Result
  end

  class Failure < Result
    def failure?
      true
    end

    def call
      errors.add(:result, :failure)
      super
    end
  end
end

Success[:a]
=> #<Success @content=:a, @called=true, @result=:a>

Success[:a].success? # => true
Success[:a].failure? # => false
Success[:a].result # => :a

Failure[:b]
=> #<Failure @content=:b, @called=true, @result=nil>

Failure[:b].success? # => false
Failure[:b].failure? # => true
Failure[:b].result # => :b

Result::Failure[42].with_errors(
  Result::Errors.build(
    source: 'test',
    details: { base: ['something went wrong'] }
  )
)
# => #<Result::Failure 
        @content=42, 
        @called=true, 
        @errors=#<Result::Errors @source="test", @errors={ base: ['something went wrong'] }>, 
        @result=42>
```

### Better, Faster, Stronger with **Chainable**!

Chainable add some chainable methods;

- `then` (or alias `|`)

```ruby
Result::Params[:h] | MyCommande | MySecondCommande
=> #<MaSecondCommande @params="h", @called=true, @result="hello">
```

```ruby
Result::Params[:h] | MyCommande | MyFaildCommand | MySecondCommande
=> #<MyFaildCommand @content="h", @called=true, @result="h">
```

with lambda

```ruby
Result::Params[:hello].
  then(->(input) { Result::Success[input.to_s] }).
  then(->(input) { Result::Success[input + ' world'] })
=> #<Result::Success @content="hello world", @called=true, @result="hello world">
```

```ruby
  Result::Params[{ user: { first_name: 'John', last_name: 'Dow' } }]
    .then(
      lambda { |input|
        response = MyClientApi.post('/users', payload: input)

        if response.status == :ok
          Result::Success[response.body]
        else
          Result::Failure[input].with_errors(
            Result::Errors.build(source: self, errors: response.body)
          )
        end
      }
    )
    .then(CreateUserLocaly)
```

### Command

wrap result after running call method

```ruby
cmd = MyCommand.call(args)

cmd.success? # => true | false
cmd.failure? # => true | false
```

##### Callback

use block and callback

- `on_success` yield Errors instance
- `on_falure` yield `result`

```ruby
MyCommand.call(args) do |cmd|
  cmd.on_success do |result|
    # do something
  end

  cmd.on_failure do |errors|
    # or do something else
  end
end
```

because chain of commands return Command instance, we can use callback :) 

```ruby
when_succeed = ->(result) { # do something with result }
when_fail = ->(errors) { # do something with error }

(Result::Params[:h] | MyCommande | MyFaildCommand | MySecondCommande).
  on_failure(&when_fail).
  on_success(&when_succeed)
```

or wrap by an other command

```ruby
class WrapCommands
  prepend Result::Command

  def initialize(input)
    @input = input
  end

  def call
    Params[@input].
      then(MyCommande).
      then(MyFaildCommand).
      then(MySecondCommande).
      on_failure(&when_fail).
      on_success(&when_succeed)
  end

  def when_succeed(result)
    # do something with result 
  end

  def when_fail(errors)
    # do something with error
    errors.merge(errors)
  end
end
```
