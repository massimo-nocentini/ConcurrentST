Extension { #name : #BlockClosure }

{ #category : #'*ConcurrentST-Extensions' }
BlockClosure >> <- anObject [
	^ anObject prependBlock: self
]
