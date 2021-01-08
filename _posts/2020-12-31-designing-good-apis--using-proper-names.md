---
modify_date: 2020-12-31 00:03:00
title: Designing Good APIs - Using Proper Names
tags: api-design
cover: /images/typewriter_cover.jpg
---

![Image]({{ site.baseurl }}/images/typewriter.jpg){:.rounded}

Naming is a very important part of designing a good API. Names convey meaning and make using and understanding your API easier. Good naming is half an API's documentation. So take care about your names.

<!--more-->

Below we have summarised a few common rules to keep in mind when picking names of operations, variables and interfaces of your API.

* **Name based on roles** - name variables, parameters, and associated types  according to their roles. In other words, rather than naming a view controller class just 'ViewController', name it by its role - e.g. ListCustomersViewController.

* **Omit needless or unclear words** - every word in a name should convey meaningful information.  Words like "Object", "Entity", "Manager" are very general, and often (not always) are just clutter.  Avoid them, in favour of a more descriptive, more concrete wording.

* **Name functions and methods according to their side-effects** - e.g. if a method mutates an object, express it the API's name as a verb. If it does not have any side effect use the _verb form appending -ed or -ing_. 
For example, `array.sort()` implies mutating the array. In contrast `array.sorted()` should return a new array that is the sorted version of the original.

* **Choose parameter names to serve documentation** - even though parameter names might not appear at a function or method’s point of use, they play an important explanatory role. Choose parameter names by their purpose and express what inputs and outputs your operations expect.

* **Avoid obscure terms** - e.g. don't say “epidermis” if “skin” will serve your purpose. Use understandable, common terminology. If you are unsure about the English word, think of it in your own language then consult a [translation tool](http://dict.leo.org/) to find the best word.

* **Avoid abbreviations** - Abbreviations, especially non-standard ones, yield potential for misinterpretation, are difficult to read and write, and may heavily depend on the context they are written in. Clarity is more important than brevity. 

* **Avoid Hungarian notation** - [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) is ugly to read and generally known to be an anti-pattern today.  Avoid it, and choose proper naming.

* **Stick to naming conventions** - each target language or platform has its own naming conventions. These are usually explicitly or implicitly defined by their respective developer community. Knowing and adhering to these conventions is important if you are developing open-source software, return something to the community or want to gain acceptance and adoption. Ignoring these conventions will deteriorate developer experience and acceptance of your product.

## References
[Apple's API Guidelines](https://swift.org/documentation/api-design-guidelines/)