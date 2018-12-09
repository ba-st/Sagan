Extension { #name : #BlockClosure }

{ #category : #'*Sagan-Core' }
BlockClosure >> asMatchingCriteriaIn: aRepository [

	^ [ :object | self cull: object cull: aRepository matchingCriteriaBuilder ]
]
