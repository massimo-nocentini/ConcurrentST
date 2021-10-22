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
		assert: [ :loop | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := (loop cell
					         requestChannel: loop channel
					         replyChannel: loop channel)
					        init: 0;
					        yourself ] ] concurrentST
		equals: #(  ).
	self
		assert: [ :loop | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := (loop cell
					         requestChannel: loop channel
					         replyChannel: loop channel)
					        init: 0;
					        yourself.

				aStream nextPut: cell get ] ] concurrentST
		equals: #( 0 ).
	self
		assert: [ :loop | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := (loop cell
					         requestChannel: loop channel
					         replyChannel: loop channel)
					        init: 0;
					        yourself.

				aStream
					nextPut: cell get;
					nextPut: cell get ] ] concurrentST
		equals: #( 0 0 ).
	self
		assert: [ :loop | 
			Array streamContents: [ :aStream | 
				| cell |
				cell := (loop cell
					         requestChannel: loop channel
					         replyChannel: loop channel)
					        init: 0;
					        yourself.

				aStream nextPut: cell get.
				cell put: 1.
				aStream
					nextPut: cell get;
					nextPut: cell get ] ] concurrentST
		equals: #( 0 1 1 )
]
