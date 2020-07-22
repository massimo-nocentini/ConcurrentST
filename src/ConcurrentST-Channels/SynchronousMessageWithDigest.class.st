Class {
	#name : #SynchronousMessageWithDigest,
	#superclass : #SynchronousMessage,
	#instVars : [
		'digest'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #accessing }
SynchronousMessageWithDigest >> digest [
	^ digest
]

{ #category : #accessing }
SynchronousMessageWithDigest >> digest: anObject [
	digest := anObject
]
