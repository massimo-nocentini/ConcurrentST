Class {
	#name : #CSTMessageWithThreadWithDigest,
	#superclass : #CSTMessageWithThread,
	#instVars : [
		'digest'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #accessing }
CSTMessageWithThreadWithDigest >> digest [
	^ digest
]

{ #category : #accessing }
CSTMessageWithThreadWithDigest >> digest: anObject [
	digest := anObject
]
