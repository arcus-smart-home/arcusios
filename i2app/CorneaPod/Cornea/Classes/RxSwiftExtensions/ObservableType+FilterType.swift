//
//  ObservableType+FilterType.swift
//  Pods
//
//  Created by Arcus Team on 4/18/18.
//

import RxSwift

public extension ObservableType {

  /**
   Filters the elements of an observable sequence based on a Generic Type

   - returns: An observable sequence that contains elements from the input sequence
   that are of the specified type.
   */
  public func filter<T>(type: T.Type) -> Observable<T> {
    return filter {
      print("\(T.Type)")
      return $0 is T.Type
      }.map {
        return $0 as! T
    }
  }
}
