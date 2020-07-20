Extension { #name : #Nothing }

{ #category : #'*ConcurrentST-Channels' }
Nothing >> delay: outChannel init: anObject channel: inChannel [
	^ self class just: inChannel receive
]
