# Gimme

A very lightweight test double tool in ruby. Written to facilitate test-driving by 
getting out of the author's way and specifying only what matters.

## The Gist

Gimme was (for the first five hours of its life) named "Tabula Rasa," to very clearly indicate that it generates blank slate test doubles that lack any initial coupling with the concepts associated with specific [test double](http://xunitpatterns.com/Test%20Double.html) subtypes like mocks/stubs/fakes/spies/proxies. 
But in the end, "gimme" was easier to type, and since I knew I'd need a method name that didn't conflict with `rspec-mock`'s `double()`, I renamed it. 

Gimme is merely an expression of the desire to write low-friction, low-specification tests that feel a little more like Mockito than existing ruby test double libraries. Gimme should do whatever it can to help you isolate your SUT from its dependencies and then get out of your way.

The few things it gives you:

* Natural arrange-act-assert flow — meaning that you can call `verify` after you've interacted with your system under test.
* No stringy/symbolic representations of methods — similar to [rr](https://github.com/btakita/rr), gimme uses the blank slate pattern and `method_missing` to allow for minimally terse stubs and verifications
* No stubbing or verifying methods the class doesn't respond to — it's a cost that test doubles lie; test doubles that don't pretend to respond to messages they can't seem to lie (and cost) a little bit less.
* No barking at you for not setting up an expectation on every invocation — verify exactly what matters to you in the context of what you're building; sometimes specifying the behavior of your SUT on a collaborator is significant, and sometimes it isn't.

## The Disclaimer

So far this is just a simple proof of concept script and some cucumber features. There's no gem to import yet. In fact, the only way to use it would be to reference a copy of the ruby script. (If anyone wants to gemmify the project in a fork, however, I'd be thrilled.)

On a related note, Gimme has none of the cool stuff it would need to be a full-on replacement for existing test double frameworks like matchers, etc.

## Examples

To create a test double, you'd pass in a class:

    double = gimme(Object)
     
Once you have your double, you can stub methods (but only methods that the given class will respond to):

    were(double).to_s { 'Pants' }
    double.to_s                         #=> 'Pants'
    
    were(double).equal?(:ninja) { true }
    were(double).equal?(:fruit) { false }    
    double.equal?(:ninja)               #=> true
    
You can also verify interactions with your double    

    double.equal?(:fruit)
    
    verify(double).equal?(:fruit)       # does nothing
    verify(double).equal?(:what_the)    # raises a Gimme::VerifyFailedError

You can also specify how many times a specific invocation should have occurred (defaults to 1):

    double.equal?(:fruit)
    double.equal?(:fruit)
    
    verify(double,2).equal?(:fruit)
    