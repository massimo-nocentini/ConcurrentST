Extension { #name : #CSTRequestPut }

{ #category : #'*ConcurrentST-Cells' }
CSTRequestPut >> loop: anObject forCSTCellRequestsReplyChannels: aCell [
	aCell loop: anObject requestPut: self
]
