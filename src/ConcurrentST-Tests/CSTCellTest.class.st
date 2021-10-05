"
A CSTCellTest is a test class for testing the behavior of CSTCell
"
Class {
	#name : #CSTCellTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Tests'
}

{ #category : #tests }
CSTCellTest >> testUpdatableCell [
	self
		assert: [ :co | 
			Array streamContents: [ :aStream | 
				CSTCell requestsReplyChannelsOn: 0 coroutine: co ] ] concurrentST
		equals: #(  ).
	self
		assert: [ :co | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := CSTCell requestsReplyChannelsOn: 0 coroutine: co.
				aStream nextPut: cell get ] ] concurrentST
		equals: #( 0 ).
	self
		assert: [ :co | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := CSTCell requestsReplyChannelsOn: 0 coroutine: co.
				aStream
					nextPut: cell get;
					nextPut: cell get ] ] concurrentST
		equals: #( 0 0 ).
	self
		assert: [ :co | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := CSTCell requestsReplyChannelsOn: 0 coroutine: co.
				aStream nextPut: cell get.
				cell put: 1.
				aStream
					nextPut: cell get;
					nextPut: cell get ] ] concurrentST
		equals: #( 0 1 1 )
]
