Movemedical app which allows users to schedule new appointment and view and edit list of existing appointments.

Couple of notes:

- Used UIKit as I have more experience then with SwiftUI (using SwiftUI for the last 9 months)
- Used only 1 library which was added to project via SPM - SnapKit (for constraints).
- Part of UI done in code (appointment list) by using SnapKit and part using XIBs (details screen used for adding or editing) - in production app I wouldn't mix and match these 2 approaches but decided to do it this way just to show you expertise with creating UI both ways (programatically and using XIB/storyboard)
- Used MVVM-C which is basically MVVM with coordinators (coordinators are responsible for navigation between screens)
- Used Combine (worked with RxSwift but long time ago).
- As there were no mentions of API in specifications I decided to persist the data locally using CoreData.
- Project structure - like to have a couple of main folders and put everything under them:
  - AppDelegate - contains only AppDelegate
  - Common - contains thing common to the whole app like protocols, extensions, property wrappers, reusable views, DAL and so on.
  - Resources - contains all resources (like assets, localization, data model etc)
  - Screens - contains app screens
- As it wasn't specified, I allowed for users to enter appointments in the past, same as Calendar app - in production I would probably put a limit so that user can only enter appointments in the future
- In production app I would probably make details screen also using TableView (like on list screen) or embedding everything in ScrollView
- Currently if user adds, edits or deletes appointment, it's returned back to the list of the appointments which is refreshed. In production app I would also add some kind of toast so that user knows everything went well (all errors are handled by presenting alert to the user)
- Appointments can be deleted from 2 places - details screen by tapping delete icon in nav bar and on list by doing swipe action on the item
