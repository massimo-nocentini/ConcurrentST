"
A CSTCoroutineTest is a test class for testing the behavior of CSTCoroutine
"
Class {
	#name : #CSTLoopTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Tests'
}

{ #category : #tests }
CSTLoopTest >> testEventCornellServerExample [

	"http://www.cs.cornell.edu/courses/cs312/2007sp/lectures/lec27.html"

	self
		assert: [ :loop | 
			| c1 c2 e1 e2 o |
			c1 := loop channel forEvents.
			c2 := loop channel forEvents.

			e1 := c1 event receive.
			e2 := c2 event receive.

			o := loop channel.

			loop
				spawnPreemptive: [ c1 send: 100 ];
				spawnPreemptive: [ c2 send: 100 ];
				spawnPreemptive: [ 
					| savings checking |
					savings := 1000.
					checking := 1000.

					[ 
					| amount |
					amount := (loop event choose: { 
								           e1.
								           e2 }) sync.

					savings := savings - amount.
					checking := checking + amount.

					o send: { 
								savings.
								checking } ] repeat ].

			o next: 1 ] concurrentST
		equals: #( #( 900 1100 ) )
]

{ #category : #tests }
CSTLoopTest >> testEventNever [

	self
		should: [ [ :loop | loop event never sync ] concurrentST ]
		raise: CollectionIsEmpty
]

{ #category : #tests }
CSTLoopTest >> testEventSimpleSendReceive [

	| value |
	value := Object new.

	self
		assert: [ :loop | 
			| channel |
			channel := loop channel.

			loop spawnPreemptive: [ (channel event send: value) sync ].

			(loop event choose: { 
					 loop event never.
					 channel event receive }) sync ] concurrentST
		equals: value
]

{ #category : #tests }
CSTLoopTest >> testEventSimpleSendReceiveWithEventChannel [

	| value |
	value := Object new.

	self
		assert: [ :loop | 
			| channel |
			channel := loop channel forEvents.

			loop spawnPreemptive: [ channel send: value ].

			(loop event choose: { 
					 loop event never.
					 channel event receive }) sync ] concurrentST
		equals: value
]

{ #category : #tests }
CSTLoopTest >> testEventSimpleSendReceiveWrongSend [

	| value |
	value := Object new.

	self
		should: [ 
			[ :loop | 
			| channel |
			channel := loop channel.

			(channel event send: value) sync.

			(loop event choose: { 
					 loop event never.
					 channel event receive }) sync ] concurrentST ]
		raise: CollectionIsEmpty
]

{ #category : #tests }
CSTLoopTest >> testSpawn [

	| thread |
	thread := [ :co | co spawnPreemptive: [ co spawnPreemptive: [ 4 ] ] ] concurrentST.
	self
		assert: thread class equals: CSTThread;
		assert: thread id equals: 2
]

{ #category : #tests }
CSTLoopTest >> testSpawnThenReturn [

	self
		assert: [ :co | 
			co spawnPreemptive: [ co spawnPreemptive: [ 4 ] ].
			3 ] concurrentST
		equals: 3
]
