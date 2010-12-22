# Gimme

A very lightweight test double tool in ruby. Written to facilitate test-driving by 
getting out of the author's way and specifying only what matters.

You can read the (stale) documentation below or the (fresh) [gimme Cucumber features on Relish](http://relishapp.com/searls/gimme)

## Basics (or "What does it Gimme?" ... har.)

Gimme was (for the first five hours of its life) named "Tabula Rasa," to very clearly indicate that it generates blank slate test doubles that lack any initial coupling with the concepts associated with specific [test double](http://xunitpatterns.com/Test%20Double.html) subtypes like mocks/stubs/fakes/spies/proxies. 
But in the end, "gimme" was easier to type, and since I knew I'd need a method name that didn't conflict with `rspec-mock`'s `double()`, I renamed it. 

Gimme is merely an expression of the desire to write low-friction, low-specification tests that feel a little more like Mockito than existing ruby test double libraries. Gimme should do whatever it can to help you isolate your SUT from its dependencies and then get out of your way.

The few things it gives you:

* Natural arrange-act-assert flow — meaning that you can call `verify` after you've interacted with your system under test.
* No stringy/symbolic representations of methods — similar to [rr](https://github.com/btakita/rr), gimme uses the blank slate pattern and `method_missing` to allow for minimally terse stubs and verifications
* No stubbing or verifying methods the class doesn't respond to — the most valid criticism I've heard regarding test doubles is that they lie; test doubles that don't respond to messages that their real counterparts wouldn't understand lie a little less.
* No barking at you for not setting up an expectation on every invocation — verify exactly what matters to you in the context of what you're building; sometimes specifying the behavior of your SUT on a collaborator is significant, and sometimes it isn't.

## The Disclaimer

Gimme is still in early development. There isn't a gem for it yet, which means that to use it, you need to require `lib/gimme.rb`. Gimme is still a little light on features, but it may soon be robust enough to stand in for your current test double framework of choice. In addition to generating test doubles, stubbing methods, and verifying invocations, Gimme also supports argument matchers and captors which should be enough to suit the needs for most greenfield isolated unit tests/specs.

## Getting started

First, require gimme and include Gimme's top-level methods.

    require 'gimme'
    include Gimme

To create a test double, you'd pass in a class:

    double = gimme(Object)
     
Once you have your double, you can stub methods (but only methods that the given class will respond to):

    give(double).to_s { 'Pants' }
    double.to_s                         #=> 'Pants'
    
    give(double).equal?(:ninja) { true }
    give(double).equal?(:fruit) { false }    
    double.equal?(:ninja)               #=> true
    
You can also verify interactions with your double    

    double.equal?(:fruit)
    
    verify(double).equal?(:fruit)       # passes verification (read: does nothing)
    verify(double).equal?(:what_the)    # fails verification (raises a Gimme::VerifyFailedError)

You can also specify how many times a specific invocation should have occurred (defaults to 1):

    double.equal?(:fruit)
    double.equal?(:fruit)
    
    verify(double,2).equal?(:fruit)
    
### Matchers

Basic argument matchers are still being developed, but the goal will be to make custom matchers as easy-to-make as possible. To write a custom matcher it only needs to respond to `matches?(arg)`. 

**anything**

Replacing an argument with `anything` will instantiate a `Gimme::Matchers::Anything` matcher, which always returns true, regardless of what gets passed in.

    give(dog).walk_to(anything,5) { 'Park' }
    
    walk_to(3,5)          #=> 'Park'
    walk_to('pants',5)    #=> 'Park'
    walk_to(nil,5)        #=> 'Park'        
    walk_to(3,5.1)        #=> nil
        
Matchers can be used when both stubbing and verifying a method. To verify on anything, you could:

    dog.holler_at(true)
    
    verify(dog).holler_at(anything) #=> passes verification    
    
**is_a(class)**
**any(class)**
**boolean**
**numeric**

See the [cucumber feature for these matchers](http://relishapp.com/searls/gimme/stubbing-with-matchers)

### Argument Captors

An argument `Captor`, when paired with the `capture` matcher, is a valuable way for your test to get at the values that your SUT passes to its collaborators. Often, classes are responsible for building objects to be ingested by their collaborators but for which normal state verification would either be difficult or nonsensical. Argument captors should only be necessary sparingly for most types of applications, but they're a handy tool to have in the toolbox.

In cases like these, a captor can be used to "capture" the real argument value that the system under test passes its collaborator. This pseudocode provides an example:

    #arrange
    search_system = gimme(SearchSystem)
    sut = QueryExecutor.new(search_sytem)
    query_captor = Captor.new

    #act
    sut.submit_query_for_string("find dogs")
    
    #assert
    verify(search_system).execute(capture(query_captor))
    query_captor.value.table_name.should == "Dogs"

    
### Suppressing NoMethodError

Whenever you stub or verify a method against a test double, Gimme will first verify that the method can be found on the class being
doubled. Since the vast majority of methods can be verified in this way, this default behavior is designed to provide fast failure.
This can be really handy, whether the cause is as simple as a transcription error of a method name from irb or as convoluted as an incorrect version of a dependency that lacks the method you expected. 

However, because classes can be reopened and edited at runtime, sometimes you'll be able to outsmart Gimme by knowing that a particular
method *will* be available on the class being doubled, even though it isn't *right now*.

For these situations, you can use `give!` and `verify!` to suppress the check that triggers NoMethodError from being raised.

Here's an example where our Dog is again being doubled to facilitate some test, and even though the Dog class lacks a public `meow()` method, we happen to know
that at runtime, the newest version of the `bananimals` gem will reopen Dog and add `meow()` to it.

    dog = gimme(Dog)
    give!(dog).meow { :purr }
    
    dog.meow        #=> :purr
    
We cam accomplish the same thing using `verify!`:

    dog = gimme(Dog)
    
    dog.meow
    
    verify!(dog).meow     #=> verification passes, even though Gimme can't see the meow method.