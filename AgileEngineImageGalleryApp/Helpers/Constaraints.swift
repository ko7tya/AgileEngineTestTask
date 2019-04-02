//
//  Constaraints.swift
//  Ward
//
//  Created by Kostyantin Ischenko on 2/12/19.
//  Copyright © 2019 Kostya. All rights reserved.
//

import Foundation
import UIKit

public enum ConstraintRelation {
    case equal, greaterThanOrEqual, lessThanOrEqual
}

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

func equalCenterX(child: UIView, parent: UIView) -> NSLayoutConstraint {
    return child.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
}

func equalCenterY(child: UIView, parent: UIView) -> NSLayoutConstraint {
    return child.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
}

func equal<Axis, L>(_ from: KeyPath<UIView, L>, _ to: KeyPath<UIView, L>) -> Constraint where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: from].constraint(equalTo: parent[keyPath: to])
    }
}

//func equal<Axis, L>(_ to: KeyPath<UIView, L>) -> Constraint  where L: NSLayoutAnchor<Axis> {
//    return { view, parent in
//        view[keyPath: to].constraint(equalTo: parent[keyPath: to])
//    }
//}

func equal<L>(_ keyPath: KeyPath<UIView, L>, to constant: CGFloat) -> Constraint  where L: NSLayoutDimension {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

func equal<Axis, L>(_ to: KeyPath<UIView, L>, to constraint: NSLayoutAnchor<Axis>) -> Constraint  where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: to].constraint(equalTo: constraint)
    }
}

func equal<Axis, L>(_ to: KeyPath<UIView, L>,
                    relation: ConstraintRelation = .equal,
                    constant: CGFloat = 0) -> Constraint  where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        switch relation {
        case .equal:
            return view[keyPath: to].constraint(equalTo: parent[keyPath: to], constant: constant)
        case .lessThanOrEqual:
            return view[keyPath: to].constraint(lessThanOrEqualTo: parent[keyPath: to], constant: constant)
        case .greaterThanOrEqual:
            return view[keyPath: to].constraint(greaterThanOrEqualTo: parent[keyPath: to], constant: constant)
        }
    }
}

func equal<Axis, L>(_ to: KeyPath<UIView, L>,
                    to constraint: NSLayoutAnchor<Axis>,
                    constant: CGFloat) -> Constraint  where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: to].constraint(equalTo: constraint, constant: constant)
    }
}

func equal<Axis, L>(_ to: KeyPath<UIView, L>, to constant: CGFloat) -> Constraint  where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: to].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

func equalParent() -> [Constraint] {
    return [equal(\.topAnchor),
            equal(\.leftAnchor),
            equal(\.rightAnchor),
            equal(\.bottomAnchor)]
}

extension UIView {
    func addSubview(_ other: UIView, constraints: [Constraint]) {
        addSubview(other)
        other.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { c in
            c(other, self)
        })
    }
}
