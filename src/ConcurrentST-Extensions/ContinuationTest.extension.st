Extension { #name : #ContinuationTest }

{ #category : #'*ConcurrentST-Extensions' }
ContinuationTest >> testPrependBlock [
	self
		assert: (Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | v + 1 ] <- k.
				 2 + (kk value: 3) ])
		equals: 4.
	self
		assert: (Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | v + 1 ] <- k.
				 (k value: 2) + (kk value: 3) ])
		equals: 2.
	self
		assert: (Continuation currentDo: [ :k | 
				 | kk |
				 kk := [ :v | v + 1 ] <- k.
				 (kk value: 3) + (k value: 2) ])
		equals: 4
]
