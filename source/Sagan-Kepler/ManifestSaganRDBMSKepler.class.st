"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSaganRDBMSKepler,
	#superclass : #PackageManifest,
	#category : #'Sagan-Kepler-Manifest'
}

{ #category : #'class initialization' }
ManifestSaganRDBMSKepler class >> initialize [

	Kepler
		registerInterfaceAt: #RepositoryProviderSystem 
		named: 'Repository Provider System Interface'
		declaring: #(
			createRepositoryFor:storingObjectsOfType:checkingConflictsAccordingTo:
			register:as:		
			prepareForInitialPersistence)
]
