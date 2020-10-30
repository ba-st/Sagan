Class {
	#name : #CelestialBody,
	#superclass : #Object,
	#instVars : [
		'sequentialNumber',
		'name',
		'planetarySystem',
		'galacticCoordinates'
	],
	#category : #'Sagan-Kepler-Tests'
}

{ #category : #'instance creation' }
CelestialBody class >> named: aName locatedAt: aGalacticCoordinates in: aPlanetarySystem [

	^ self new initializeNamed: aName locatedAt: aGalacticCoordinates in: aPlanetarySystem
]

{ #category : #accessing }
CelestialBody >> galacticCoordinates [

	^ galacticCoordinates
]

{ #category : #initialization }
CelestialBody >> initializeNamed: aName locatedAt: aGalacticCoordinates in: aPlanetarySystem [

	name := aName.
	galacticCoordinates := aGalacticCoordinates.
	planetarySystem := aPlanetarySystem
]

{ #category : #accessing }
CelestialBody >> name [
	^ name
]

{ #category : #accessing }
CelestialBody >> planetarySystem [

	^ planetarySystem
]
