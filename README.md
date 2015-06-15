# AJMenu-ObjC
A simple menu to add a different flavor to your app



Adding AJMenu to your project/ workspace
========================================

* Add the AJMenu-ObjC Xcode project to your existing project/ workspace
* Open your Target’s build phases and link libAJMenu-ObjC.a
* Configure “User Header Search Paths” in Build Settings of your Target to add the AJMenu-ObjC directory
* For Swift applications, ensure that you import “AJMenuView.h” in your project’s Bridging-Header.h file.


Using AJMenu
============

Pre-requisites
———————
* An array with button labels.

Adding to the view
—————————
* Initialize the AJMenuView
* Set the delegate and datasource
* invoke “configureView” method of AJMenuView
* Add as a subview to your view.

Delegate Methods
================
* `- (void) ajMenuView: (AJMenuView *) ajMenuView didTapButtonAtIndex: (NSInteger) index`

Datasource Methods
==================
* `- (UIImage *) imageForMenuButton`
* `- (UIImage *) imageForMenuItem`