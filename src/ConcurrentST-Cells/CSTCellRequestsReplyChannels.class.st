Class {
	#name : #CSTCellRequestsReplyChannels,
	#superclass : #CSTCell,
	#instVars : [
		'requestsChannel',
		'replyChannel'
	],
	#category : #'ConcurrentST-Cells'
}

{ #category : #'actions api' }
CSTCellRequestsReplyChannels >> get [
	requestsChannel send: CSTRequest get.
	^ replyChannel receive
]

{ #category : #common }
CSTCellRequestsReplyChannels >> init: anObject [

	loop spawnPreemptive: [ self value: anObject ]
]

{ #category : #'actions api' }
CSTCellRequestsReplyChannels >> put: anObject [
	requestsChannel send: (CSTRequest put: anObject)
]

{ #category : #accessing }
CSTCellRequestsReplyChannels >> replyChannel: anObject [
	replyChannel := anObject
]

{ #category : #accessing }
CSTCellRequestsReplyChannels >> requestsChannel: anObject [
	requestsChannel := anObject
]

{ #category : #common }
CSTCellRequestsReplyChannels >> value: anObject [

	requestsChannel receive
		value: anObject
		forCSTCellRequestsReplyChannels: self
]

{ #category : #common }
CSTCellRequestsReplyChannels >> value: anObject requestGet: aRequest [

	replyChannel send: anObject.
	self value: anObject
]

{ #category : #common }
CSTCellRequestsReplyChannels >> value: anObject requestPut: aRequest [

	self value: aRequest payload
]
