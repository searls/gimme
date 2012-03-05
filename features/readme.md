# gimme

Gimme is a test double library designed to help you write isolated unit specs for your Ruby code.

Here are a few examples:

* [Basic usage](https://www.relishapp.com/searls/gimme/docs/basic-usage)
* [Argument matchers](https://www.relishapp.com/searls/gimme/docs/argument-matchers) (and argument captors)
* [Stubbing and verifying class methods](https://www.relishapp.com/searls/gimme/docs/class-methods)

Todo:

* Overriding method existence checks with ! (e.g. `give!()` or `verify!()`)
* Stubbing the next `new`'ing of a type (e.g. `gimme_next(Dog)` )