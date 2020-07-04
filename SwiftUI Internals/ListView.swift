// Kevin Li - 7:07 PM - 7/3/20

import Introspect
import SwiftUI

struct ListView: View {

    var body: some View {
        List(0..<10) {
            Text("\($0)")
        }
        .introspectTableView(customize: printImplementedMethods)
    }

    private func printImplementedMethods(tableView: UITableView) {
        printImplementedTableViewDatasourceMethods(tableView: tableView)
        printImplementedTableViewDelegateMethods(tableView: tableView)
    }

    private func printImplementedTableViewDatasourceMethods(tableView: UITableView) {
        var methodCount: UInt32 = 0

        let cls = tableView.dataSource!
        let classToInspect = type(of: cls)
        let methodList = class_copyMethodList(classToInspect, &methodCount)!

        print("------------Implemented UITableViewDataSource Methods-----------")
        for i in 0...Int(methodCount) {
            let selector = method_getName(methodList[i])
            print("\(String(_sel: selector)) - \(cls.responds(to: selector))")
        }
        print()
    }

    private func printImplementedTableViewDelegateMethods(tableView: UITableView) {
        var methodCount: UInt32 = 0

        let cls = tableView.delegate!
        let classToInspect = type(of: cls)
        let methodList = class_copyMethodList(classToInspect, &methodCount)!

        print("-----------Implemented UITableViewDelegate Methods-----------")
        for i in 0...Int(methodCount) {
            let selector = method_getName(methodList[i])
            print("\(String(_sel: selector)) - \(cls.responds(to: selector))")
        }
        print()
    }

}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
