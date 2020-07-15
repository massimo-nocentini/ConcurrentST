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
CSTCellRequestsReplyChannels >> loop: anObject [
	requestsChannel receive
		loop: anObject
		forCSTCellRequestsReplyChannels: self
]

{ #category : #common }
CSTCellRequestsReplyChannels >> loop: anObject requestGet: aRequest [
	replyChannel send: anObject.
	self loop: anObject
]

{ #category : #common }
CSTCellRequestsReplyChannels >> loop: anObject requestPut: aRequest [
	self loop: aRequest payload
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
