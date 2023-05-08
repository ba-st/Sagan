Class {
	#name : #PooledRDBMSSessionProviderTest,
	#superclass : #RDBMSSessionProviderTest,
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #tests }
PooledRDBMSSessionProviderTest >> sessionProviderOptions [

	^ [ :options | 
	  options
		  at: #logDatabaseEvents put: true;
		  at: #maxActiveSessionsCount put: 1;
		  at: #maxIdleSessionsCount put: 1;
		  at: #minIdleSessionsCount put: 1
	  ]
]

{ #category : #tests }
PooledRDBMSSessionProviderTest >> testHandleFailingLogin [

	| sessionProvider |

	self timeLimit: 30 seconds.
	self withLoggingAsserterDo: [ :asserter | 
		self
			should: [ 
				asserter
					runMemoryLoggerDuring: [ 
						sessionProvider := PooledRDBMSSessionProvider
							                   loginWith: self class failingLogin
							                   configuredBy: self sessionProviderOptions
						];
					assertLogRecordsMatch: #(  )
				]
			raise: DatabaseLoginFailed
			withMessageText: self expectedFailingLogingMessage.

		asserter assertLogRecordsMatch: { 
				'[DEBUG] Glorp event received {"detail":"Login"}'.
				( '[WARNING] Failed to connect to database after 1 attempts because <1s>' expandMacrosWith:
					  self expectedFailingLogingMessage ).
				'[DEBUG] Glorp event received {"detail":"Login"}'.
				( '[WARNING] Failed to connect to database after 2 attempts because <1s>' expandMacrosWith:
					  self expectedFailingLogingMessage ).
				'[DEBUG] Glorp event received {"detail":"Login"}'.
				( '[WARNING] Failed to connect to database after 3 attempts because <1s>' expandMacrosWith:
					  self expectedFailingLogingMessage ).
				'[DEBUG] Glorp event received {"detail":"Login"}' }
		]
]

{ #category : #tests }
PooledRDBMSSessionProviderTest >> testLogsInWhenSessionFirstUsed [

	| sessionProvider |

	self withLoggingAsserterDo: [ :asserter | 
		asserter
			runMemoryLoggerDuring: [ 
				sessionProvider := PooledRDBMSSessionProvider
					                   loginWith: self class login
					                   configuredBy: self sessionProviderOptions
				];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' )
		]
]

{ #category : #tests }
PooledRDBMSSessionProviderTest >> testLogsInWhenSessionFoundedDisconnected [

	| sessionProvider |

	self withLoggingAsserterDo: [ :asserter | 
		asserter
			runMemoryLoggerDuring: [ 
				sessionProvider := PooledRDBMSSessionProvider
					                   loginWith: self class login
					                   configuredBy: self sessionProviderOptions
				];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session | session logout ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Logout"}'
				   '[DEBUG] Glorp event received {"detail":"Logout finished"}' ).

		asserter
			runMemoryLoggerDuring: [ sessionProvider withSessionDo: [ :session |  ] ];
			assertLogRecordsMatch: #( '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}'
				   '[DEBUG] Glorp event received {"detail":"Logout"}'
				   '[DEBUG] Glorp event received {"detail":"Logout finished"}'
				   '[DEBUG] Glorp event received {"detail":"Login"}'
				   '[DEBUG] Glorp event received {"detail":"Login finished"}' )
		]
]
