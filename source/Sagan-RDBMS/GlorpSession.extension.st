Extension { #name : 'GlorpSession' }

{ #category : '*Sagan-RDBMS' }
GlorpSession >> dropAll: aCollection onErrorDo: aBlock [

	"Drop the tables for our descriptor system, and their associated sequences."

	( TableSorter for: aCollection ) sort reverse
		do: [ :table | accessor dropTable: table ifError: aBlock ].

	system platform areSequencesExplicitlyCreated
		ifTrue: [ ( self system allSequencesFor: aCollection )
				do: [ :each | accessor dropSequence: each ifAbsent: aBlock ]
			]
]

{ #category : '*Sagan-RDBMS' }
GlorpSession >> dropAllTablesOnErrorDo: aBlock [
	"Drop the tables for our descriptor system, and their associated sequences."

	self dropAll: system allTables onErrorDo: aBlock
]
