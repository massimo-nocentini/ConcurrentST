Class {
	#name : #SynchronousMessage,
	#superclass : #Object,
	#instVars : [
		'msg',
		'thread'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #comparing }
SynchronousMessage >> <= anObject [
	^ anObject greaterThanSynchronousMessage: self
]

{ #category : #comparing }
SynchronousMessage >> greaterThanSynchronousMessage: aMessage [
	^ msg > aMessage msg
]

{ #category : #accessing }
SynchronousMessage >> msg [
	^ msg
]

{ #category : #accessing }
SynchronousMessage >> msg: anObject [
	msg := anObject
]

{ #category : #accessing }
SynchronousMessage >> thread [
	^ thread
]

{ #category : #accessing }
SynchronousMessage >> thread: anObject [
	thread := anObject
]
