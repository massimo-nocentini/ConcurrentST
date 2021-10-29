Extension { #name : #Nothing }

{ #category : #'*ConcurrentST-Channels' }
Nothing >> delay: outChannel init: anObject channel: inChannel [

	^ Maybe just: inChannel receive
]
