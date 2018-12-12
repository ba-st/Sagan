Extension { #name : #ReverseSortFunction }

{ #category : #'*Sagan-RDBMS' }
ReverseSortFunction >> asOrderByIn: aQuery [

	baseSortFunction asReversedOrderByIn: aQuery
]

{ #category : #'*Sagan-RDBMS' }
ReverseSortFunction >> asReversedOrderByIn: aQuery [

	baseSortFunction asOrderByIn: aQuery
]
