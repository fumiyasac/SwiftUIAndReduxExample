//
//  ContentRouter.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/02/12.
//

import SwiftUI

final class ContentRouter {}

// MARK: - RouteToContentContract

protocol RouteToContentContract {
    func routeToHome() -> HomeScreenView
    func routeToArchive() -> ArchiveScreenView
    func routeToFavorite() -> FavoriteScreenView
    func routeToProfile() -> ProfileScreenView
}

// MARK: - ContentRouter

extension ContentRouter: RouteToContentContract {
    func routeToHome() -> HomeScreenView {
        return HomeScreenView()
    }

    func routeToArchive() -> ArchiveScreenView {
        return ArchiveScreenView()
    }

    func routeToFavorite() -> FavoriteScreenView {
        return FavoriteScreenView()
    }

    func routeToProfile() -> ProfileScreenView {
        return ProfileScreenView()
    }
}
