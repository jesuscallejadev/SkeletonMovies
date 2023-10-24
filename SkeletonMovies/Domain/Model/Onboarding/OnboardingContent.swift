//
//  OnboardingContent.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import Foundation

class OnboardingContent {
    static var onboardingScenes: [OnboardingScene] {
        var list: [OnboardingScene] = []
        list.append(OnboardingScene(id: Constants.OnboardingIds.onboardingIdFirst, mainTitle: Localize().get("onboarding_first_text"), animationName: Constants.AnimationsIds.animationFirst))
        list.append(OnboardingScene(id: Constants.OnboardingIds.onboardingIdSecond, mainTitle: Localize().get("onboarding_second_text"), animationName: Constants.AnimationsIds.animationSecond))
        list.append(OnboardingScene(id: Constants.OnboardingIds.onboardingIdThird, mainTitle: Localize().get("onboarding_third_text"), animationName: Constants.AnimationsIds.animationThird))
        return list
    }
}
