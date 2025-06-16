//
//  NetworkStatusService.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//

import Foundation
import Reachability
import RxSwift
import RxCocoa

class ReachabilityService {
    static let shared = ReachabilityService()

    private let reachability: Reachability
    private let reachabilitySubject = BehaviorSubject<Bool>(value: true)

    var isReachable: Observable<Bool> {
        return reachabilitySubject.asObservable()
    }

    private init() {
        reachability = try! Reachability()

        reachability.whenReachable = { _ in
            self.reachabilitySubject.onNext(true)
        }

        reachability.whenUnreachable = { _ in
            self.reachabilitySubject.onNext(false)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
