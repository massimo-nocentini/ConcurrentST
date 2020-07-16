"
A CSTChannelTest is a test class for testing the behavior of CSTChannel
"
Class {
	#name : #CSTChannelTest,
	#superclass : #TestCase,
	#category : #'ConcurrentST-Channels-Tests'
}

{ #category : #tests }
CSTChannelTest >> naturals: s channel: channel [
	channel send: s.
	^ self naturals: s + 1 channel: channel
]

{ #category : #tests }
CSTChannelTest >> naturalsOnChannel: natsChannel [
	| i |
	i := 0.
	[ 
	natsChannel send: i.
	i := i + 1 ] repeat
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbers [
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel thread |
				natsChannel := co channel.
				thread := co spawn: [ self naturalsOnChannel: natsChannel ].
				natsChannel next: n ] coroutine
			equals: (0 to: n - 1) ]
]

{ #category : #tests }
CSTChannelTest >> testNaturalNumbersRecursionSlow [
	10000 in: [ :n | 
		self
			assert: [ :co | 
				| natsChannel thread |
				natsChannel := co channel.
				thread := co spawn: [ self naturals: 0 channel: natsChannel ].
				natsChannel next: n ] coroutine
			equals: (0 to: n - 1) ]
]
