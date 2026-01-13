# timeshare
<!--toc:start-->
- [Usage](#usage)
  - [Authentication and Security](#authentication-and-security)
  - [Making a Calendar](#making-a-calendar)
  - [Making and Modifying Events](#making-and-modifying-events)
  - [Viewing Events](#viewing-events)
  - [Sharing Events](#sharing-events)
  - [Friend Requests](#friend-requests)
  - [Ownership Transfer](#ownership-transfer)
- [General Flow Structure](#general-flow-structure)
- [Elements Explained](#elements-explained)
  - [The Database](#the-database)
  - [The Repositories](#the-repositories)
    - [Why is there no state or local copy stored in the repositories?](#why-is-there-no-state-or-local-copy-stored-in-the-repositories)
  - [The Notifiers and Providers](#the-notifiers-and-providers)
  - [UI Elements](#ui-elements)
<!--toc:end-->

A simple calendar sharing thing. Designed to be easier to edit than others.

## Usage

### Authentication and Security

> **Important Security Notice:** Please read this section carefully before storing sensitive information in Timeshare.

#### Password Security
Your password is:
- Securely hashed on the server using industry-standard algorithms
- Never stored in plain text
- Not visible to the app developer or maintainers

#### Data Storage - Please Read Carefully

**Your calendar data is NOT end-to-end encrypted.** This means:

- Data is encrypted during transmission (HTTPS)
- Data is encrypted at rest by the server infrastructure
- However, data **can be read by** database administrators

**What data is stored:**
- Your email address and display name
- Calendar names and sharing settings
- Event names, dates, times, and recurrence patterns
- Your friends list

**Recommendation:** Do not store highly sensitive information (medical details, financial data, confidential business information) in this app.

For complete security details, see [SECURITY.md](SECURITY.md).

### Making a Calendar

- The UI is pretty expressive, and making a calendar should be pretty self
explanatory. Once made, you are now the OWNER of the calendar, and as such
can delete it, or choose to share it with anyone you have added as a friend
in the app. Currently, the only rights an OWNER has over a SHARED USER is the
ability to delete a calendar. Once shared, a calendar can be shared by users
you have shared the calendar with, and events can be added and/or deleted
by any users who can see it.

### Making and Modifying Events

- Events are the lifeblood of a calendar. Otherwise, what's the point?
The core functionality of an event is the calendar markers. Currently, the
app supports showing up to 4 markers per calendar day. They can be a range of
colors and shapes, and this is to make them easy to visually identify for the
user.

- The key utility of this calendar is the ability to quickly repeat events on
custom days. This makes sense for people with irregular work schedules
(namely, nurses and other healthcare professionals). To use this, simply select
the event you wish to copy in the list below the calendar. The event and
calendar header should be colored blue. Then, simply select a date to copy the
event to that day. Easy! The event will be saved under the same calendar it
was copied from.

- To exit copy mode, simply tap the calendar header to return to normal mode.

- To delete an event, simply swipe left on the event listing to remove it from
the database.

### Viewing Events

- First, select which calendars you want to superimpose on your calendar view.
To do this, select the top right filter icon to bring up a menu of calendars
available to you, and check or uncheck which calendars you would like to see.
All events from these calendars will be superimposed on your view, creating a
composite view of your planned events.

- To filter events which are today or after, there is a filter setting in the
editing drawer of the app. Simply toggle the setting to enable/disable viewing
events before or after today.

- To filter by date, simply select the day you wish to view in your calendar.
No extra steps required. To undo this filter, select the calendar header.

### Sharing Events

- First, add the user you wish to share a calendar of events with. Search the
user by typing in their email address (requires 5 characters to search) and
add them as a friend.

- Then, while still on the friends list page, tap the share icon, and toggle
which calendar you want to share with them. The calendar will be automagically
shared, and all events you have shared will be visible to them. Voila!

- This can be easily undone, by simply toggling the option to share the
calendar with whomever you have shared it with.

### Friend Requests

- When you search for a user and send a friend request, they have 30 days to
accept or decline. Pending requests are visible in the Friends section.

- Once accepted, you can share calendars with them. If declined or expired,
you can send a new request.

### Ownership Transfer

- Calendar owners can transfer ownership to any user the calendar is shared
with. Navigate to the calendar's admin page and select "Transfer Ownership."

- The recipient must accept the transfer request. Once accepted, they become
the new owner with full control over the calendar.

- Pending transfers can be cancelled by the current owner before acceptance.

## General Flow Structure

**Database**  
↑ ↓  
**Repositories**  
↑ ↓  
**Notifiers & Providers**  
↑ ↓  
**UI elements**  

## Elements Explained

### The Database

The app uses a REST API backend for data storage and authentication.
All access and control logic is stored in modular repositories, making
it easy to swap backends if needed.

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

### The Notifiers and Providers

- Cool little riverpod tools that help me store and access state.
 It demands the use of ConsumerWidgets, which can use WidgetRef objects
 to do their thing. Essentially, this takes over the place of the 'controller'
 layer of the software. It enables the UI to respond to and push events to and
 from our backend.

### UI Elements

- I couldn't design a UI to save my life. I've been trying to make all my
 design elements (widgets) more "composable", however I've had a hell of a time
 trying to organize them. Not sure if they should be organized by function,
 type, etc. Therefore, you may notice, when looking through this repository, an
 absolute explosion of separate files. For this, I apologize.

## Licensing

- This project is licensed under the GNU Affero General Public License v3.0
(AGPLv3). It is free to use, and you can certainly use this framework to host
your own backend using this software. I would be crushed emotionally if you
made a fortune off of my stuff, so you just have to cite my work please.

- Any questions, issues, or concerns can be directed to
[DFitzsimmons11@protonmail.com]
