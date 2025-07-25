//
//  UITableView+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UITableView+YYAdd.
//

import UIKit

extension UITableView {
    /// 批量更新
    func updateWithBlock(_ block: (UITableView) -> Void) {
        beginUpdates()
        block(self)
        endUpdates()
    }
    /// 滚动到指定行
    func scrollToRow(_ row: Int, inSection section: Int, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        let indexPath = IndexPath(row: row, section: section)
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    /// 插入行
    func insertRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        insertRows(at: [indexPath], with: animation)
    }
    func insertRow(_ row: Int, inSection section: Int, with animation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        insertRow(at: indexPath, with: animation)
    }
    /// 刷新行
    func reloadRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        reloadRows(at: [indexPath], with: animation)
    }
    func reloadRow(_ row: Int, inSection section: Int, with animation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        reloadRow(at: indexPath, with: animation)
    }
    /// 删除行
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        deleteRows(at: [indexPath], with: animation)
    }
    func deleteRow(_ row: Int, inSection section: Int, with animation: UITableView.RowAnimation) {
        let indexPath = IndexPath(row: row, section: section)
        deleteRow(at: indexPath, with: animation)
    }
    /// 插入段
    func insertSection(_ section: Int, with animation: UITableView.RowAnimation) {
        let sections = IndexSet(integer: section)
        insertSections(sections, with: animation)
    }
    /// 删除段
    func deleteSection(_ section: Int, with animation: UITableView.RowAnimation) {
        let sections = IndexSet(integer: section)
        deleteSections(sections, with: animation)
    }
    /// 刷新段
    func reloadSection(_ section: Int, with animation: UITableView.RowAnimation) {
        let sections = IndexSet(integer: section)
        reloadSections(sections, with: animation)
    }
    /// 清空所有选中行
    func clearSelectedRows(animated: Bool) {
        guard let indexPaths = indexPathsForSelectedRows else { return }
        for path in indexPaths {
            deselectRow(at: path, animated: animated)
        }
    }
} 