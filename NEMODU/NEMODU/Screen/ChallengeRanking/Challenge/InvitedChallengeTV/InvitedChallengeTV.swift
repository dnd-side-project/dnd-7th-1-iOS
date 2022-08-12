//
//  InvitedChallengeTV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeTV : UITableView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        delegate = self
        dataSource = self
        
        register(SearchHistoryTVHeaderView.self, forHeaderFooterViewReuseIdentifier: Identify.SearchHistoryTVHeaderView)
        register(SearchHistoryTVCell.self, forCellReuseIdentifier: Identify.SearchHistoryTVCell)
        tableFooterView = nil
        
        backgroundColor = .white
        separatorColor = .clear
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        keyboardDismissMode = .onDrag
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTableView(sender:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
}

    // MARK: - TableView Delegate / DataSource

extension InvitedChallengeTV : UITableViewDelegate, UITableViewDataSource {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identify.SearchHistoryTVHeaderView) as? SearchHistoryTVHeaderView
        headerView?.searchHistoryTV = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postItems = searchVC?.searchHistoryList.count ?? 0
        
        if postItems == 0 {
            setEmptyView(title: "", message: "검색 기록이 없습니다")
            self.isScrollEnabled = false
        } else {
            restore()
            self.isScrollEnabled = true
        }
        
        return postItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SearchHistoryTVCell, for: indexPath) as! SearchHistoryTVCell
        cell.selectionStyle = .none
        cell.searchHistoryTV = self
        
        cell.indexPath = indexPath.row
        cell.keywordHistoryLabel.text = searchVC?.searchHistoryList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKeyword = searchVC?.searchHistoryList[indexPath.row] ?? ""
        
        let searchResultVC = SearchResultVC()
        searchResultVC.afterSetKeyword(keyword: selectedKeyword)
        searchVC?.saveSearchKeyword(toSaveKeyword: selectedKeyword)
        
        searchVC?.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .clear
        
        return fakeView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}
