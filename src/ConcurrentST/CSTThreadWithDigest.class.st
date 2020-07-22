Class {
	#name : #CSTThreadWithDigest,
	#superclass : #CSTThread,
	#instVars : [
		'digest'
	],
	#category : #ConcurrentST
}

{ #category : #accessing }
CSTThreadWithDigest >> digest: anObject [
	digest := anObject
]

{ #category : #'as yet unclassified' }
CSTThreadWithDigest >> throw: msg [
	^ super throw: (SynchronousMessageWithDigest new
			   thread: self;
			   msg: msg;
			   digest: digest;
			   yourself)
]
