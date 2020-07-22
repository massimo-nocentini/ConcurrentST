Class {
	#name : #CSTMessageWithThread,
	#superclass : #Object,
	#instVars : [
		'msg',
		'thread'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #comparing }
CSTMessageWithThread >> <= anObject [
	^ anObject greaterThanSynchronousMessage: self
]

{ #category : #comparing }
CSTMessageWithThread >> greaterThanSynchronousMessage: aMessage [
	^ msg > aMessage msg
]

{ #category : #accessing }
CSTMessageWithThread >> msg [
	^ msg
]

{ #category : #accessing }
CSTMessageWithThread >> msg: anObject [
	msg := anObject
]

{ #category : #accessing }
CSTMessageWithThread >> thread [
	^ thread
]

{ #category : #accessing }
CSTMessageWithThread >> thread: anObject [
	thread := anObject
]
