//
//  SKSTableView.swift
//  SKSTableView
//
//  Created by Rocky on 2016/10/14.
//  Copyright © 2016年 sakkaras. All rights reserved.
//

import UIKit

@objc protocol SKSTableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    @objc func tableView(tableView: UITableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int
    @objc func tableView(tableView: UITableView, cellForSubRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    @objc optional func tableView(tableView: UITableView, heightForSubRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    @objc optional func tableView(tableView: UITableView, didSelectSubRowAtIndexPath indexPath: NSIndexPath)
    @objc optional func tableView(tableView: UITableView, shouldExpandSubRowsOfCellAtIndexPath indexPath: NSIndexPath) -> Bool
}

class SKSTableView: UITableView {
    
    var _expandableCells: [Int: [RowInfo]]!
    var expandableCells: [Int: [RowInfo]]! {
        get {
            if _expandableCells == nil {
                _expandableCells = [Int: [RowInfo]]()
                
                if let delegate = self.sksTableViewDelegate {
                    
                    let numberOfSections = delegate.numberOfSectionsInTableView!(self)
                    
                    for section in 0..<numberOfSections {
                        let numberOfRowsInSection = delegate.tableView(self, numberOfRowsInSection: section)
                        
                        var rows = [RowInfo]()
                        
                        for row in 0..<numberOfRowsInSection {
                            let rowIndexPath = NSIndexPath(forRow: row, inSection: section)
                            let numberOfSubrows = delegate.tableView(self, numberOfSubRowsAtIndexPath: rowIndexPath)
                            
                            var isExpandedInitially = false
                            
                            if let isExpandedFlag = delegate.tableView?(self, shouldExpandSubRowsOfCellAtIndexPath: rowIndexPath) {
                                isExpandedInitially = isExpandedFlag
                            }
                            
                            let rowInfo = RowInfo(isExpanded: isExpandedInitially, subrowsCount: numberOfSubrows)
                            
                            rows.append(rowInfo)
                        }
                        
                        _expandableCells[section] = rows
                    }
                }
            }
   
            return _expandableCells
        }
        set {
            _expandableCells = newValue
        }
    }


    /**
     * The delegate for the SKSTableViewDelegate protocol.
     *
     *  @discussion You must set only this protocol for the delegation and the datasource of SKSTableView instance.
     */
    weak var sksTableViewDelegate: SKSTableViewDelegate? {
        didSet {
            dataSource = self
            delegate = self
        }
    }
    
    /**
     * A Boolean value indicating whether only one cell can be expanded at a time.
     *
     *  @discussion When set to YES, already-expanded cell is collapsed automatically before newly-selected cell is being expanded.
     *      The default value for this property is NO.
     */
    var shouldExpandOnlyOneCell = true
    
    func refreshData() {
        expandableCells = nil
        
        reloadData()
    }
    
    func refreshDataWithScrollingToIndexPath(indexPath: NSIndexPath) {
        refreshData()

        if indexPath.section < numberOfSections && indexPath.row < numberOfRowsInSection(indexPath.section) {
            
            scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
    }
    
    func numberOfExpandedSubrowsInSection(section: Int) -> Int {
        var totalExpandedSubrows = 0
        
        guard let _ = expandableCells else {
            return totalExpandedSubrows
        }
        
        let rows = expandableCells![section]
        
        for row in rows! {
            if row.isExpanded {
                totalExpandedSubrows += row.subrowsCount
            }
        }
        
        return totalExpandedSubrows
    }
    
    func numberOfSubRowsAtIndexPath(indexPath: NSIndexPath) -> Int {
        return sksTableViewDelegate?.tableView(self, numberOfSubRowsAtIndexPath: indexPath) ?? 0
    }
    
    /**
     将绝对NSIndexPath转换成相对的IndexPath，如果原NSIndexPath是ParentRow，则返回原始NSIndexPath，如果是subrow，则返回subrow相对ParentRow的subrow信息
     
     - parameter indexPath: 原始NSIndexPath
     
     - returns: 相对NSIndexPath
     */
    func correspondingIndexPathForRowAtIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        var correspondingIndexPath: NSIndexPath? = nil
        
        guard let rows = expandableCells?[indexPath.section] else {
            return nil
        }
        
        var numberOfRows = 0
        
        var currentParentRow = 0
        
        for row in rows {
            
            let parentIndex = numberOfRows
            
            if indexPath.row == parentIndex { // is parent row
                correspondingIndexPath = NSIndexPath.indexPathForSubRow(NSIndexPath.ParentRow, row: currentParentRow, section: indexPath.section)
                break
            }
            
            // add self
            numberOfRows += 1
            
            if row.isExpanded {
                // add subrows
                numberOfRows += row.subrowsCount
            }
            
            if indexPath.row < numberOfRows { // is subrow
                let subrow = indexPath.row - parentIndex - 1 // subrow is begin of 0
                correspondingIndexPath = NSIndexPath.indexPathForSubRow(subrow, row: currentParentRow, section: indexPath.section)
                break
            }
            
            currentParentRow += 1
        }
        
        return correspondingIndexPath
    }
}



extension SKSTableView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = sksTableViewDelegate?.tableView(tableView, numberOfRowsInSection: section) ?? 0
        
        return rows + numberOfExpandedSubrowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let correspondingIndexPath = correspondingIndexPathForRowAtIndexPath(indexPath) else {
            return UITableViewCell()
        }
        
        guard let SKSDelegate = sksTableViewDelegate else {
            return UITableViewCell()
        }
        
        guard expandableCells != nil else {
            return UITableViewCell()
        }
        
        if correspondingIndexPath.subRow == NSIndexPath.ParentRow {
            let indexTemp = NSIndexPath(forRow: correspondingIndexPath.row, inSection: correspondingIndexPath.section)
            
            guard let expandableCell = SKSDelegate.tableView(tableView, cellForRowAtIndexPath: indexTemp) as? SKSTableViewCell else {
                return UITableViewCell()
            }
            
        //    expandableCell.separatorInset = UIEdgeInsets
            
            let rows = expandableCells![indexPath.section]
            let row = rows![correspondingIndexPath.row]
            let isExpanded = row.isExpanded
            
            if expandableCell.isExpandable {
                expandableCell.isExpanded = isExpanded
                
                if isExpanded {
                    expandableCell.accessoryView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            } else {
                expandableCell.isExpanded = false
                expandableCell.accessoryView = nil
            }
            
            return expandableCell
        } else {
            let cell = SKSDelegate.tableView(self, cellForSubRowAtIndexPath: correspondingIndexPath)
            cell.indentationLevel = 2
            
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sksTableViewDelegate?.numberOfSectionsInTableView?(tableView) ?? 1
    }
}

extension SKSTableView: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? SKSTableViewCell else {
            if let correspondingIndexPath = correspondingIndexPathForRowAtIndexPath(indexPath) {
                sksTableViewDelegate?.tableView?(self, didSelectSubRowAtIndexPath: correspondingIndexPath)
            }
            return
        }
        
        if cell.isExpandable {
            cell.isExpanded = !cell.isExpanded
   
            var index: NSIndexPath? = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
            let correspondingIndexPath = correspondingIndexPathForRowAtIndexPath(indexPath)
            
            if cell.isExpanded && shouldExpandOnlyOneCell {
                index = correspondingIndexPath
                collapseCurrentlyExpandedIndexPaths()
            }
            
            if correspondingIndexPath != nil {
                let indexTmp = NSIndexPath(forRow: correspondingIndexPath!.row, inSection: correspondingIndexPath!.section)
                let numberOfSubRows = numberOfSubRowsAtIndexPath(indexTmp)
                
                var expandedIndexPaths = [NSIndexPath]()
                let row = index!.row
                let section = index!.section
                
                for index in 1...numberOfSubRows {
                    let expIndexPath = NSIndexPath(forRow: row + index, inSection: section)
                    expandedIndexPaths.append(expIndexPath)
                }
                
                if cell.isExpanded {
                    setExpanded(true, forCellAtIndexPath: correspondingIndexPath!)
                    insertRowsAtIndexPaths(expandedIndexPaths, withRowAnimation: .None)
                } else {
                    setExpanded(false, forCellAtIndexPath: correspondingIndexPath!)
                    deleteRowsAtIndexPaths(expandedIndexPaths, withRowAnimation: .None)
                }
                
                cell.accessoryViewAnimation()
                
                if correspondingIndexPath?.subRow == 0 {
                    sksTableViewDelegate?.tableView?(self, didSelectRowAtIndexPath: indexTmp)
                } else {
                    sksTableViewDelegate?.tableView?(self, didSelectSubRowAtIndexPath: correspondingIndexPath!)
                }
            }
        }
        
        
    }
    
    private func collapseCurrentlyExpandedIndexPaths() {
        var totalExpandedIndexPaths = [NSIndexPath]()
        var totalExpandedParentIndexPaths = [NSIndexPath]()
        
        guard let expandableRowInfos = expandableCells else {
            return
        }
        
        let keys = expandableRowInfos.keys.sort { (a, b) -> Bool in
            return a < b
        }
        
        
        
        for section in keys {
            
            var currentRow = 0
            
            guard let rows = expandableRowInfos[section] else {
                return
            } 
            
            for row in rows {
                
                let isExanded = row.isExpanded
                
                if isExanded {
                    
                    totalExpandedParentIndexPaths.append(NSIndexPath(forRow: currentRow, inSection: section))
                    
                    let expandedSubrows = row.subrowsCount
                    
                    for _ in 1 ... expandedSubrows {
                        currentRow += 1
                        
                        let expandedIndexPath = NSIndexPath(forRow: currentRow, inSection: section)
                        
                        totalExpandedIndexPaths.append(expandedIndexPath)
                    }
       
                    row.isExpanded = false
                }
                
                currentRow += 1
                
            }
        }
        
        for indexPath in totalExpandedParentIndexPaths {
            
            guard let cell = cellForRowAtIndexPath(indexPath) as? SKSTableViewCell else {
                return
            }
            
            cell.isExpanded = false
            cell.accessoryViewAnimation()
        }
        
        deleteRowsAtIndexPaths(totalExpandedIndexPaths, withRowAnimation: .None)
    }
    
    private func setExpanded(isExpanded: Bool, forCellAtIndexPath indexPath: NSIndexPath) {
        if let cellInfo = expandableCells?[indexPath.section]?[indexPath.row] {
            cellInfo.isExpanded = isExpanded
        }
    }
}

extension NSIndexPath {
    
    private struct IndexPathVar {
        static var subRow = "key_index_path_subrow"
    }
    
    @nonobjc static let ParentRow = -1
    
    var subRow: Int {
        
        set {
            objc_setAssociatedObject(self, &IndexPathVar.subRow, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            let number = objc_getAssociatedObject(self, &IndexPathVar.subRow) as? Int
            return  number ?? 0
        }
    }
    
    static func indexPathForSubRow(subrow: Int, row: Int, section: Int) -> NSIndexPath {
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        indexPath.subRow = subrow
        
        return indexPath
    }
}

class RowInfo {
    init(isExpanded: Bool, subrowsCount: Int) {
        self.isExpanded = isExpanded
        self.subrowsCount = subrowsCount
    }
    
    var isExpanded = false
    var subrowsCount = 0
}
