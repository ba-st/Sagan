Class {
	#name : #ExtraterrestialRace,
	#superclass : #Object,
	#instVars : [
		'sequentialNumber',
		'name',
		'knownLocations'
	],
	#category : #'Sagan-Kepler-Tests'
}

{ #category : #'instance creation' }
ExtraterrestialRace class >> named: aName foundIn: aListOfCelestialBodies [ 

	^self new initializeNamed: aName foundIn: aListOfCelestialBodies 
]

{ #category : #comparing }
ExtraterrestialRace >> = anObject [

	^ PersistentObjectComparer new shouldConsider: self asEqualTo: anObject
]

{ #category : #comparing }
ExtraterrestialRace >> hash [ 

	^ PersistentObjectComparer new hashFor: self
]

{ #category : #initialization }
ExtraterrestialRace >> initializeNamed: aName foundIn: aListOfCelestialBodies [ 
	
	name := aName. 
	knownLocations := aListOfCelestialBodies.
]

{ #category : #accessing }
ExtraterrestialRace >> knownLocations [

	^ knownLocations
]

{ #category : #accessing }
ExtraterrestialRace >> name [

	^ name
]

{ #category : #comparing }
ExtraterrestialRace >> sequentialNumber [

	^ sequentialNumber
]
