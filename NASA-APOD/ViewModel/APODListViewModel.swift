//
//  APODListViewModel.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//

import Foundation

@MainActor
class APODListViewModel {
    
    enum State: Equatable {
        case loading
        case success
        case error(String)
    }
    
    private let apiService: APIService
    private(set) var featuredAPOD: APOD?
    private(set) var previousAPOD: APOD?
    private(set) var nextAPOD: APOD?
    private(set) var recentAPODs: [APOD] = []
    
    private var currentDate: Date
    private let initialDateString: String
    
    private(set) var state: State = .loading
    
    var onStateUpdate: ((State) -> Void)?
    var onSelectAPOD: ((APOD) -> Void)?
    var onSelectFeaturedAPOD: ((APOD) -> Void)?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    init(apiService: APIService = APIService(), initialDateString: String = "2024-07-20") {
        self.apiService = apiService
        self.initialDateString = initialDateString
        self.currentDate = dateFormatter.date(from: initialDateString)!
    }
    
    func fetchData(forceRefreshRecents: Bool = false) {
        if self.featuredAPOD == nil {
            self.state = .loading
            onStateUpdate?(.loading)
        }
        
        Task {
            do {
                if forceRefreshRecents {
                    self.recentAPODs = []
                }
                
                let (featured, previous, next, recents) = try await fetchAllData(for: self.currentDate)
                
                self.featuredAPOD = featured
                self.previousAPOD = previous
                self.nextAPOD = next
                if self.recentAPODs.isEmpty {
                    self.recentAPODs = recents.filter { $0.date != featured.date }
                }
                
                self.state = .success
                onStateUpdate?(.success)
                
            } catch {
                let errorMessage = (error as? NetworkError)?.userFriendlyMessage ?? "title.unknown.error".localized
                self.state = .error(errorMessage)
                onStateUpdate?(.error(errorMessage))
            }
        }
    }
    
    func refreshToLatest() {
        self.currentDate = dateFormatter.date(from: initialDateString)!
        fetchData(forceRefreshRecents: true)
    }
    
    func getPreviousDay() {
        guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { return }
        self.currentDate = previousDate
        fetchFeaturedAPOD(for: self.currentDate)
    }
    
    func getNextDay() {
        guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate),
              nextDate <= Date() else { return }
        self.currentDate = nextDate
        fetchFeaturedAPOD(for: self.currentDate)
    }
    
    func didSelect(apod: APOD) {
        onSelectAPOD?(apod)
    }
    
    func didSelectFeaturedAPOD() {
        guard let featured = self.featuredAPOD else { return }
        onSelectFeaturedAPOD?(featured)
    }
    
    private func fetchFeaturedAPOD(for date: Date) {
        Task {
            do {
                let dateString = dateFormatter.string(from: date)
                let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!

                async let featuredTask = apiService.fetchAPOD(for: dateString)
                async let previousTask = try? await apiService.fetchAPOD(for: dateFormatter.string(from: previousDate))
                async let nextTask = Calendar.current.compare(nextDate, to: Date(), toGranularity: .day) == .orderedDescending ? nil : (try? await apiService.fetchAPOD(for: dateFormatter.string(from: nextDate)))
                
                let (featured, previous, next) = try await (featuredTask, previousTask, nextTask)
                
                self.featuredAPOD = featured
                self.previousAPOD = previous
                self.nextAPOD = next
                
                self.state = .success
                onStateUpdate?(.success)
                
            } catch {
                let errorMessage = (error as? NetworkError)?.userFriendlyMessage ?? "title.unknown.error".localized
                self.state = .error(errorMessage)
                onStateUpdate?(.error(errorMessage))
            }
        }
    }
    
    private func fetchAllData(for date: Date) async throws -> (APOD, APOD?, APOD?, [APOD]) {
        let dateString = dateFormatter.string(from: date)
        
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        
        async let featuredTask = apiService.fetchAPOD(for: dateString)
        async let previousTask = try? await apiService.fetchAPOD(for: dateFormatter.string(from: previousDate))
        async let nextTask = Calendar.current.compare(nextDate, to: Date(), toGranularity: .day) == .orderedDescending ? nil : (try? await apiService.fetchAPOD(for: dateFormatter.string(from: nextDate)))
        async let recentsTask = self.recentAPODs.isEmpty ? (try await apiService.fetchAPODs(count: 20)) : self.recentAPODs
        
        let (featured, previous, next, recents) = try await (featuredTask, previousTask, nextTask, recentsTask)
        
        return (featured, previous, next, recents)
    }
}
