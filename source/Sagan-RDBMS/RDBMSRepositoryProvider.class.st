Class {
	#name : #RDBMSRepositoryProvider,
	#superclass : #RepositoryProvider,
	#instVars : [
		'sessionProvider'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'private-instance creation' }
RDBMSRepositoryProvider class >> obtainingSessionFrom: aSessionProvider [

	^ self new initializeObtainingSessionFrom: aSessionProvider
]

{ #category : #'instance creation' }
RDBMSRepositoryProvider class >> using: aLogin [

	^ self usingSessionPoolWith: aLogin configuredBy: [ :options |  ]
]

{ #category : #'instance creation' }
RDBMSRepositoryProvider class >> usingSessionPoolWith: aLogin configuredBy: anActionConfiguration [

	^ self obtainingSessionFrom:
		  ( PooledRDBMSSessionProvider loginWith: aLogin configuredBy: anActionConfiguration )
]

{ #category : #'instance creation' }
RDBMSRepositoryProvider class >> usingSingleSessionWith: aLogin [

	^ self usingSingleSessionWith: aLogin configuredBy: [  ]
]

{ #category : #'instance creation' }
RDBMSRepositoryProvider class >> usingSingleSessionWith: aLogin configuredBy: anActionConfiguration [

	^ self obtainingSessionFrom:
		  ( SingleRDBMSSessionProvider loginWith: aLogin configuredBy: anActionConfiguration )
]

{ #category : #building }
RDBMSRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ RDBMSRepository
		storingObjectsOfType: aBusinessObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: sessionProvider
]

{ #category : #controlling }
RDBMSRepositoryProvider >> destroyRepositories [

	sessionProvider withSessionDo: [:session |
		session dropAllTablesOnErrorDo: [:error | Error signal: error description]]
]

{ #category : #initialization }
RDBMSRepositoryProvider >> initializeObtainingSessionFrom: aSessionProvider [ 

	sessionProvider := aSessionProvider

]

{ #category : #controlling }
RDBMSRepositoryProvider >> prepareForInitialPersistence [

	sessionProvider
		withConfigurationSessionDo: [ :session | 
			session
				recreateTablesIfError: [ :error | Error signal: error description ];
				logout;
				loginIfError: [ :error | Error signal: error description ]
			]
]

{ #category : #controlling }
RDBMSRepositoryProvider >> prepareForShutDown [

	sessionProvider deleteSessions
]

{ #category : #controlling }
RDBMSRepositoryProvider >> reset [

	sessionProvider clearSessions
]
