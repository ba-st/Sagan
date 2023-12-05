Extension { #name : 'ExtraterrestialRace' }

{ #category : '*Sagan-RDBMS-Tests' }
ExtraterrestialRace >> = anObject [

	^ PersistentObjectComparer new shouldConsider: self asEqualTo: anObject
]

{ #category : '*Sagan-RDBMS-Tests' }
ExtraterrestialRace >> hash [ 

	^ PersistentObjectComparer new hashFor: self
]
