Extension { #name : #Coroutine }

{ #category : #'*ConcurrentST' }
Coroutine >> prependBlock: aBlock [

	^ self class currentDo: [ :k1 | 
		  self value:
			  (aBlock value: (self class currentDo: [ :k2 | k1 value: k2 ])) ]
]
