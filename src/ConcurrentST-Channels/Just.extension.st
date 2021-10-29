Extension { #name : #Just }

{ #category : #'*ConcurrentST-Channels' }
Just >> delay: outChannel init: anObject channel: inChannel [

	outChannel send: content.
	^ Maybe nothing
]
