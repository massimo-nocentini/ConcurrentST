Class {
	#name : #CSTChannel,
	#superclass : #Object,
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannel class >> naturalsFrom: init coroutine: co [
	"Another implementation could be:
	
	channel := co channel.
	co spawn: [ 
		| i |
		i := init.
		[ 
		channel send: i.
		i := i + 1 ] repeat ].
	"

	| channel |
	channel := CSTChannelNaturals new
		           channel: co channel;
		           yourself.
	co spawn: [ channel count: init ].
	^ channel
]
