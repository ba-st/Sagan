Extension { #name : 'BlockClosure' }

{ #category : '*Sagan-Extensions' }
BlockClosure >> asMatchingCriteriaIn: aRepository [

	^ [ :object | self cull: object cull: aRepository matchingCriteriaBuilder ]
]
