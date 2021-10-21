"
A CSTCoroutineTest is a test class for testing the behavior of CSTCoroutine
"
Class {
	#name : #CSTLoopTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Tests'
}

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
