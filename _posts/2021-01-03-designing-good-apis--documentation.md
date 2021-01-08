---
modify_date: 2021-01-03 00:06:00
title: Designing Good APIs - Documentation
tags: api-design
cover: /images/documentation_cover.jpg
---

![Image](/images/documentation.jpg){:.rounded}

Even though a good API should be self-descriptive, proper documentation is required. 

Documentation is not only beneficial for the consumers of your API, but also for you as a developer.

<!--more-->

Here is how Apple state it:

> Write a documentation comment for every declaration. Insights gained by writing documentation can have a profound impact on your design, so don’t put it off.

Documentation will force you to think about your API. It will help you uncover inconsistencies and unnecessary complexity. It is an essential part of API creation and design. 

An API without it, is _incomplete_.

Describe the following, when documenting your API:

* **Purpose** of the class / method / component.
* **Behaviour** of the class / method / component. Focus on the business level (don't tell every technical implementation detail).
* **Expected Inputs and their semantics**. Include the assumptions your API makes about inputs (e.g. must not be null, etc.)
* **Generated Outputs and their semantics**. Include descriptions about alternative outcomes (e.g. returns true, if...  / returns false if..., returns null in case of..., etc.)
* **Possible Errors / Exceptions**
  
And keep in mind another of Apple's guidance: 

> If you are having trouble describing your API’s functionality in simple terms, you may have designed the wrong API.

Once you notice this is the case, start improving your API!