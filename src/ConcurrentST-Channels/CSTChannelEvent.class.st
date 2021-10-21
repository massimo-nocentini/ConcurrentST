Class {
	#name : #CSTChannelEvent,
	#superclass : #CSTChannel,
	#instVars : [
		'channel'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #'as yet unclassified' }
CSTChannelEvent >> channel: aChannel [

	channel := aChannel
]

{ #category : #'as yet unclassified' }
CSTChannelEvent >> receive [

	^ channel event receive sync
]

{ #category : #'as yet unclassified' }
CSTChannelEvent >> send: anObject [

	(channel event send: anObject) sync
]
