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
CSTChannelEvent >> pollMessages [

	^ channel pollMessages
]

{ #category : #'as yet unclassified' }
CSTChannelEvent >> pollThreads [

	^ channel pollThreads
]

{ #category : #api }
CSTChannelEvent >> popMessage [

	^ channel popMessage
]

{ #category : #api }
CSTChannelEvent >> popThread [

	^ channel popThread
]

{ #category : #api }
CSTChannelEvent >> pushMessage: anObj [

	^ channel pushMessage: anObj
]

{ #category : #api }
CSTChannelEvent >> pushThread: anObj [

	^ channel pushThread: anObj
]

{ #category : #'as yet unclassified' }
CSTChannelEvent >> receive [

	^ channel event receive sync
]

{ #category : #'as yet unclassified' }
CSTChannelEvent >> send: anObject [

	(channel event send: anObject) sync
]
