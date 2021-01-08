---
modify_date: 2020-12-29 00:01:00
title: What Is a "Good" API
tags: api-design
cover: /images/craftsmanship_cover.jpg
---

![Image](/images/craftsmanship.jpg){:.rounded}

Many consider API design an art. 
This would imply that it requires a level of ingenuity and creative spirit to come up with a pleasing result. It would also imply that a good / pleasing API is widely subject to "a matter of taste".
In this article we show that it is actually much more than that.

<!--more-->

Undoubtedly, if designing a good API was easy, there would not be an abundance of horrific counterexamples available on the Internet today. 
As some aspects of API design may depend on taste and creativity, we believe a lot of what is required to create a good API can actually be _learned_. 

In this post we are discussing qualities that a good API should have, and thus focus on the ***craftsmanship*** that is underlying any form of art.

Use the following qualities as a checklist and litmus test for any API you create or evaluate. 

* **Simplicity** - A good API is supposed to make things simple. Simple for those who consume it. Not necessarily for those who create it. In fact, making things simple turns out to be a surprisingly difficult task at times - otherwise it would just be trivial. Creating a good, simple API is effort you need to spend so that your consumers do not have to. It will be _easy to read and work with_, and its resources and associated operations can quickly be _memorised_ by developers who work with it constantly.

* **Focus on Business Functionality** - An API should focus on the business functionality of your product and hide the technical intricacies and internal details that distract from it. As a developer of an API you should constantly ask yourself "Is this object / function / input / output really necessary for a consumer of the API? Or is it rather an internal detail I should hide?". Just as [Dieter Rams](https://en.wikipedia.org/wiki/Dieter_Rams) said it - "Good design is as little design as possible " - generally, a good API should provide only what is really relevant from a business logic point of view, leaving aside all the unnecessary, internal details that only complicate usage.

* **Self-Descriptive** - A good API uses meaningful and concise names that express components, operations, input and output parameters well. Names focus on the _business functionality_ and describe clearly the essence of what the component or operation does, and what inputs and outputs it creates. As such, names focus on the _semantics_ of the objects they describe. A self-descriptive API is easy to read, and easy to understand even without having to consult API documentation. It can almost be read like prose and never ever exposes implementation details or concepts to its readers and consumers.

* **Hard To Misuse** - Implementing and integrating with a good API will be a _straightforward process_. Writing incorrect code will be a less likely outcome.  This is enabled by the API being well-documented, and providing _informative feedback_ (e.g. by proper error propagation, error reporting and logging) when it is being used and misused. It is resilient to errors and wrong usage, and fails early with meaningful messages. By doing so, it _can do without strict and lengthy guidelines_ that end consumers must adhere to for the API to function properly.

* **Completeness** - A complete API will make it possible for developers to create full-fledged applications against the data it exposes.  For example, providing functionality to just create data without being able to delete or update it, leaves the API incomplete.  Completeness happens over time usually, and most API designers and developers incrementally build on top of existing APIs, thus temporary incompleteness may be acceptable. However, eventual completeness - in a finite time-scope - is an ideal each engineer or company providing an API must strive for.

* **Consistency and Platform-Standard-Compliance** - A good API follows patterns and conventions of the target platform it was designed for.  For example, if the API is a REST interface, make sure you understand the concepts and patterns used there. If it is a Java API or Node.JS API follow the patterns and code conventions used on these platforms. A good API not only follows conventions of the target platform, it also makes sure it follows its patterns consistently. 

* **Designed for Compatible Evolution** - APIs evolve over time. This is a natural fact as new features are being developed and consumer needs develop. A good API is designed with principles in mind that make its evolution and extension possible in a _compatible_ way. An API not only defines interface names and signatures, it also defines _semantics_ and _behaviour_. Changing semantics or behaviour can result in incompatible changes just as much as changing the signature of an operation will. Very often, the reason for incompatible changes to APIs are the result of a lack of care and time taken to design the API with evolution in mind. As the number of consumers of your API grows, every incompatible change will become less and less acceptable, culminating in dirty hacks, unmanageable complexity, workarounds, maintenance overhead and/or complete re-developments and split code lines.

* **Simply and Properly Documented** - Even though a good API should be self-descriptive, a proper documentation is required. Documentation is not only beneficial for the consumers of your API, but also for you as a developer. Apple describe it best with the following statement: "If you are having trouble describing your API’s functionality in simple terms, you may have designed the wrong API." Documentation will force you to think about your API. It will help you uncover inconsistencies and unnecessary complexity. It is an essential part of API creation and design. An API without it, is _incomplete_.

For a good example of language-specific guidelines, have a look at [Apple's Swift Coding Conventions](https://swift.org/documentation/api-design-guidelines/). Although specific to Swift, a lot of the key messages generally apply to good API design.

Finally, keep in mind that your API will act as a multiplier - either for complexity or simplicity. What would you prefer it to be?
## References
* [Three Principles of API First Design](https://medium.com/adobetech/three-principles-of-api-first-design-fa6666d9f694)
* [(REST) API Design Best Practices](https://swagger.io/blog/api-design/api-design-best-practices/)

