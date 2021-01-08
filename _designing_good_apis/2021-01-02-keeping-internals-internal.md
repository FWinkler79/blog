---
modify_date: 2021-01-02 00:05:00
layout: article
title: Keeping Internals Internal
tags: api-design
cover: /images/lock_cover.jpg
---

![Image]({{ site.baseurl }}/images/lock.jpg){:.rounded}

A good API focuses only on the _business functionality_ of a service or component and it hides the technical details of the implementation from its consumers.

<!--more-->

Very often, developers tend to expose internal technical details in the API - mostly because they fail to detach from the technical intricacies they are concerned with while they _implement_ the API.

An _API First_ approach tries to avoid that. But as a API evolves over time, it is **imperative** for each developer to always ask themselves the same questions:

* why do we expose this information (input / output parameter / method / class)? Is it for us internally, or is it part of the business functionality?
* does a consumer of our API have to know that information?
* should a consumer of our API be allowed to know that information?

Depending on the answers to these questions, parameters, methods or classes might be exposed in a read-only mode, or might not be exposed at all.

Proper usage of scoping and information hiding keywords (like public, protected, private) or interface-oriented design can help keeping those internals where they belong: locked on the inside.

Failing to do so, _pollutes_ your API, _distracts_ from its actual purpose and makes implementation details a part of your API that you will _not be able to change later_ without **breaking compatibility**.