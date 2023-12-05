Class {
	#name : 'ExtraterrestialRace',
	#superclass : 'Object',
	#instVars : [
		'sequentialNumber',
		'name',
		'knownLocations'
	],
	#category : 'Sagan-Kepler-Tests',
	#package : 'Sagan-Kepler-Tests'
}

{ #category : 'instance creation' }
ExtraterrestialRace class >> named: aName foundIn: aListOfCelestialBodies [ 

	^self new initializeNamed: aName foundIn: aListOfCelestialBodies 
]

{ #category : 'initialization' }
ExtraterrestialRace >> initializeNamed: aName foundIn: aListOfCelestialBodies [ 
	
	name := aName. 
	knownLocations := aListOfCelestialBodies.
]

{ #category : 'accessing' }
ExtraterrestialRace >> knownLocations [

	^ knownLocations
]

{ #category : 'accessing' }
ExtraterrestialRace >> name [

	^ name
]

{ #category : 'comparing' }
ExtraterrestialRace >> sequentialNumber [

	^ sequentialNumber
]
