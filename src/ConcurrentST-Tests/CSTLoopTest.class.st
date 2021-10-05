"
A CSTCoroutineTest is a test class for testing the behavior of CSTCoroutine
"
Class {
	#name : #CSTLoopTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Tests'
}

{ #category : #tests }
CSTLoopTest >> testSpawn [

	| thread |
	thread := [ :co | co spawn: [ co spawn: [ 4 ] ] ] concurrentST.
	self
		assert: thread class equals: CSTThread;
		assert: thread id equals: 2
]

{ #category : #tests }
CSTLoopTest >> testSpawnThenReturn [

	self
		assert: [ :co | 
			co spawn: [ co spawn: [ 4 ] ].
			3 ] concurrentST
		equals: 3
]
