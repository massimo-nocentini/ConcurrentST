Extension { #name : #CSTRequest }

{ #category : #'*ConcurrentST-Cells' }
CSTRequest >> loop: anObject forCSTCellRequestsReplyChannels: aCell [
	self subclassResponsibility
]
