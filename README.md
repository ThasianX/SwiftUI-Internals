# SwiftUI Internals

Dump of methods SwiftUI views implement in relation to their UIKit counterpart.

This project uses [Introspect](https://github.com/siteline/SwiftUI-Introspect) to get the backing UIKit views.

Why This Might Help You
---

If you want to customize a particular SwiftUI view further by using its backing UIKit view, you may want to know what you are potentially overriding on SwiftUI's side in the process. 

For example, you may also want to implement a few `UITableViewDelegate` methods from the backing `UITableView` of SwiftUI's `List`. By looking at the list of implemented methods from the list for `UITableViewDelegate` below, you know that you can safely implement `scrollViewDidScroll:` without worrying about any unintended side effects.

And how do you implement your changes to the `UITableView` delegate without affecting any delegate implementations from SwiftUI's `List`?

In your class, you want to declare a new property to hold the old `UITableView` delegate(from the `List`):

```swift

var oldDelegate: UITableViewDelegate?

```

After you get the backing `UITableView`, you can pass that into your class and set its delegate to your class:

```swift

func attach(to tableView: UITableView) {
    oldDelegate = tableView.delegate
    tableView.delegate = self
}

```

Here's where delegate forwarding comes in. Now in your class, you want to forward all the methods that you don't implement back to SwiftUI's `List` to provide the implementation:

```swift

override func responds(to aSelector: Selector!) -> Bool {
    super.responds(to: aSelector) || (oldDelegate?.responds(to: aSelector) ?? false)
}

override func forwardingTarget(for aSelector: Selector!) -> Any? {
    // You need to add a case for every method you implement
    if aSelector != #selector(UITableViewDelegate.scrollViewDidScroll) {
        return oldDelegate
    }
    return nil
}
    
```

Now you're good to go and do whatever it is you need to do!

- [List](#list)

## List

Backing UIKit view - `UITableView`. 

`List` uses the same source for both the datasource and delegate.

**Implemented UITableViewDataSource & UITableViewDelegate Methods**

```
tableView:viewForFooterInSection:
tableView:numberOfRowsInSection:
tableView:didEndDisplayingCell:forRowAtIndexPath:
tableView:commitEditingStyle:forRowAtIndexPath:
tableView:viewForHeaderInSection:
tableView:cellForRowAtIndexPath:
numberOfSectionsInTableView:
tableView:willDisplayHeaderView:forSection:
tableView:didSelectRowAtIndexPath:
tableView:canEditRowAtIndexPath:
tableView:canMoveRowAtIndexPath:
tableView:moveRowAtIndexPath:toIndexPath:
tableView:willDisplayCell:forRowAtIndexPath:
tableView:willDisplayFooterView:forSection:
tableView:didEndDisplayingHeaderView:forSection:
tableView:didEndDisplayingFooterView:forSection:
tableView:estimatedHeightForHeaderInSection:
tableView:estimatedHeightForFooterInSection:
tableView:shouldHighlightRowAtIndexPath:
tableView:didDeselectRowAtIndexPath:
tableView:editingStyleForRowAtIndexPath:
tableView:willBeginEditingRowAtIndexPath:
tableView:didEndEditingRowAtIndexPath:
tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:
tableView:shouldBeginMultipleSelectionInteractionAtIndexPath:
tableView:didBeginMultipleSelectionInteractionAtIndexPath:
tableView:contextMenuConfigurationForRowAtIndexPath:point:
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
