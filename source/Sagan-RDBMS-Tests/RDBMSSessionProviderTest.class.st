Class {
	#name : #RDBMSSessionProviderTest,
	#superclass : #TestCase,
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #'private - protocol' }
RDBMSSessionProviderTest class >> failingLogin [

	^ Login new
		  database: self login database;
		  username: 'blabla';
		  password: 'blabla';
		  host: 'localhost';
		  port: 2345;
		  databaseName: 'not-a-database';
		  yourself
]

{ #category : #'private - protocol' }
RDBMSSessionProviderTest class >> login [

	^ SingleSessionRDMBSRepositoryTest login 
]

{ #category : #tests }
RDBMSSessionProviderTest >> expectedFailingLogingMessage [

	^ DatabaseAccessor classForThisPlatform DefaultDriver = SQLite3Driver
		  then: [ 'SQLite3CantOpen: unable to open database file' ]
		  otherwise: [ 'ConnectionTimedOut: Cannot connect to 127.0.0.1:2345' ]
]

{ #category : #tests }
RDBMSSessionProviderTest >> withLoggingAsserterDo: aOneArgBlock [

	| loggingAsserter |

	loggingAsserter := LoggingAsserter on: self.

	[ aOneArgBlock value: loggingAsserter ] ensure: [ loggingAsserter stopLoggers ]
]
