# Gimme

Gimme is a very lightweight test double library for ruby. Written to be an opinionated (but not noisy) means to facilitate test-driving by enabling the author to specifying only what matters. But if could only feed Google one thing at this point, it would be: "[Mockito](http://mockito.org/) for Ruby"

You can read the (possibly stale) documentation below or the (fresh) [gimme Cucumber features on Relish](http://relishapp.com/searls/gimme)

## Basics (or "What does it Gimme?" ... har.)

Gimme was originally named (well, for the first five hours of its life) "[Tabula Rasa](http://en.wikipedia.org/wiki/Tabula_rasa)," to very clearly indicate that it generates blank slate test doubles that lack any initial coupling with the concepts associated with specific [test double](http://xunitpatterns.com/Test%20Double.html) subtypes like mocks/stubs/fakes/spies/proxies. But in the end, "gimme" was easier to type than "tabula rasa", and I generally wanted to avoid test pattern lingo from leaking into the context and language of everybody's tests (hence no method named "stub"). 

Gimme doubles are most accurately identified as [test spies](http://xunitpatterns.com/Test%20Spy.html) in [this table discriminating the types](http://xunitpatterns.com/Mocks,%20Fakes,%20Stubs%20and%20Dummies.html) over at Gerard Meszaros' helpful xUnit patterns repository.

Gimme aims to enable you to write low-friction, low-specification tests that feel a little more like [Mockito](http://mockito.org/) than existing ruby test double libraries. Gimme should do whatever it can to help you isolate your SUT from its dependencies and then get out of your way. And if gimme can provide some fast-feedback about potential problems, it should try to do that too.

The few things it gives you:

* Many typical test double library features, like: stubbing & verifying methods, argument matchers for determining what gets stubbed and what to verify, and argument captors for inspecting stuff your [SUT](http://xunitpatterns.com/SUT.html) passes its dependencies
* Natural arrange-act-assert flow — meaning that you can call `verify` after you've interacted with your system under test.
* No stringy/symbolic representations of methods — similar to [rr](https://github.com/btakita/rr), gimme uses the blank slate pattern and `method_missing` to allow for minimally terse stubs and verifications
* Sometimes you know the class of a dependency of your SUT; when you do, gimme can try to help out by raising a NoMethodError when you attempt to stub or verify a method that the class doesn't respond to.
* Gimme won't punish you for not setting up an expectation for every interaction your SUT has with your test double, leaving you to verify exactly what matters to you in the context of what you're building; sometimes specifying the behavior of your SUT on a collaborator is significant, and sometimes it isn't.


## The Disclaimer

Gimme is still in early development and a little light on features / hardening. While gimme should be enough to get started writing tests/specs, you'll likely run into edge cases that haven't been handled yet. If you're willing to try out gimme on your next toy project and either submit issues or pull requests when you run into issues, hopefully we can work together to make gimme a first-class test double framework in the Ruby community.

## Getting started

### Setting up
First, install the gem:

    gem install gimme

Next, wherever you set up your test environment, require gimme:

    require 'gimme'

### Creating a double
Once you're in your test or spec, to create a test double.

If you know what what class your SUT will be depending on, you can specify it:

    double = gimme(Object)
    
Or you could just create a generic double can stub/verify any method you need:

    double = gimme()
     
### Stubbing     
     
Once you have your double, you can stub methods:

    give(double).to_s { 'Pants' }
    double.to_s                         #=> 'Pants'
    
    give(double).equal?(:ninja) { true }
    give(double).equal?(:fruit) { false }    
    double.equal?(:ninja)               #=> true
    
You can also stub your double to raise an exception (or really, do anything in the passed block):

    dog = gimme(Dog)
    give(dog).holler_at(:mail_man) { raise LeashLawError }
    
    dog.holler_at(:mail_man) # raises LeashLawError

### Verifying    
    
You can also verify interactions with your double    

    double.equal?(:fruit)
    
    verify(double).equal?(:fruit)       # passes verification (read: does nothing)
    verify(double).equal?(:what_the)    # fails verification (raises a Gimme::VerifyFailedError)

You can also specify how many times a specific invocation should have occurred (defaults to 1):

    double.equal?(:fruit)
    double.equal?(:fruit)
    
    verify(double,2).equal?(:fruit)
    
### Using Argument Matchers

Gimme includes several argument matchers which can be used to control which invocations will satisfy a particular stubbing or verification.

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
    
Other matchers:    
    
**is_a(class)** — matches any arguments that are `kind_of?` the provided class
**any(class)** — same as `is_a`, but also matches nil
**boolean** — matches true or false arguments
**numeric** — matches numeric arguments 

See the [cucumber feature for examples using these matchers](http://relishapp.com/searls/gimme/stubbing-with-matchers)

#### Writing Custom Argument Matchers

It's pretty easy to roll your own argument matchers as well. All you really need to do is pass as an argument to a method stubbed by `give` or verified by `verify` an object
that can respond to `matches?(arg)`. Maybe something like this would work (even though it'd be of questionable utility):

    class Nothing
      def matches?(arg)
        false
      end
    end

    give(dog).introduce_to(Nothing.new) { :meow }     #b/c Nothing.matches? always returns false, :meow will never returned by the double.
    

### Using Argument Captors

An instance of an argument `Captor`, when paired with the `capture` matcher, is a valuable way for your test to get at the values that your SUT passes to its collaborators. Often, classes are responsible for building objects to be ingested by their collaborators but for which normal state verification would either be difficult or nonsensical. Argument captors should only be necessary sparingly for most types of applications, but they're a handy tool to have in the toolbox.

In cases like these, a captor can be used to "capture" the real argument value that the system under test passes its collaborator. This pseudocode provides an example:

    #arrange
    searches_system = gimme(SearchesSystem)
    sut = QueryExecutor.new(searches_sytem)
    query_captor = Captor.new

    #act
    sut.submit_query_for_string("find dogs")
    
    #assert
    verify(searches_system).execute(capture(query_captor))
    query_captor.value.table_name.should == "Dogs"

    
### Suppressing NoMethodError

You may be reading this section because you got this message:

    The Test Double of <Class Name> may not know how to respond to the '<Method Name>' method. 
      If you're confident that a real Kernel will know how to respond to '<Method Name>', then you can
      invoke give! or verify! to suppress this error.
    
Whenever you stub or verify a method against a test double on a class, gimme will first verify that the method can be found on the class being
doubled. Since the vast majority of methods can be verified in this way, this default behavior is designed to provide fast failure.
This can be really handy, whether the cause is as simple as a transcription error of a method name from irb or as convoluted as an incorrect version of a dependency that lacks the method you expected. 

However, because classes can be reopened and edited at runtime, often you'll outsmart gimme by knowing that a particular
method *will* be available on the class being doubled, even though it isn't *right now*.

For these situations, you could either (1) declare your double without a class argument (e.g. `gimme()` instead of `gimme(Dog)`), or (2) use `give!` and `verify!` to suppress the check that triggers the NoMethodError from being raised.

Here's an example where our Dog is again being doubled to facilitate some test, and even though the Dog class lacks a public `meow()` method, we happen to know that at runtime, the newest version of the `bananimals` gem will reopen Dog and add `meow()` to it.

    dog = gimme(Dog)
    give!(dog).meow { :purr }
    
    dog.meow              #=> :purr
    
We cam accomplish the same thing using `verify!`:

    dog = gimme(Dog)
    
    dog.meow
    
    verify!(dog).meow     #=> verification passes, even though gimme can't see the meow method.

### gimme_next

To my knowledge, there isn't an established pattern or name for this next feature. Sometimes you may want your SUT to instantiate its own dependency. However, if you also want to achieve isolation from the implementation details of that dependency, you can use `gimme_next`.

Take this example method from the RSpec book:

    def guess(guess)
      marker = Marker.new(@secret,guess)  
      @output.puts '+'*marker.exact_match_count + '-'*marker.number_match_count
    end

This can be tested with gimme in isolation (meaning that a real Marker object is never instantiated or invoked) like so:

    describe '#guess' do
      let(:marker) { gimme_next(Marker) }
      before do
        give(marker).exact_match_count { 4 }
        give(marker).number_match_count { 0 }                 

        game.guess('1234')
      end
      
      it 'instantiates a marker with the secret and guess' do
        verify!(marker).initialize('1234','1234')
      end
      
      it 'outputs the exact matches followed by the number matches' do
        verify(output).puts('++++')
      end      
    end

As you can see above, `gimme_next(Marker)` will create a double just like `gimme()` would have, but it will also temporarily redefine the passed class's `new` method such that the next instantiation of that class (presumably by the SUT) will return the same double.* 

This way we can clearly specify the SUT's interaction with the Marker class while maintaining its isolation.

*Subsequent instantiations of the passed class will continue to return normal instances.

## About

### Maintainers
* [Justin Searls](http://about.emw/searls), [Pillar Technology](http://pillartechnology.com)
