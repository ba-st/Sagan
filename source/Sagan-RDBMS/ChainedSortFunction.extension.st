Extension { #name : 'ChainedSortFunction' }

{ #category : '*Sagan-RDBMS' }
ChainedSortFunction >> asOrderByIn: aQuery [

	baseSortFunction asOrderByIn: aQuery.
	nextFunction asOrderByIn: aQuery
]

{ #category : '*Sagan-RDBMS' }
ChainedSortFunction >> asReversedOrderByIn: aQuery [

	baseSortFunction asReversedOrderByIn: aQuery.
	nextFunction asReversedOrderByIn: aQuery
]
