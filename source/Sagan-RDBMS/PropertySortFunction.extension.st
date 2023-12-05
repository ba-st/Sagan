Extension { #name : 'PropertySortFunction' }

{ #category : '*Sagan-RDBMS' }
PropertySortFunction >> asOrderByIn: aQuery [

	aQuery orderBy: property
]

{ #category : '*Sagan-RDBMS' }
PropertySortFunction >> asReversedOrderByIn: aQuery [

	aQuery orderBy: [:object | (property value: object) descending ]
]
