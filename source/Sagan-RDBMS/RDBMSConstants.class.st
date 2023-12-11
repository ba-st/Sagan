Class {
	#name : 'RDBMSConstants',
	#superclass : 'Object',
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'accessing' }
RDBMSConstants class >> sequentialNumberAttribute [

	^ #sequentialNumber
]

{ #category : 'accessing' }
RDBMSConstants class >> sequentialNumberFieldName [

	^ 'sequential_number'
]
