Extension { #name : #CSTRequestPut }

{ #category : #'*ConcurrentST-Cells' }
CSTRequestPut >> value: anObject forCSTCellRequestsReplyChannels: aCell [
	aCell value: anObject requestPut: self
]
