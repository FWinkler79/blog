# Designing Good APIs: Modelling Errors

![System Error Image](./assets/error.jpg)

When designing an API, the aspect of proper error _modelling_ is just as important as error _logging_, since it will not only allow your consumers to _analyse_ errors, but also to _handle_ them.

To make this more tangible, we need to distinguish the following possible error types components of your API may encounter:

* **Recoverable internal errors** - are errors that you can anticipate and write code to recover from if they occur.  Examples for such errors could be wrongly formatted input that you will be able to internally re-format so that your code can still read it.  
Another example may be a Logging framework that will try to open a log file, and - in case none exists - will simply create one.  
These recoverable internal errors can be handled by your code and need not concern your consumers. 
In such a case, you should not throw any errors or exceptions for your consumers to catch. You should, however, log the error to the command line or server logs, and then recover from it.

* **Non-recoverable, internal errors** -  are errors, that you can anticipate, are plausible and likely to happen, but you will not be able to generically recover from - or should not even try to. They are not caused by wrong API consumption, but primarily by underlying technical issues. 
Examples for such errors could be HTTP connection issues, unavailability of your service or one of its dependencies. 
In such a case, a recovery strategy might be to automatically retry for a certain number of times, and you could try to handle this internally.  
However, since these kind of errors usually impact the functionality and user experience of your consumers, a better way might be to return an error that your consumers need to deal with.  
Your API may throw an exception that your consumers need to catch, or return an error code in a server response.
If your API throws an exception, it should be a checked exception (in Java these are subclasses of java.lang.Exception), since checking them is enforced by the compiler. Consumers of your API will be made aware of the fact, that there is a certain potential these errors may occur, and that they need to be prepared to deal with them.  
For example, in case of a connection issue, a consumer may want to deal with it in different ways - e.g. by providing a loading indicator and performing a retry, or maybe simply by providing a user notification stating that the service is currently unavailable.  
By not handling these kind of errors internally, but handing them back to your consumers, you give them a chance to deal with them in the way best suitable for them.

* **Non-recoverable, unexpected errors** - are errors that you might encounter internally, but can neither recover from, nor may have expected at design-time.  
If everything works as designed (that includes anticipated error scenarios) these errors should not occur. If they do occur, their impact on your API implementation or your consumers' stability is unforeseen.  
Examples for such errors are almost always bugs. Instances of this (hopefully) rare type of error _should have been caught by proper unit and integration tests_.  
If they occur anyway, they should occur as _unchecked exceptions_, i.e. exceptions that do not force your consumers to catch them.  
If you catch them in your API code, make sure to re-throw / forward them to your consumers as as _unchecked exceptions_. 
There is no need to burden your consumers with checking errors that should not be likely to happen. In Java, errors of this kind are modelled as subclasses of `java.lang.RuntimeException` - if not caught, they usually crash an application.  

**Note:** Even though consumers do not have to explicitly check these kind of errors, they still can. In other words, even if your library or component has a bug, your consumers could still _work around it_ by catching the exception if it occurs. Of course, this should be an exception... (pun intended).

* **Errors caused by wrong API usage** - are errors caused by the developers consuming your API.  
For example, developers could be calling methods on an object, depending on a certain lifecycle, out of order (i.e. when the object has an illegal internal state).  
Or they might call your API in a way that was not intended.
For errors that are clearly caused by wrong API usage, the proper way of dealing with these errors is to use `Asserts` (or throwing unchecked exceptions).   
`Asserts` will check (assert) a design-time assumption you have made when implementing your API. And they will **crash** your consumer, if these assumptions are not met.  
The rationale behind crashing your consumer is that by using your API in a wrong way, the consumer has actually created a _bug_ and needs to be informed about that during the development process. Provided that your consumers have proper tests in place - which is commonly agreed best practice - this crash / bug will immediately be detected and can be fixed once and for all.  
Make sure to include a proper error message when using Asserts, so that developers know what they have done wrong and can fix it.

**Use Asserts sparsely!** You should be 100% sure that the error is a result of wrong API usage - e.g. because developers have not read your documentation properly, or because of a violation of a fundamental pre-requisite.
For errors that could happen at runtime, too - e.g. since a user of your consumer's software provided illegal arguments to your API (rather than the developers) - using `Asserts` is wrong and could render your API **unusable**. 
Asserts will crash your consumers _without giving them a chance_ to either catch and handle or report the error that occurred to their users.

In such situations, it is better to throw an _unchecked exception_. In Java, these are subclasses of `java.lang.RuntimeException`.

Using unchecked exceptions also help uncovering bugs early in the development cycle, yet also allow your consumers to implement a "Catch all Unchecked Exceptions"-pattern at runtime. Especially for applications, this can be useful to catch any unexpected runtime errors, log and properly inform the user about them, but not crash.

Generally, when designing error reporting as part of your API, ask yourself which category the error belongs to. 
Put yourself into your consumers' shoes and ask yourself these questions:

* do they need error information at all, or can you handle it?
* can they actually deal with the error if it occurs?
* what error information do they need? 

Also keep in mind, that _checked exceptions_ are a "visible" part of your API, i.e. they become a part of your method signatures and cannot be changed or removed later without breaking backwards-compatibility.

For checked exceptions you might therefore want to declare a common super-class that you use in your method signatures. This will allow you to throw a set of sub-class exceptions that can later be extended without incompatible changes to your API.
Unchecked exceptions are "invisible" in your API, i.e. your consumers will not be made aware by a compiler that an error might occur. 

Document such exceptions well in your API documentation, and avoid creating your own (especially internal) exception types for unchecked exceptions.

Finally, make sure that you handle errors or exceptions as it is customary in the respective programming language you are targeting. 
Some languages provide exceptions, but developers will frown upon them being used. Stick to the platform's conventions. This is crucial for developer acceptance.

For further reading here is a nice guide of [Do's and Don't's for exception handling in Java](https://howtodoinjava.com/best-practices/java-exception-handling-best-practices/).

And if you are already familiar with Java exception handling, make sure you also have a look at the newly introduced [try-with-resource Exception handling](https://stackify.com/specify-handle-exceptions-java/#tryWithResource).

**Next:** [Designing Good APIs: Keeping Internals Internal](./designing-good-apis--keeping-internals-internal.md)  
**Previous:** [Designing Good APIs: Using Proper Names](./designing-good-apis--using-proper-names.md)
