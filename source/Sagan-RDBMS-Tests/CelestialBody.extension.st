Extension { #name : 'CelestialBody' }

{ #category : '*Sagan-RDBMS-Tests' }
CelestialBody >> = anObject [

	^ PersistentObjectComparer new shouldConsider: self asEqualTo: anObject
]

{ #category : '*Sagan-RDBMS-Tests' }
CelestialBody >> hash [ 

	^ PersistentObjectComparer new hashFor: self
]
