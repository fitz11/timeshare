# timeshare

A simple calendar sharing thing. Designed to be easier to edit than others.

No current support for time, only date.

## General flow structure:
**Database**
|| ||
|| ||
**Repositories**
|| ||
|| ||
**Notifiers & Providers**
|| ||
|| ||
**UI elements**

## Elements explained
### The Database (firestore)
Currently, this houses my auth and storage solution.
I hope to one day migrate to my own backend, which is why all of the 
access and control logic for the database is stored in easily modular 
repsoitories.

### The Repositories
Here is logic tied to how I push and pull information from the backend.
The repositories, despite the name, carry no actual state: they just
push and return data.
#### Why is there no state or local copy stored in the repositories?
[Riverpod library]: https://riverpod.dev/
- Currently, my state solution is provided by the [Riverpod library].
 This offers the ability to store state such that my widgets can
 respond to changes in the data. This has a two fold benefit, as these
 provide both caching and "widget controlling" functionality.

### The Notifiers & Providers
- Cool little riverpod tools that help me store and access state.
 It demands the use of ConsumerWidgets, which can use WidgetRef objects
 to do their thing.

### UI Elements
- I couldn't design a UI to save my life. I've been trying to make all my
 design elements (widgets) more "composable", however I've had a hell of a time
 trying to organize them. Not sure if they should be organized by function,
 type, etc. Therefore, you may notice, when looking through this repository, an
 absolute explosion of separate files. For this, I apologize.
