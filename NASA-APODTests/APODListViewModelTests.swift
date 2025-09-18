//
//  APODListViewModelTests.swift
//  NASA-APOD
//
//  Created by Felipe Almeida on 18/09/25.
//
import XCTest
@testable import NASA_APOD

@MainActor
final class APODListViewModelTests: XCTestCase {

    var viewModel: APODListViewModel!
    var mockApiService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockApiService = MockAPIService()
        viewModel = APODListViewModel(apiService: mockApiService, initialDateString: "2024-09-15")
    }

    override func tearDown() {
        viewModel = nil
        mockApiService = nil
        super.tearDown()
    }

    func testFetchData_Success() async {
        // Given
        mockApiService.shouldReturnError = false
        var finalState: APODListViewModel.State?
        let expectation = XCTestExpectation(description: "Fetch data succeeds")
        
        viewModel.onStateUpdate = { state in
            if case .success = state {
                finalState = state
                expectation.fulfill()
            }
        }

        // When
        viewModel.fetchData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(finalState)
        
        // ✅ A COMPARAÇÃO AGORA FUNCIONA
        if case .success(let featured, let recents) = finalState {
            XCTAssertEqual(featured.title, "Featured Mock")
            XCTAssertEqual(recents.count, 1)
            XCTAssertEqual(viewModel.previousAPOD?.title, "Previous Mock")
            XCTAssertEqual(viewModel.nextAPOD?.title, "Next Mock")
        } else {
            XCTFail("Expected success state, but got \(String(describing: finalState))")
        }
    }
    
    func testFetchData_Failure() async {
        // Given
        mockApiService.shouldReturnError = true
        var finalState: APODListViewModel.State?
        let expectation = XCTestExpectation(description: "Fetch data fails")

        viewModel.onStateUpdate = { state in
            if case .error = state {
                finalState = state
                expectation.fulfill()
            }
        }

        // When
        viewModel.fetchData()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertNotNil(finalState)
        if case .error(let message) = finalState {
            let expectedMessage = NetworkError.requestFailed(NSError()).userFriendlyMessage
            XCTAssertEqual(message, expectedMessage)
        } else {
            XCTFail("Expected error state, but got \(String(describing: finalState))")
        }
    }
    
    func testGetPreviousDay_UpdatesFeaturedAPOD() async {
        // Given
        var finalState: APODListViewModel.State?
        let expectation = XCTestExpectation(description: "Fetch previous day succeeds")
        
        viewModel.onStateUpdate = { state in
            if case .success(let featured, _) = state {
                if featured.date == "2024-09-14" {
                    finalState = state
                    expectation.fulfill()
                }
            }
        }
        
        // When
        viewModel.getPreviousDay()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(finalState)
        if case .success(let featured, _) = finalState {
            XCTAssertEqual(featured.title, "Previous Mock")
        } else {
            XCTFail("Expected to fetch the previous day's APOD")
        }
    }
}
