Class {
	#name : #PooledRDBMSRepositoryProvider,
	#superclass : #RepositoryProvider,
	#instVars : [
		'sessionPool',
		'descriptorSystem',
		'login',
		'sessionProvider'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
PooledRDBMSRepositoryProvider class >> using: aLogin [

	^ self new initializeUsing: aLogin
]

{ #category : #building }
PooledRDBMSRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ RDBMSRepository
		storingObjectsOfType: aBusinessObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: sessionProvider
]

{ #category : #initialization }
PooledRDBMSRepositoryProvider >> initializeUsing: aLogin [

	sessionProvider := PooledRDBMSSessionProvider loginWith: aLogin. 

]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> prepareForInitialPersistence [

	sessionProvider
		withConfigurationSessionDo: [ :session | 
			session
				recreateTablesIfError: [ :error | Error signal: error description ];
				logout;
				loginIfError: [ :error | Error signal: error description ]
			]
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> prepareForShutDown [

	sessionProvider deleteSessions
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> reset [

	sessionProvider clearSessions
]
