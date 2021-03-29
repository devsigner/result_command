# Functionnal world with SuperSimple::Command

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

Using SuperSimple::Command as an **atomiq object**. 
We can easily implement **Monad Result** with **SuperSimple::Command** and used it like a container:

```ruby
module SuperSimple
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
```

### Better, Faster, Stronger with **Chainable**!

Chainable add some chainable methods;

- them (|)
- bind

```ruby
Params[:h] | MyCommande | MySecondCommande
=> #<MaSecondCommande @params="h", @called=true, @result="hello">
```

```ruby
Params[:h] | MyCommande | MyFaildCommand | MySecondCommande
=> #<MyFaildCommand @content="h", @called=true, @result="h">
```
