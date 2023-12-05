Class {
	#name : 'GalacticCoordinates',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'z'
	],
	#category : 'Sagan-Kepler-Tests',
	#package : 'Sagan-Kepler-Tests'
}

{ #category : 'instance creation' }
GalacticCoordinates class >> x: anXValue y: anYValue z: aZValue [

	^ self new initializex: anXValue y: anYValue z: aZValue
]

{ #category : 'initialization' }
GalacticCoordinates >> initializex: anXValue y: anYValue z: aZValue [

	x := anXValue.
	y := anYValue.
	z := aZValue
]

{ #category : 'accessing' }
GalacticCoordinates >> x [

	^ x
]

{ #category : 'accessing' }
GalacticCoordinates >> y [

	^ y
]

{ #category : 'accessing' }
GalacticCoordinates >> z [

	^ z
]
