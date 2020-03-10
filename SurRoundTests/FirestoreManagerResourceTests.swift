//
//  FirestoreManagerTests.swift
//  SurRoundTests
//
//  Created by Charles Hsieh on 2020/3/10.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import XCTest
import Firebase

@testable import SurRound

class FirestoreManagerResourceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testResource_validPath_shouldReturnWithNoError() {
        
        let resource = ResourceValidPathStub()
        
        let expectedCollection = Firestore.firestore().collection("posts").document("!QAZ@WSX#EDC").collection("reviews")
        let expectedDocument = Firestore.firestore().collection("posts").document("!QAZ@WSX#EDC")
        
        XCTAssertNoThrow(try resource.collectionReference())
        XCTAssertNoThrow(try resource.documentReference())
        
        let collectionOutput = try? resource.collectionReference()
        let documentOutput = try? resource.documentReference()
        
        XCTAssertEqual(collectionOutput, expectedCollection)
        XCTAssertEqual(documentOutput, expectedDocument)
    }
    
    func testResource_invalidPath_shouldThrowError() {
        
        let resource = ResourceInvalidPathStub()
        
        XCTAssertThrowsError(try resource.collectionReference())
        XCTAssertThrowsError(try resource.documentReference())
        
        let collectionOutput = try? resource.collectionReference()
        let documentOutput = try? resource.documentReference()
        
        XCTAssertNil(collectionOutput)
        XCTAssertNil(documentOutput)
    }
}

struct ResourceValidPathStub: Resource {
    
    var paths: [Path] = [
        .collection("posts"),
        .document("!QAZ@WSX#EDC"),
        .collection("reviews")
    ]
    
    var action: Action = .fetch
    
    var conditions: [Condition] = []
}

struct ResourceInvalidPathStub: Resource {
    
    var paths: [Path] = [
        .document("!QAZ@WSX#EDC"),
        .collection("reviews")
    ]
    
    var action: Action = .fetch
    
    var conditions: [Condition] = []
}
