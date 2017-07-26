## Table of Contents
  * [App Design](#app-design)
    * [Objective](#objective)
    * [Audience](#audience)
    * [Experience](#experience)
  * [Technical](#technical)
    * [Screens](#Screens)
    * [External services](#external-services)
    * [Views, View Controllers, and other Classes](#Views-View-Controllers-and-other-Classes)
  * [MVP Milestones](#mvp-milestones)
    * [Week 1](#week-1)
    * [Week 2](#week-2)
    * [Week 3](#week-3)
    * [Week 4](#week-4)
    * [Week 5](#week-5)
    * [Week 6](#week-6)

---

### App Design for Comet / Gift Bag (tentative title)

#### Objective
Create a wish list of stuff you want, search and add friends to see what presents to get someone for their birthday, christmas, or other holidays! Users can mark if they have received a gift or if they bought it themselves from their own wishlist. Friends can mark if they are planning on buying something or have bought it already so other people know, and it's only visible to other users. Comet / Gift Bag also tries to make sure that people don't buy the same present without letting the person know that they will receive that present. The user can then mark that a friend bought that present.

#### Audience
This targets people who need to plan giving gifts but aren't sure what to get or don't want to ask. It also keeps anonimity for the present giving so it can be a surprise for a birthday 

#### Experience
People will be able to add the items they want regularly or connected with other services/api (non-exhaustive list: amazon, steam, etc). They can then add friends by searching the person's unique username.

[Back to top ^](#)

---

### Technical

#### Screens
* Login Flow
  * Login Screen
  * Create User Screen
  * Forgot Password Screen
* Main User Flow 
  * Profile Tab Screen
    * Create Wish Item Screen
    * View Wish Item Screen
    * Account Info Screen
    * Settings Screen
  * Friends Tab Screen (holds invites and current friends)
    * Friend Wish List Screen
      * View Friend Wist Item Screen
  * Add Friends Tab Screen (Search for users & send friend request)

#### External services
* Any Marketplace API (start off with Amazon, rest is stretch goal)
  * Amazon API
  * Steam API
  * Ebay API

#### Views, View Controllers, and other Classes
* Views + View Controllers (check Screens)
* Other Classes
  * Firebase Services
    * Authentication
    * Database (for each model)
    * Storage (for any pictures)
  * Custom UI files/extensions

#### Data models
* User Model
  * Regular info (name, username)
  * Birthday
  * User profile picture
  * User's friends
* Wish Item Model
  * Item info
    * Name
    * Price
    * Amazon url
    * Picture
      * Uploaded image > amazon picture > default/empty picture

[Back to top ^](#)

---

### MVP Milestones

#### Week 1

_planning your app_

* create Firebase Boilerplate
* set up User/Wishlist on database
* start Profile flow
  * Profile settings
    * Account info
    * Log out/Delete User

#### Week 2

_finishing a usable build_

* finish Profile flow
  * Create + Add wish list items
  * Collection view of wish list items
  * View wish list items
    * Edit any information
    * Set item to None, Received, Bought
    * Delete an wish list item
* start Friend flow
  * Search and add friends
  * Accept/decline friend requests
  * View friends

#### Week 3
* finish Friend flow
  * unfinished stuff
  * View friend wish list
* handle Wish List between Friends Logic
  * Mutable/Transaction block setting
    * Planning on buying
    * Have bought

#### Week 4

_finishing core build_

* Unfinished stuff for Friend Flow
* Apply amazon API
* Random Gift Generator?
* Start creating a clean UI

#### Week 5

_starting the polish_

* Restructure/organize any unintuitive parts of the program
* Try finishing up UI

#### Week 6

_submitting to the App Store_

* Finish up the polish up
* Make sure it is ready for the App Store

[Back to top ^](#)