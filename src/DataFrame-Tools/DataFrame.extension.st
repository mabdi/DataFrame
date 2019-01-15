Extension { #name : #DataFrame }

{ #category : #'*DataFrame-Tools' }
DataFrame >> barplot [

	| n composer palette b |

	n := self numericColumnNames size.
	composer := RTComposer new.
	
	palette := DataColor palette: n.
	
	(self numericColumnNames) doWithIndex: [ :columnName :i |
		b := (self column: columnName) barplotWithColor: (palette at: i).
		b extent: 500 @ (300 / n).
		b view: composer view.
		b build.
		composer group: 'b', i asString ].
	
	2 to: n do: [ :i |
		composer
			move: ('b', i asString)
			below: ('b', (i - 1) asString) ].
		
	^ composer view
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> boxplot [

	| b ds n palette color |

	n := self numericColumnNames size.
	
	b := RTGrapher new.
	b extent: (n * 70) @ 300.
	
	palette := DataColor palette: n.
	
	(self numericColumnNames) doWithIndex: [ :columnName :i |
		ds := RTBoxPlotDataSet new.
		ds points: (self column: columnName) asArray.
		
		color := palette at: i.
		
		ds boxShape
			fillColor: color.
			
		ds outlierShape
			size: 5;
			fillColor: (color alpha: 0.5).
			
		b add: ds ].
	
	b axisX
		noLabel;
		noTick.
	b build.
	^ b
]

{ #category : #'*DataFrame-Tools-NeoCSV' }
DataFrame class >> fromCSV: pathToFile [

	^ self
		fromCSV: pathToFile
		separator: $,.
]

{ #category : #'*DataFrame-Tools-NeoCSV' }
DataFrame class >> fromCSV: pathToFile header: containsHeader [

	^ self
		fromCSV: pathToFile
		separator: $,
		header: containsHeader.
]

{ #category : #'*DataFrame-Tools-NeoCSV' }
DataFrame class >> fromCSV: pathToFile separator: separator [

	^ self
		fromCSV: pathToFile
		separator: separator
		header: false
]

{ #category : #'*DataFrame-Tools-NeoCSV' }
DataFrame class >> fromCSV: pathToFile separator: separator header: containsHeader [

	| stream arrayOfRows |
	
	stream := pathToFile asFileReference readStream.
	
	arrayOfRows := (NeoCSVReader on: stream)
		separator: separator;
		upToEnd.
		
	containsHeader ifTrue: [
		| df |
		"TODO: Make this faster"
		df := self fromRows: (arrayOfRows copyFrom: 2 to: arrayOfRows size).
		df columnNames: (arrayOfRows at: 1).
		^ df ].
	
	^ self fromRows: arrayOfRows.
]

{ #category : #'*DataFrame-Tools-Tabular' }
DataFrame class >> fromXLSX: pathToFile [

	| file workbook sheet |
	
	file := FileStream readOnlyFileNamed: pathToFile.
	workbook := XLSXImporter import: file.
	sheet := workbook worksheets first.
	
	^ self fromXLSXworksheet: sheet.
]

{ #category : #'*DataFrame-Tools-Tabular' }
DataFrame class >> fromXLSX: pathToFile worksheetNamed: sheetName [

	| file workbook sheet |
	
	file := FileStream readOnlyFileNamed: pathToFile.
	workbook := XLSXImporter import: file.
	sheet := workbook worksheetNamed: sheetName.
	
	^ self fromXLSXworksheet: sheet.
]

{ #category : #'*DataFrame-Tools-Tabular' }
DataFrame class >> fromXLSXworksheet: sheet [
	
	| matrix df |
	
	matrix := sheet cellValuesAsMatrix.
	df := self new initializeMatrix: matrix.
	^ df
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> gtInspectorBoxplotIn: composite [
	<gtInspectorPresentationOrder: 1>
	<gtInspectorTag: #basic>
	
	composite roassal2
		title: 'Boxplot';
		initializeView: [ self boxplot ]
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> gtInspectorFastTableIn: composite [
	<gtInspectorPresentationOrder: 0>
	<gtInspectorTag: #basic>
	
	composite morph
		title: 'Fast Table';
		display: [ self showWithGlamour ]
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> gtInspectorHistogramIn: composite [
	<gtInspectorPresentationOrder: 2>
	<gtInspectorTag: #basic>
	
	composite roassal2
		title: 'Histogram';
		initializeView: [ self histogram ]
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> gtInspectorItemsIn: composite [
"Hide Items from inspector"

	composite fastTable
		when: [ false ].
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> gtInspectorScatterplotMatrixIn: composite [
	<gtInspectorPresentationOrder: 2>
	<gtInspectorTag: #basic>
	
	composite roassal2
		title: 'Scatterplot Matrix';
		initializeView: [ self scatterplotMatrix ];
		when: [ false "When fixed" ]
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> histogram [

	| n composer palette b |

	n := self numericColumnNames size.
	composer := RTComposer new.
	
	palette := DataColor palette: n.
	
	(self numericColumnNames) doWithIndex: [ :columnName :i |
		b := (self column: columnName) histogramWithColor: (palette at: i).
		b extent: 500 @ (300 / n).
		b view: composer view.
		b build.
		composer group: 'b', i asString ].
	
	2 to: n do: [ :i |
		composer
			move: ('b', i asString)
			below: ('b', (i - 1) asString) ].
		
	^ composer view
]

{ #category : #'*DataFrame-Tools-Datasets' }
DataFrame class >> loadHousing [

	| df |
	df := self fromRows: #(
(6.575 4.98 15.3 504000.0 )
(6.421 9.14 17.8 453600.0 )
(7.185 4.03 17.8 728700.0 )
(6.998 2.94 18.7 701400.0 )
(7.147 5.33 18.7 760200.0 )
(6.43 5.21 18.7 602700.0 )
(6.012 12.43 15.2 480900.0 )
(6.172 19.15 15.2 569100.0 )
(5.631 29.93 15.2 346500.0 )
(6.004 17.1 15.2 396900.0 )
(6.377 20.45 15.2 315000.0 )
(6.009 13.27 15.2 396900.0 )
(5.889 15.71 15.2 455700.0 )
(5.949 8.26 21.0 428400.0 )
(6.096 10.26 21.0 382200.0 )
(5.834 8.47 21.0 417900.0 )
(5.935 6.58 21.0 485100.0 )
(5.99 14.67 21.0 367500.0 )
(5.456 11.69 21.0 424200.0 )
(5.727 11.28 21.0 382200.0 )
(5.57 21.02 21.0 285600.0 )
(5.965 13.83 21.0 411600.0 )
(6.142 18.72 21.0 319200.0 )
(5.813 19.88 21.0 304500.0 )
(5.924 16.3 21.0 327600.0 )
(5.599 16.51 21.0 291900.0 )
(5.813 14.81 21.0 348600.0 )
(6.047 17.28 21.0 310800.0 )
(6.495 12.8 21.0 386400.0 )
(6.674 11.98 21.0 441000.0 )
(5.713 22.6 21.0 266700.0 )
(6.072 13.04 21.0 304500.0 )
(5.95 27.71 21.0 277200.0 )
(5.701 18.35 21.0 275100.0 )
(6.096 20.34 21.0 283500.0 )
(5.933 9.68 19.2 396900.0 )
(5.841 11.41 19.2 420000.0 )
(5.85 8.77 19.2 441000.0 )
(5.966 10.13 19.2 518700.0 )
(6.595 4.32 18.3 646800.0 )
(7.024 1.98 18.3 732900.0 )
(6.77 4.84 17.9 558600.0 )
(6.169 5.81 17.9 531300.0 )
(6.211 7.44 17.9 518700.0 )
(6.069 9.55 17.9 445200.0 )
(5.682 10.21 17.9 405300.0 )
(5.786 14.15 17.9 420000.0 )
(6.03 18.8 17.9 348600.0 )
(5.399 30.81 17.9 302400.0 )
(5.602 16.2 17.9 407400.0 )
(5.963 13.45 16.8 413700.0 )
(6.115 9.43 16.8 430500.0 )
(6.511 5.28 16.8 525000.0 )
(5.998 8.43 16.8 491400.0 )
(5.888 14.8 21.1 396900.0 )
(7.249 4.81 17.9 743400.0 )
(6.383 5.77 17.3 518700.0 )
(6.816 3.95 15.1 663600.0 )
(6.145 6.86 19.7 489300.0 )
(5.927 9.22 19.7 411600.0 )
(5.741 13.15 19.7 392700.0 )
(5.966 14.44 19.7 336000.0 )
(6.456 6.73 19.7 466200.0 )
(6.762 9.5 19.7 525000.0 )
(7.104 8.05 18.6 693000.0 )
(6.29 4.67 16.1 493500.0 )
(5.787 10.24 16.1 407400.0 )
(5.878 8.1 18.9 462000.0 )
(5.594 13.09 18.9 365400.0 )
(5.885 8.79 18.9 438900.0 )
(6.417 6.72 19.2 508200.0 )
(5.961 9.88 19.2 455700.0 )
(6.065 5.52 19.2 478800.0 )
(6.245 7.54 19.2 491400.0 )
(6.273 6.78 18.7 506100.0 )
(6.286 8.94 18.7 449400.0 )
(6.279 11.97 18.7 420000.0 )
(6.14 10.27 18.7 436800.0 )
(6.232 12.34 18.7 445200.0 )
(5.874 9.1 18.7 426300.0 )
(6.727 5.29 19.0 588000.0 )
(6.619 7.22 19.0 501900.0 )
(6.302 6.72 19.0 520800.0 )
(6.167 7.51 19.0 480900.0 )
(6.389 9.62 18.5 501900.0 )
(6.63 6.53 18.5 558600.0 )
(6.015 12.86 18.5 472500.0 )
(6.121 8.44 18.5 466200.0 )
(7.007 5.5 17.8 495600.0 )
(7.079 5.7 17.8 602700.0 )
(6.417 8.81 17.8 474600.0 )
(6.405 8.2 17.8 462000.0 )
(6.442 8.16 18.2 480900.0 )
(6.211 6.21 18.2 525000.0 )
(6.249 10.59 18.2 432600.0 )
(6.625 6.65 18.0 596400.0 )
(6.163 11.34 18.0 449400.0 )
(8.069 4.21 18.0 812700.0 )
(7.82 3.57 18.0 919800.0 )
(7.416 6.19 18.0 697200.0 )
(6.727 9.42 20.9 577500.0 )
(6.781 7.67 20.9 556500.0 )
(6.405 10.63 20.9 390600.0 )
(6.137 13.44 20.9 405300.0 )
(6.167 12.33 20.9 422100.0 )
(5.851 16.47 20.9 409500.0 )
(5.836 18.66 20.9 409500.0 )
(6.127 14.09 20.9 428400.0 )
(6.474 12.27 20.9 415800.0 )
(6.229 15.55 20.9 407400.0 )
(6.195 13.0 20.9 455700.0 )
(6.715 10.16 17.8 478800.0 )
(5.913 16.21 17.8 394800.0 )
(6.092 17.09 17.8 392700.0 )
(6.254 10.45 17.8 388500.0 )
(5.928 15.76 17.8 384300.0 )
(6.176 12.04 17.8 445200.0 )
(6.021 10.3 17.8 403200.0 )
(5.872 15.37 17.8 428400.0 )
(5.731 13.61 17.8 405300.0 )
(5.87 14.37 19.1 462000.0 )
(6.004 14.27 19.1 426300.0 )
(5.961 17.93 19.1 430500.0 )
(5.856 25.41 19.1 363300.0 )
(5.879 17.58 19.1 394800.0 )
(5.986 14.81 19.1 449400.0 )
(5.613 27.26 19.1 329700.0 )
(5.693 17.19 21.2 340200.0 )
(6.431 15.39 21.2 378000.0 )
(5.637 18.34 21.2 300300.0 )
(6.458 12.6 21.2 403200.0 )
(6.326 12.26 21.2 411600.0 )
(6.372 11.12 21.2 483000.0 )
(5.822 15.03 21.2 386400.0 )
(5.757 17.31 21.2 327600.0 )
(6.335 16.96 21.2 380100.0 )
(5.942 16.9 21.2 365400.0 )
(6.454 14.59 21.2 359100.0 )
(5.857 21.32 21.2 279300.0 )
(6.151 18.46 21.2 373800.0 )
(6.174 24.16 21.2 294000.0 )
(5.019 34.41 21.2 302400.0 )
(5.403 26.82 14.7 281400.0 )
(5.468 26.42 14.7 327600.0 )
(4.903 29.29 14.7 247800.0 )
(6.13 27.8 14.7 289800.0 )
(5.628 16.65 14.7 327600.0 )
(4.926 29.53 14.7 306600.0 )
(5.186 28.32 14.7 373800.0 )
(5.597 21.45 14.7 323400.0 )
(6.122 14.1 14.7 451500.0 )
(5.404 13.28 14.7 411600.0 )
(5.012 12.12 14.7 321300.0 )
(5.709 15.79 14.7 407400.0 )
(6.129 15.12 14.7 357000.0 )
(6.152 15.02 14.7 327600.0 )
(5.272 16.14 14.7 275100.0 )
(6.943 4.59 14.7 867300.0 )
(6.066 6.43 14.7 510300.0 )
(6.51 7.39 14.7 489300.0 )
(6.25 5.5 14.7 567000.0 )
(5.854 11.64 14.7 476700.0 )
(6.101 9.81 14.7 525000.0 )
(5.877 12.14 14.7 499800.0 )
(6.319 11.1 14.7 499800.0 )
(6.402 11.32 14.7 468300.0 )
(5.875 14.43 14.7 365400.0 )
(5.88 12.03 14.7 401100.0 )
(5.572 14.69 16.6 485100.0 )
(6.416 9.04 16.6 495600.0 )
(5.859 9.64 16.6 474600.0 )
(6.546 5.33 16.6 617400.0 )
(6.02 10.11 16.6 487200.0 )
(6.315 6.29 16.6 516600.0 )
(6.86 6.92 16.6 627900.0 )
(6.98 5.04 17.8 781200.0 )
(7.765 7.56 17.8 835800.0 )
(6.144 9.45 17.8 760200.0 )
(7.155 4.82 17.8 795900.0 )
(6.563 5.68 17.8 682500.0 )
(5.604 13.98 17.8 554400.0 )
(6.153 13.15 17.8 621600.0 )
(6.782 6.68 15.2 672000.0 )
(6.556 4.56 15.2 625800.0 )
(7.185 5.39 15.2 732900.0 )
(6.951 5.1 15.2 777000.0 )
(6.739 4.69 15.2 640500.0 )
(7.178 2.87 15.2 764400.0 )
(6.8 5.03 15.6 653100.0 )
(6.604 4.38 15.6 611100.0 )
(7.287 4.08 12.6 699300.0 )
(7.107 8.61 12.6 636300.0 )
(7.274 6.62 12.6 726600.0 )
(6.975 4.56 17.0 732900.0 )
(7.135 4.45 17.0 690900.0 )
(6.162 7.43 14.7 506100.0 )
(7.61 3.11 14.7 888300.0 )
(7.853 3.81 14.7 1.0185e6 )
(5.891 10.87 18.6 474600.0 )
(6.326 10.97 18.6 512400.0 )
(5.783 18.06 18.6 472500.0 )
(6.064 14.66 18.6 512400.0 )
(5.344 23.09 18.6 420000.0 )
(5.96 17.27 18.6 455700.0 )
(5.404 23.98 18.6 405300.0 )
(5.807 16.03 18.6 470400.0 )
(6.375 9.38 18.6 590100.0 )
(5.412 29.55 18.6 497700.0 )
(6.182 9.47 18.6 525000.0 )
(5.888 13.51 16.4 489300.0 )
(6.642 9.69 16.4 602700.0 )
(5.951 17.92 16.4 451500.0 )
(6.373 10.5 16.4 483000.0 )
(6.951 9.71 17.4 560700.0 )
(6.164 21.46 17.4 455700.0 )
(6.879 9.93 17.4 577500.0 )
(6.618 7.6 17.4 632100.0 )
(8.266 4.14 17.4 940800.0 )
(8.04 3.13 17.4 789600.0 )
(7.163 6.36 17.4 663600.0 )
(7.686 3.92 17.4 980700.0 )
(6.552 3.76 17.4 661500.0 )
(5.981 11.65 17.4 510300.0 )
(7.412 5.25 17.4 665700.0 )
(8.337 2.47 17.4 875700.0 )
(8.247 3.95 17.4 1.0143e6 )
(6.726 8.05 17.4 609000.0 )
(6.086 10.88 17.4 504000.0 )
(6.631 9.54 17.4 527100.0 )
(7.358 4.73 17.4 661500.0 )
(6.481 6.36 16.6 497700.0 )
(6.606 7.37 16.6 489300.0 )
(6.897 11.38 16.6 462000.0 )
(6.095 12.4 16.6 422100.0 )
(6.358 11.22 16.6 466200.0 )
(6.393 5.19 16.6 497700.0 )
(5.593 12.5 19.1 369600.0 )
(5.605 18.46 19.1 388500.0 )
(6.108 9.16 19.1 510300.0 )
(6.226 10.15 19.1 430500.0 )
(6.433 9.52 19.1 514500.0 )
(6.718 6.56 19.1 550200.0 )
(6.487 5.9 19.1 512400.0 )
(6.438 3.59 19.1 520800.0 )
(6.957 3.53 19.1 621600.0 )
(8.259 3.54 19.1 898800.0 )
(6.108 6.57 16.4 459900.0 )
(5.876 9.25 16.4 438900.0 )
(7.454 3.11 15.9 924000.0 )
(7.333 7.79 13.0 756000.0 )
(6.842 6.9 13.0 632100.0 )
(7.203 9.59 13.0 709800.0 )
(7.52 7.26 13.0 905100.0 )
(8.398 5.91 13.0 1.0248e6 )
(7.327 11.25 13.0 651000.0 )
(7.206 8.1 13.0 766500.0 )
(5.56 10.45 13.0 478800.0 )
(7.014 14.79 13.0 644700.0 )
(7.47 3.16 13.0 913500.0 )
(5.92 13.65 18.6 434700.0 )
(5.856 13.0 18.6 443100.0 )
(6.24 6.59 18.6 529200.0 )
(6.538 7.73 18.6 512400.0 )
(7.691 6.58 18.6 739200.0 )
(6.758 3.53 17.6 680400.0 )
(6.854 2.98 17.6 672000.0 )
(7.267 6.05 17.6 697200.0 )
(6.826 4.16 17.6 695100.0 )
(6.482 7.19 17.6 611100.0 )
(6.812 4.85 14.9 737100.0 )
(7.82 3.76 14.9 953400.0 )
(6.968 4.59 14.9 743400.0 )
(7.645 3.01 14.9 966000.0 )
(7.088 7.85 15.3 676200.0 )
(6.453 8.23 15.3 462000.0 )
(6.23 12.93 18.2 422100.0 )
(6.209 7.14 16.6 487200.0 )
(6.315 7.6 16.6 468300.0 )
(6.565 9.51 16.6 520800.0 )
(6.861 3.33 19.2 598500.0 )
(7.148 3.56 19.2 783300.0 )
(6.63 4.7 19.2 585900.0 )
(6.127 8.58 16.0 501900.0 )
(6.009 10.4 16.0 455700.0 )
(6.678 6.27 16.0 600600.0 )
(6.549 7.39 16.0 569100.0 )
(5.79 15.84 16.0 426300.0 )
(6.345 4.97 14.8 472500.0 )
(7.041 4.74 14.8 609000.0 )
(6.871 6.07 14.8 520800.0 )
(6.59 9.5 16.1 462000.0 )
(6.495 8.67 16.1 554400.0 )
(6.982 4.86 16.1 695100.0 )
(7.236 6.93 18.4 758100.0 )
(6.616 8.93 18.4 596400.0 )
(7.42 6.47 18.4 701400.0 )
(6.849 7.53 18.4 592200.0 )
(6.635 4.54 18.4 478800.0 )
(5.972 9.97 18.4 426300.0 )
(4.973 12.64 18.4 338100.0 )
(6.122 5.98 18.4 464100.0 )
(6.023 11.72 18.4 407400.0 )
(6.266 7.9 18.4 453600.0 )
(6.567 9.28 18.4 499800.0 )
(5.705 11.5 18.4 340200.0 )
(5.914 18.33 18.4 373800.0 )
(5.782 15.94 18.4 415800.0 )
(6.382 10.36 18.4 485100.0 )
(6.113 12.73 18.4 441000.0 )
(6.426 7.2 19.6 499800.0 )
(6.376 6.87 19.6 485100.0 )
(6.041 7.7 19.6 428400.0 )
(5.708 11.74 19.6 388500.0 )
(6.415 6.12 19.6 525000.0 )
(6.431 5.08 19.6 516600.0 )
(6.312 6.15 19.6 483000.0 )
(6.083 12.79 19.6 466200.0 )
(5.868 9.97 16.9 405300.0 )
(6.333 7.34 16.9 474600.0 )
(6.144 9.09 16.9 415800.0 )
(5.706 12.43 16.9 359100.0 )
(6.031 7.83 16.9 407400.0 )
(6.316 5.68 20.2 466200.0 )
(6.31 6.75 20.2 434700.0 )
(6.037 8.01 20.2 443100.0 )
(5.869 9.8 20.2 409500.0 )
(5.895 10.56 20.2 388500.0 )
(6.059 8.51 20.2 432600.0 )
(5.985 9.74 20.2 399000.0 )
(5.968 9.29 20.2 392700.0 )
(7.241 5.49 15.5 686700.0 )
(6.54 8.65 15.9 346500.0 )
(6.696 7.18 17.6 501900.0 )
(6.874 4.61 17.6 655200.0 )
(6.014 10.53 18.8 367500.0 )
(5.898 12.67 18.8 361200.0 )
(6.516 6.36 17.9 485100.0 )
(6.635 5.99 17.0 514500.0 )
(6.939 5.89 19.7 558600.0 )
(6.49 5.98 19.7 480900.0 )
(6.579 5.49 18.3 506100.0 )
(5.884 7.79 18.3 390600.0 )
(6.728 4.5 17.0 632100.0 )
(5.663 8.05 22.0 382200.0 )
(5.936 5.57 22.0 432600.0 )
(6.212 17.6 20.2 373800.0 )
(6.395 13.27 20.2 455700.0 )
(6.127 11.48 20.2 476700.0 )
(6.112 12.67 20.2 474600.0 )
(6.398 7.79 20.2 525000.0 )
(6.251 14.19 20.2 417900.0 )
(5.362 10.19 20.2 436800.0 )
(5.803 14.64 20.2 352800.0 )
(3.561 7.12 20.2 577500.0 )
(4.963 14.0 20.2 459900.0 )
(3.863 13.33 20.2 485100.0 )
(4.906 34.77 20.2 289800.0 )
(4.138 37.97 20.2 289800.0 )
(7.313 13.44 20.2 315000.0 )
(6.649 23.24 20.2 291900.0 )
(6.794 21.24 20.2 279300.0 )
(6.38 23.69 20.2 275100.0 )
(6.223 21.78 20.2 214200.0 )
(6.968 17.21 20.2 218400.0 )
(6.545 21.08 20.2 228900.0 )
(5.536 23.6 20.2 237300.0 )
(5.52 24.56 20.2 258300.0 )
(4.368 30.63 20.2 184800.0 )
(5.277 30.81 20.2 151200.0 )
(4.652 28.28 20.2 220500.0 )
(5.0 31.99 20.2 155400.0 )
(4.88 30.62 20.2 214200.0 )
(5.39 20.85 20.2 241500.0 )
(5.713 17.11 20.2 317100.0 )
(6.051 18.76 20.2 487200.0 )
(5.036 25.68 20.2 203700.0 )
(6.193 15.17 20.2 289800.0 )
(5.887 16.35 20.2 266700.0 )
(6.471 17.12 20.2 275100.0 )
(6.405 19.37 20.2 262500.0 )
(5.747 19.92 20.2 178500.0 )
(5.453 30.59 20.2 105000.0 )
(5.852 29.97 20.2 132300.0 )
(5.987 26.77 20.2 117600.0 )
(6.343 20.32 20.2 151200.0 )
(6.404 20.31 20.2 254100.0 )
(5.349 19.77 20.2 174300.0 )
(5.531 27.38 20.2 178500.0 )
(5.683 22.98 20.2 105000.0 )
(4.138 23.34 20.2 249900.0 )
(5.608 12.13 20.2 585900.0 )
(5.617 26.4 20.2 361200.0 )
(6.852 19.78 20.2 577500.0 )
(5.757 10.11 20.2 315000.0 )
(6.657 21.22 20.2 361200.0 )
(4.628 34.37 20.2 375900.0 )
(5.155 20.08 20.2 342300.0 )
(4.519 36.98 20.2 147000.0 )
(6.434 29.05 20.2 151200.0 )
(6.782 25.79 20.2 157500.0 )
(5.304 26.64 20.2 218400.0 )
(5.957 20.62 20.2 184800.0 )
(6.824 22.74 20.2 176400.0 )
(6.411 15.02 20.2 350700.0 )
(6.006 15.7 20.2 298200.0 )
(5.648 14.1 20.2 436800.0 )
(6.103 23.29 20.2 281400.0 )
(5.565 17.16 20.2 245700.0 )
(5.896 24.39 20.2 174300.0 )
(5.837 15.69 20.2 214200.0 )
(6.202 14.52 20.2 228900.0 )
(6.193 21.52 20.2 231000.0 )
(6.38 24.08 20.2 199500.0 )
(6.348 17.64 20.2 304500.0 )
(6.833 19.69 20.2 296100.0 )
(6.425 12.03 20.2 338100.0 )
(6.436 16.22 20.2 300300.0 )
(6.208 15.17 20.2 245700.0 )
(6.629 23.27 20.2 281400.0 )
(6.461 18.05 20.2 201600.0 )
(6.152 26.45 20.2 182700.0 )
(5.935 34.02 20.2 176400.0 )
(5.627 22.88 20.2 268800.0 )
(5.818 22.11 20.2 220500.0 )
(6.406 19.52 20.2 359100.0 )
(6.219 16.59 20.2 386400.0 )
(6.485 18.85 20.2 323400.0 )
(5.854 23.79 20.2 226800.0 )
(6.459 23.98 20.2 247800.0 )
(6.341 17.79 20.2 312900.0 )
(6.251 16.44 20.2 264600.0 )
(6.185 18.13 20.2 296100.0 )
(6.417 19.31 20.2 273000.0 )
(6.749 17.44 20.2 281400.0 )
(6.655 17.73 20.2 319200.0 )
(6.297 17.27 20.2 338100.0 )
(7.393 16.74 20.2 373800.0 )
(6.728 18.71 20.2 312900.0 )
(6.525 18.13 20.2 296100.0 )
(5.976 19.01 20.2 266700.0 )
(5.936 16.94 20.2 283500.0 )
(6.301 16.23 20.2 312900.0 )
(6.081 14.7 20.2 420000.0 )
(6.701 16.42 20.2 344400.0 )
(6.376 14.65 20.2 371700.0 )
(6.317 13.99 20.2 409500.0 )
(6.513 10.29 20.2 424200.0 )
(6.209 13.22 20.2 449400.0 )
(5.759 14.13 20.2 417900.0 )
(5.952 17.15 20.2 399000.0 )
(6.003 21.32 20.2 401100.0 )
(5.926 18.13 20.2 401100.0 )
(5.713 14.76 20.2 422100.0 )
(6.167 16.29 20.2 417900.0 )
(6.229 12.87 20.2 411600.0 )
(6.437 14.36 20.2 487200.0 )
(6.98 11.66 20.2 625800.0 )
(5.427 18.14 20.2 289800.0 )
(6.162 24.1 20.2 279300.0 )
(6.484 18.68 20.2 350700.0 )
(5.304 24.91 20.2 252000.0 )
(6.185 18.03 20.2 306600.0 )
(6.229 13.11 20.2 449400.0 )
(6.242 10.74 20.2 483000.0 )
(6.75 7.74 20.2 497700.0 )
(7.061 7.01 20.2 525000.0 )
(5.762 10.42 20.2 457800.0 )
(5.871 13.34 20.2 432600.0 )
(6.312 10.58 20.2 445200.0 )
(6.114 14.98 20.2 401100.0 )
(5.905 11.45 20.2 432600.0 )
(5.454 18.06 20.1 319200.0 )
(5.414 23.97 20.1 147000.0 )
(5.093 29.68 20.1 170100.0 )
(5.983 18.07 20.1 285600.0 )
(5.983 13.35 20.1 422100.0 )
(5.707 12.01 19.2 457800.0 )
(5.926 13.59 19.2 514500.0 )
(5.67 17.6 19.2 485100.0 )
(5.39 21.14 19.2 413700.0 )
(5.794 14.1 19.2 384300.0 )
(6.019 12.92 19.2 445200.0 )
(5.569 15.1 19.2 367500.0 )
(6.027 14.33 19.2 352800.0 )
(6.593 9.67 21.0 470400.0 )
(6.12 9.08 21.0 432600.0 )
(6.976 5.64 21.0 501900.0 )
(6.794 6.48 21.0 462000.0 )
(6.03 7.88 21.0 249900.0 )).

	df columnNames: #(RM LSTAT PTRATIO MDEV ).
	^ df 
]

{ #category : #'*DataFrame-Tools-Datasets' }
DataFrame class >> loadIris [

	| df |
	df := self fromRows: #(
(5.1 3.5 1.4 0.2 setosa )
(4.9 3 1.4 0.2 setosa )
(4.7 3.2 1.3 0.2 setosa )
(4.6 3.1 1.5 0.2 setosa )
(5 3.6 1.4 0.2 setosa )
(5.4 3.9 1.7 0.4 setosa )
(4.6 3.4 1.4 0.3 setosa )
(5 3.4 1.5 0.2 setosa )
(4.4 2.9 1.4 0.2 setosa )
(4.9 3.1 1.5 0.1 setosa )
(5.4 3.7 1.5 0.2 setosa )
(4.8 3.4 1.6 0.2 setosa )
(4.8 3 1.4 0.1 setosa )
(4.3 3 1.1 0.1 setosa )
(5.8 4 1.2 0.2 setosa )
(5.7 4.4 1.5 0.4 setosa )
(5.4 3.9 1.3 0.4 setosa )
(5.1 3.5 1.4 0.3 setosa )
(5.7 3.8 1.7 0.3 setosa )
(5.1 3.8 1.5 0.3 setosa )
(5.4 3.4 1.7 0.2 setosa )
(5.1 3.7 1.5 0.4 setosa )
(4.6 3.6 1 0.2 setosa )
(5.1 3.3 1.7 0.5 setosa )
(4.8 3.4 1.9 0.2 setosa )
(5 3 1.6 0.2 setosa )
(5 3.4 1.6 0.4 setosa )
(5.2 3.5 1.5 0.2 setosa )
(5.2 3.4 1.4 0.2 setosa )
(4.7 3.2 1.6 0.2 setosa )
(4.8 3.1 1.6 0.2 setosa )
(5.4 3.4 1.5 0.4 setosa )
(5.2 4.1 1.5 0.1 setosa )
(5.5 4.2 1.4 0.2 setosa )
(4.9 3.1 1.5 0.1 setosa )
(5 3.2 1.2 0.2 setosa )
(5.5 3.5 1.3 0.2 setosa )
(4.9 3.1 1.5 0.1 setosa )
(4.4 3 1.3 0.2 setosa )
(5.1 3.4 1.5 0.2 setosa )
(5 3.5 1.3 0.3 setosa )
(4.5 2.3 1.3 0.3 setosa )
(4.4 3.2 1.3 0.2 setosa )
(5 3.5 1.6 0.6 setosa )
(5.1 3.8 1.9 0.4 setosa )
(4.8 3 1.4 0.3 setosa )
(5.1 3.8 1.6 0.2 setosa )
(4.6 3.2 1.4 0.2 setosa )
(5.3 3.7 1.5 0.2 setosa )
(5 3.3 1.4 0.2 setosa )
(7 3.2 4.7 1.4 versicolor )
(6.4 3.2 4.5 1.5 versicolor )
(6.9 3.1 4.9 1.5 versicolor )
(5.5 2.3 4 1.3 versicolor )
(6.5 2.8 4.6 1.5 versicolor )
(5.7 2.8 4.5 1.3 versicolor )
(6.3 3.3 4.7 1.6 versicolor )
(4.9 2.4 3.3 1 versicolor )
(6.6 2.9 4.6 1.3 versicolor )
(5.2 2.7 3.9 1.4 versicolor )
(5 2 3.5 1 versicolor )
(5.9 3 4.2 1.5 versicolor )
(6 2.2 4 1 versicolor )
(6.1 2.9 4.7 1.4 versicolor )
(5.6 2.9 3.6 1.3 versicolor )
(6.7 3.1 4.4 1.4 versicolor )
(5.6 3 4.5 1.5 versicolor )
(5.8 2.7 4.1 1 versicolor )
(6.2 2.2 4.5 1.5 versicolor )
(5.6 2.5 3.9 1.1 versicolor )
(5.9 3.2 4.8 1.8 versicolor )
(6.1 2.8 4 1.3 versicolor )
(6.3 2.5 4.9 1.5 versicolor )
(6.1 2.8 4.7 1.2 versicolor )
(6.4 2.9 4.3 1.3 versicolor )
(6.6 3 4.4 1.4 versicolor )
(6.8 2.8 4.8 1.4 versicolor )
(6.7 3 5 1.7 versicolor )
(6 2.9 4.5 1.5 versicolor )
(5.7 2.6 3.5 1 versicolor )
(5.5 2.4 3.8 1.1 versicolor )
(5.5 2.4 3.7 1 versicolor )
(5.8 2.7 3.9 1.2 versicolor )
(6 2.7 5.1 1.6 versicolor )
(5.4 3 4.5 1.5 versicolor )
(6 3.4 4.5 1.6 versicolor )
(6.7 3.1 4.7 1.5 versicolor )
(6.3 2.3 4.4 1.3 versicolor )
(5.6 3 4.1 1.3 versicolor )
(5.5 2.5 4 1.3 versicolor )
(5.5 2.6 4.4 1.2 versicolor )
(6.1 3 4.6 1.4 versicolor )
(5.8 2.6 4 1.2 versicolor )
(5 2.3 3.3 1 versicolor )
(5.6 2.7 4.2 1.3 versicolor )
(5.7 3 4.2 1.2 versicolor )
(5.7 2.9 4.2 1.3 versicolor )
(6.2 2.9 4.3 1.3 versicolor )
(5.1 2.5 3 1.1 versicolor )
(5.7 2.8 4.1 1.3 versicolor )
(6.3 3.3 6 2.5 virginica )
(5.8 2.7 5.1 1.9 virginica )
(7.1 3 5.9 2.1 virginica )
(6.3 2.9 5.6 1.8 virginica )
(6.5 3 5.8 2.2 virginica )
(7.6 3 6.6 2.1 virginica )
(4.9 2.5 4.5 1.7 virginica )
(7.3 2.9 6.3 1.8 virginica )
(6.7 2.5 5.8 1.8 virginica )
(7.2 3.6 6.1 2.5 virginica )
(6.5 3.2 5.1 2 virginica )
(6.4 2.7 5.3 1.9 virginica )
(6.8 3 5.5 2.1 virginica )
(5.7 2.5 5 2 virginica )
(5.8 2.8 5.1 2.4 virginica )
(6.4 3.2 5.3 2.3 virginica )
(6.5 3 5.5 1.8 virginica )
(7.7 3.8 6.7 2.2 virginica )
(7.7 2.6 6.9 2.3 virginica )
(6 2.2 5 1.5 virginica )
(6.9 3.2 5.7 2.3 virginica )
(5.6 2.8 4.9 2 virginica )
(7.7 2.8 6.7 2 virginica )
(6.3 2.7 4.9 1.8 virginica )
(6.7 3.3 5.7 2.1 virginica )
(7.2 3.2 6 1.8 virginica )
(6.2 2.8 4.8 1.8 virginica )
(6.1 3 4.9 1.8 virginica )
(6.4 2.8 5.6 2.1 virginica )
(7.2 3 5.8 1.6 virginica )
(7.4 2.8 6.1 1.9 virginica )
(7.9 3.8 6.4 2 virginica )
(6.4 2.8 5.6 2.2 virginica )
(6.3 2.8 5.1 1.5 virginica )
(6.1 2.6 5.6 1.4 virginica )
(7.7 3 6.1 2.3 virginica )
(6.3 3.4 5.6 2.4 virginica )
(6.4 3.1 5.5 1.8 virginica )
(6 3 4.8 1.8 virginica )
(6.9 3.1 5.4 2.1 virginica )
(6.7 3.1 5.6 2.4 virginica )
(6.9 3.1 5.1 2.3 virginica )
(5.8 2.7 5.1 1.9 virginica )
(6.8 3.2 5.9 2.3 virginica )
(6.7 3.3 5.7 2.5 virginica )
(6.7 3 5.2 2.3 virginica )
(6.3 2.5 5 1.9 virginica )
(6.5 3 5.2 2 virginica )
(6.2 3.4 5.4 2.3 virginica )
(5.9 3 5.1 1.8 virginica )).

	df columnNames: #(sepal_length sepal_width petal_length petal_width species ).
	^ df 
]

{ #category : #'*DataFrame-Tools-Datasets' }
DataFrame class >> loadTips [

	| df |
	df := self fromRows: #(
		(16.99 1.01 'Female' false 'Sun' 'Dinner' 2)
		(10.34 1.66 'Male' false 'Sun' 'Dinner' 3)
		(21.01 3.5 'Male' false 'Sun' 'Dinner' 3)
		(23.68 3.31 'Male' false 'Sun' 'Dinner' 2)
		(24.59 3.61 'Female' false 'Sun' 'Dinner' 4)
		(25.29 4.71 'Male' false 'Sun' 'Dinner' 4)
		(8.77 2.0 'Male' false 'Sun' 'Dinner' 2)
		(26.88 3.12 'Male' false 'Sun' 'Dinner' 4)
		(15.04 1.96 'Male' false 'Sun' 'Dinner' 2)
		(14.78 3.23 'Male' false 'Sun' 'Dinner' 2)
		(10.27 1.71 'Male' false 'Sun' 'Dinner' 2)
		(35.26 5.0 'Female' false 'Sun' 'Dinner' 4)
		(15.42 1.57 'Male' false 'Sun' 'Dinner' 2)
		(18.43 3.0 'Male' false 'Sun' 'Dinner' 4)
		(14.83 3.02 'Female' false 'Sun' 'Dinner' 2)
		(21.58 3.92 'Male' false 'Sun' 'Dinner' 2)
		(10.33 1.67 'Female' false 'Sun' 'Dinner' 3)
		(16.29 3.71 'Male' false 'Sun' 'Dinner' 3)
		(16.97 3.5 'Female' false 'Sun' 'Dinner' 3)
		(20.65 3.35 'Male' false 'Sat' 'Dinner' 3)
		(17.92 4.08 'Male' false 'Sat' 'Dinner' 2)
		(20.29 2.75 'Female' false 'Sat' 'Dinner' 2)
		(15.77 2.23 'Female' false 'Sat' 'Dinner' 2)
		(39.42 7.58 'Male' false 'Sat' 'Dinner' 4)
		(19.82 3.18 'Male' false 'Sat' 'Dinner' 2)
		(17.81 2.34 'Male' false 'Sat' 'Dinner' 4)
		(13.37 2.0 'Male' false 'Sat' 'Dinner' 2)
		(12.69 2.0 'Male' false 'Sat' 'Dinner' 2)
		(21.7 4.3 'Male' false 'Sat' 'Dinner' 2)
		(19.65 3.0 'Female' false 'Sat' 'Dinner' 2)
		(9.55 1.45 'Male' false 'Sat' 'Dinner' 2)
		(18.35 2.5 'Male' false 'Sat' 'Dinner' 4)
		(15.06 3.0 'Female' false 'Sat' 'Dinner' 2)
		(20.69 2.45 'Female' false 'Sat' 'Dinner' 4)
		(17.78 3.27 'Male' false 'Sat' 'Dinner' 2)
		(24.06 3.6 'Male' false 'Sat' 'Dinner' 3)
		(16.31 2.0 'Male' false 'Sat' 'Dinner' 3)
		(16.93 3.07 'Female' false 'Sat' 'Dinner' 3)
		(18.69 2.31 'Male' false 'Sat' 'Dinner' 3)
		(31.27 5.0 'Male' false 'Sat' 'Dinner' 3)
		(16.04 2.24 'Male' false 'Sat' 'Dinner' 3)
		(17.46 2.54 'Male' false 'Sun' 'Dinner' 2)
		(13.94 3.06 'Male' false 'Sun' 'Dinner' 2)
		(9.68 1.32 'Male' false 'Sun' 'Dinner' 2)
		(30.4 5.6 'Male' false 'Sun' 'Dinner' 4)
		(18.29 3.0 'Male' false 'Sun' 'Dinner' 2)
		(22.23 5.0 'Male' false 'Sun' 'Dinner' 2)
		(32.4 6.0 'Male' false 'Sun' 'Dinner' 4)
		(28.55 2.05 'Male' false 'Sun' 'Dinner' 3)
		(18.04 3.0 'Male' false 'Sun' 'Dinner' 2)
		(12.54 2.5 'Male' false 'Sun' 'Dinner' 2)
		(10.29 2.6 'Female' false 'Sun' 'Dinner' 2)
		(34.81 5.2 'Female' false 'Sun' 'Dinner' 4)
		(9.94 1.56 'Male' false 'Sun' 'Dinner' 2)
		(25.56 4.34 'Male' false 'Sun' 'Dinner' 4)
		(19.49 3.51 'Male' false 'Sun' 'Dinner' 2)
		(38.01 3.0 'Male' true 'Sat' 'Dinner' 4)
		(26.41 1.5 'Female' false 'Sat' 'Dinner' 2)
		(11.24 1.76 'Male' true 'Sat' 'Dinner' 2)
		(48.27 6.73 'Male' false 'Sat' 'Dinner' 4)
		(20.29 3.21 'Male' true 'Sat' 'Dinner' 2)
		(13.81 2.0 'Male' true 'Sat' 'Dinner' 2)
		(11.02 1.98 'Male' true 'Sat' 'Dinner' 2)
		(18.29 3.76 'Male' true 'Sat' 'Dinner' 4)
		(17.59 2.64 'Male' false 'Sat' 'Dinner' 3)
		(20.08 3.15 'Male' false 'Sat' 'Dinner' 3)
		(16.45 2.47 'Female' false 'Sat' 'Dinner' 2)
		(3.07 1.0 'Female' true 'Sat' 'Dinner' 1)
		(20.23 2.01 'Male' false 'Sat' 'Dinner' 2)
		(15.01 2.09 'Male' true 'Sat' 'Dinner' 2)
		(12.02 1.97 'Male' false 'Sat' 'Dinner' 2)
		(17.07 3.0 'Female' false 'Sat' 'Dinner' 3)
		(26.86 3.14 'Female' true 'Sat' 'Dinner' 2)
		(25.28 5.0 'Female' true 'Sat' 'Dinner' 2)
		(14.73 2.2 'Female' false 'Sat' 'Dinner' 2)
		(10.51 1.25 'Male' false 'Sat' 'Dinner' 2)
		(17.92 3.08 'Male' true 'Sat' 'Dinner' 2)
		(27.2 4.0 'Male' false 'Thur' 'Lunch' 4)
		(22.76 3.0 'Male' false 'Thur' 'Lunch' 2)
		(17.29 2.71 'Male' false 'Thur' 'Lunch' 2)
		(19.44 3.0 'Male' true 'Thur' 'Lunch' 2)
		(16.66 3.4 'Male' false 'Thur' 'Lunch' 2)
		(10.07 1.83 'Female' false 'Thur' 'Lunch' 1)
		(32.68 5.0 'Male' true 'Thur' 'Lunch' 2)
		(15.98 2.03 'Male' false 'Thur' 'Lunch' 2)
		(34.83 5.17 'Female' false 'Thur' 'Lunch' 4)
		(13.03 2.0 'Male' false 'Thur' 'Lunch' 2)
		(18.28 4.0 'Male' false 'Thur' 'Lunch' 2)
		(24.71 5.85 'Male' false 'Thur' 'Lunch' 2)
		(21.16 3.0 'Male' false 'Thur' 'Lunch' 2)
		(28.97 3.0 'Male' true 'Fri' 'Dinner' 2)
		(22.49 3.5 'Male' false 'Fri' 'Dinner' 2)
		(5.75 1.0 'Female' true 'Fri' 'Dinner' 2)
		(16.32 4.3 'Female' true 'Fri' 'Dinner' 2)
		(22.75 3.25 'Female' false 'Fri' 'Dinner' 2)
		(40.17 4.73 'Male' true 'Fri' 'Dinner' 4)
		(27.28 4.0 'Male' true 'Fri' 'Dinner' 2)
		(12.03 1.5 'Male' true 'Fri' 'Dinner' 2)
		(21.01 3.0 'Male' true 'Fri' 'Dinner' 2)
		(12.46 1.5 'Male' false 'Fri' 'Dinner' 2)
		(11.35 2.5 'Female' true 'Fri' 'Dinner' 2)
		(15.38 3.0 'Female' true 'Fri' 'Dinner' 2)
		(44.3 2.5 'Female' true 'Sat' 'Dinner' 3)
		(22.42 3.48 'Female' true 'Sat' 'Dinner' 2)
		(20.92 4.08 'Female' false 'Sat' 'Dinner' 2)
		(15.36 1.64 'Male' true 'Sat' 'Dinner' 2)
		(20.49 4.06 'Male' true 'Sat' 'Dinner' 2)
		(25.21 4.29 'Male' true 'Sat' 'Dinner' 2)
		(18.24 3.76 'Male' false 'Sat' 'Dinner' 2)
		(14.31 4.0 'Female' true 'Sat' 'Dinner' 2)
		(14.0 3.0 'Male' false 'Sat' 'Dinner' 2)
		(7.25 1.0 'Female' false 'Sat' 'Dinner' 1)
		(38.07 4.0 'Male' false 'Sun' 'Dinner' 3)
		(23.95 2.55 'Male' false 'Sun' 'Dinner' 2)
		(25.71 4.0 'Female' false 'Sun' 'Dinner' 3)
		(17.31 3.5 'Female' false 'Sun' 'Dinner' 2)
		(29.93 5.07 'Male' false 'Sun' 'Dinner' 4)
		(10.65 1.5 'Female' false 'Thur' 'Lunch' 2)
		(12.43 1.8 'Female' false 'Thur' 'Lunch' 2)
		(24.08 2.92 'Female' false 'Thur' 'Lunch' 4)
		(11.69 2.31 'Male' false 'Thur' 'Lunch' 2)
		(13.42 1.68 'Female' false 'Thur' 'Lunch' 2)
		(14.26 2.5 'Male' false 'Thur' 'Lunch' 2)
		(15.95 2.0 'Male' false 'Thur' 'Lunch' 2)
		(12.48 2.52 'Female' false 'Thur' 'Lunch' 2)
		(29.8 4.2 'Female' false 'Thur' 'Lunch' 6)
		(8.52 1.48 'Male' false 'Thur' 'Lunch' 2)
		(14.52 2.0 'Female' false 'Thur' 'Lunch' 2)
		(11.38 2.0 'Female' false 'Thur' 'Lunch' 2)
		(22.82 2.18 'Male' false 'Thur' 'Lunch' 3)
		(19.08 1.5 'Male' false 'Thur' 'Lunch' 2)
		(20.27 2.83 'Female' false 'Thur' 'Lunch' 2)
		(11.17 1.5 'Female' false 'Thur' 'Lunch' 2)
		(12.26 2.0 'Female' false 'Thur' 'Lunch' 2)
		(18.26 3.25 'Female' false 'Thur' 'Lunch' 2)
		(8.51 1.25 'Female' false 'Thur' 'Lunch' 2)
		(10.33 2.0 'Female' false 'Thur' 'Lunch' 2)
		(14.15 2.0 'Female' false 'Thur' 'Lunch' 2)
		(16.0 2.0 'Male' true 'Thur' 'Lunch' 2)
		(13.16 2.75 'Female' false 'Thur' 'Lunch' 2)
		(17.47 3.5 'Female' false 'Thur' 'Lunch' 2)
		(34.3 6.7 'Male' false 'Thur' 'Lunch' 6)
		(41.19 5.0 'Male' false 'Thur' 'Lunch' 5)
		(27.05 5.0 'Female' false 'Thur' 'Lunch' 6)
		(16.43 2.3 'Female' false 'Thur' 'Lunch' 2)
		(8.35 1.5 'Female' false 'Thur' 'Lunch' 2)
		(18.64 1.36 'Female' false 'Thur' 'Lunch' 3)
		(11.87 1.63 'Female' false 'Thur' 'Lunch' 2)
		(9.78 1.73 'Male' false 'Thur' 'Lunch' 2)
		(7.51 2.0 'Male' false 'Thur' 'Lunch' 2)
		(14.07 2.5 'Male' false 'Sun' 'Dinner' 2)
		(13.13 2.0 'Male' false 'Sun' 'Dinner' 2)
		(17.26 2.74 'Male' false 'Sun' 'Dinner' 3)
		(24.55 2.0 'Male' false 'Sun' 'Dinner' 4)
		(19.77 2.0 'Male' false 'Sun' 'Dinner' 4)
		(29.85 5.14 'Female' false 'Sun' 'Dinner' 5)
		(48.17 5.0 'Male' false 'Sun' 'Dinner' 6)
		(25.0 3.75 'Female' false 'Sun' 'Dinner' 4)
		(13.39 2.61 'Female' false 'Sun' 'Dinner' 2)
		(16.49 2.0 'Male' false 'Sun' 'Dinner' 4)
		(21.5 3.5 'Male' false 'Sun' 'Dinner' 4)
		(12.66 2.5 'Male' false 'Sun' 'Dinner' 2)
		(16.21 2.0 'Female' false 'Sun' 'Dinner' 3)
		(13.81 2.0 'Male' false 'Sun' 'Dinner' 2)
		(17.51 3.0 'Female' true 'Sun' 'Dinner' 2)
		(24.52 3.48 'Male' false 'Sun' 'Dinner' 3)
		(20.76 2.24 'Male' false 'Sun' 'Dinner' 2)
		(31.71 4.5 'Male' false 'Sun' 'Dinner' 4)
		(10.59 1.61 'Female' true 'Sat' 'Dinner' 2)
		(10.63 2.0 'Female' true 'Sat' 'Dinner' 2)
		(50.81 10.0 'Male' true 'Sat' 'Dinner' 3)
		(15.81 3.16 'Male' true 'Sat' 'Dinner' 2)
		(7.25 5.15 'Male' true 'Sun' 'Dinner' 2)
		(31.85 3.18 'Male' true 'Sun' 'Dinner' 2)
		(16.82 4.0 'Male' true 'Sun' 'Dinner' 2)
		(32.9 3.11 'Male' true 'Sun' 'Dinner' 2)
		(17.89 2.0 'Male' true 'Sun' 'Dinner' 2)
		(14.48 2.0 'Male' true 'Sun' 'Dinner' 2)
		(9.6 4.0 'Female' true 'Sun' 'Dinner' 2)
		(34.63 3.55 'Male' true 'Sun' 'Dinner' 2)
		(34.65 3.68 'Male' true 'Sun' 'Dinner' 4)
		(23.33 5.65 'Male' true 'Sun' 'Dinner' 2)
		(45.35 3.5 'Male' true 'Sun' 'Dinner' 3)
		(23.17 6.5 'Male' true 'Sun' 'Dinner' 4)
		(40.55 3.0 'Male' true 'Sun' 'Dinner' 2)
		(20.69 5.0 'Male' false 'Sun' 'Dinner' 5)
		(20.9 3.5 'Female' true 'Sun' 'Dinner' 3)
		(30.46 2.0 'Male' true 'Sun' 'Dinner' 5)
		(18.15 3.5 'Female' true 'Sun' 'Dinner' 3)
		(23.1 4.0 'Male' true 'Sun' 'Dinner' 3)
		(15.69 1.5 'Male' true 'Sun' 'Dinner' 2)
		(19.81 4.19 'Female' true 'Thur' 'Lunch' 2)
		(28.44 2.56 'Male' true 'Thur' 'Lunch' 2)
		(15.48 2.02 'Male' true 'Thur' 'Lunch' 2)
		(16.58 4.0 'Male' true 'Thur' 'Lunch' 2)
		(7.56 1.44 'Male' false 'Thur' 'Lunch' 2)
		(10.34 2.0 'Male' true 'Thur' 'Lunch' 2)
		(43.11 5.0 'Female' true 'Thur' 'Lunch' 4)
		(13.0 2.0 'Female' true 'Thur' 'Lunch' 2)
		(13.51 2.0 'Male' true 'Thur' 'Lunch' 2)
		(18.71 4.0 'Male' true 'Thur' 'Lunch' 3)
		(12.74 2.01 'Female' true 'Thur' 'Lunch' 2)
		(13.0 2.0 'Female' true 'Thur' 'Lunch' 2)
		(16.4 2.5 'Female' true 'Thur' 'Lunch' 2)
		(20.53 4.0 'Male' true 'Thur' 'Lunch' 4)
		(16.47 3.23 'Female' true 'Thur' 'Lunch' 3)
		(26.59 3.41 'Male' true 'Sat' 'Dinner' 3)
		(38.73 3.0 'Male' true 'Sat' 'Dinner' 4)
		(24.27 2.03 'Male' true 'Sat' 'Dinner' 2)
		(12.76 2.23 'Female' true 'Sat' 'Dinner' 2)
		(30.06 2.0 'Male' true 'Sat' 'Dinner' 3)
		(25.89 5.16 'Male' true 'Sat' 'Dinner' 4)
		(48.33 9.0 'Male' false 'Sat' 'Dinner' 4)
		(13.27 2.5 'Female' true 'Sat' 'Dinner' 2)
		(28.17 6.5 'Female' true 'Sat' 'Dinner' 3)
		(12.9 1.1 'Female' true 'Sat' 'Dinner' 2)
		(28.15 3.0 'Male' true 'Sat' 'Dinner' 5)
		(11.59 1.5 'Male' true 'Sat' 'Dinner' 2)
		(7.74 1.44 'Male' true 'Sat' 'Dinner' 2)
		(30.14 3.09 'Female' true 'Sat' 'Dinner' 4)
		(12.16 2.2 'Male' true 'Fri' 'Lunch' 2)
		(13.42 3.48 'Female' true 'Fri' 'Lunch' 2)
		(8.58 1.92 'Male' true 'Fri' 'Lunch' 1)
		(15.98 3.0 'Female' false 'Fri' 'Lunch' 3)
		(13.42 1.58 'Male' true 'Fri' 'Lunch' 2)
		(16.27 2.5 'Female' true 'Fri' 'Lunch' 2)
		(10.09 2.0 'Female' true 'Fri' 'Lunch' 2)
		(20.45 3.0 'Male' false 'Sat' 'Dinner' 4)
		(13.28 2.72 'Male' false 'Sat' 'Dinner' 2)
		(22.12 2.88 'Female' true 'Sat' 'Dinner' 2)
		(24.01 2.0 'Male' true 'Sat' 'Dinner' 4)
		(15.69 3.0 'Male' true 'Sat' 'Dinner' 3)
		(11.61 3.39 'Male' false 'Sat' 'Dinner' 2)
		(10.77 1.47 'Male' false 'Sat' 'Dinner' 2)
		(15.53 3.0 'Male' true 'Sat' 'Dinner' 2)
		(10.07 1.25 'Male' false 'Sat' 'Dinner' 2)
		(12.6 1.0 'Male' true 'Sat' 'Dinner' 2)
		(32.83 1.17 'Male' true 'Sat' 'Dinner' 2)
		(35.83 4.67 'Female' false 'Sat' 'Dinner' 3)
		(29.03 5.92 'Male' false 'Sat' 'Dinner' 3)
		(27.18 2.0 'Female' true 'Sat' 'Dinner' 2)
		(22.67 2.0 'Male' true 'Sat' 'Dinner' 2)
		(17.82 1.75 'Male' false 'Sat' 'Dinner' 2)
		(18.78 3.0 'Female' false 'Thur' 'Dinner' 2)).

	df columnNames: #(total_bill tip sex smoker day time size).
	^ df 
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> numericColumnNames [
	"Returns the copy of a DataFrame containing only numeric columns. These columns can be visualized"
	
	^ self columnNames select: [ :name |
		(self column: name) type inheritsFromOrEqualTo: Number ].
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> scatterplot [

	| n palette b ds |
	
	n := self numericColumnNames size.
	palette := DataColor palette: n.
	
	b := RTGrapher new.
	b extent: 300 @ 250.
	
	(self numericColumnNames) doWithIndex: [ :columnName :i |
		ds := RTData new.
		ds dotShape circle color: ((palette at: i) alpha: 0.8).
		ds points: (self column: columnName).
		b add: ds ].
	
	^ b
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> scatterplotMatrix [

	| b label block |
	
	b := DataScatterplotMatrix new.

	label := (RTLabel new)
		height: 17;
		color: (Color lightGray).

	b labelShape: label.
	b boxShape: (b boxShape borderWidth: 0.5).

	b objects: self.

	block := [ :k | k == k asInteger 
   		ifTrue: [ k asInteger ] 
		ifFalse: [ k asFloat ] ].
	
	b axisX 
		numberOfTicks: 5;
		rotateLabels;
		labelConversion: block.
		
	b axisY
		numberOfTicks: 5;
		labelConversion: block.

	b lineShape: (RTStyledMultiLine new
		dashedLine;
		width: 0.2; yourself).

	b shape circle
		size: 3.5;
		color: DataColor purple.

	self numericColumnNames doWithIndex: [ :name :i |
		b metrics at: name put: [ :row | row at: i ] ].

	b build.
	^ b
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> scatterplotMatrixOn: categoricalColName [

	| categories palette colorDict observedCols b label block lb |
	
	categories := (self column: categoricalColName) unique.
	palette := DataColor palette: categories size.
	
	colorDict := Dictionary new.
	
	categories doWithIndex: [ :category :i |
		colorDict at: category put: (palette at: i) ].
	
	observedCols := self columnNames select: [ :name |
		(self column: name) isQuantitative and:
		(name = categoricalColName) not ].
	
	b := DataScatterplotMatrix new.

	label := (RTLabel new)
		height: 17;
		color: (Color lightGray).

	b labelShape: label.
	b boxShape: (b boxShape borderWidth: 0.5).

	b objects: self.

	block := [ :k | k == k asInteger 
   		ifTrue: [ k asInteger ] 
		ifFalse: [ k asFloat ] ].
	
	b axisX 
		numberOfTicks: 5;
		rotateLabels;
		labelConversion: block.
		
	b axisY
		numberOfTicks: 5;
		labelConversion: block.

	b lineShape: (RTStyledMultiLine new
		dashedLine;
		width: 0.2; yourself).
	
	b shape circle
		size: 3.5;
		color: [ :a | colorDict at: (a atKey: categoricalColName) ].

	observedCols do: [ :name |
		b metrics at: name put: [ :row | row atKey: name ] ].

	b build.

	"If there are hundreds of categories, we don't want to include every single one into the legend"
	(categories size <= 10) ifTrue: [
		lb := RTLegendBuilder new.
		lb right.
		lb view: b view.
		lb addText: categoricalColName asString.
	
		categories do: [ :category |
			lb addColor: (colorDict at: category )
				text: category ].
	
		lb build ].
	
	^ b
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> show [

	self showWithGlamour openInWindowLabeled: 'a DataFrame'
]

{ #category : #'*DataFrame-Tools' }
DataFrame >> showWithGlamour [

	| table |

	table := FTTableMorph new
		"extent: 650@500".
		
	table addColumn: ((FTColumn id: '#') width: 40).
	
	self columnNames do: [ :colName |
		table addColumn: (FTColumn id: colName) ].
	
	table
		intercellSpacing: 1;
		dataSource: (DataFrameFTData elements: self);
		selectRowIndex: 1;
		showFirstRowSelection;
		onAnnouncement: FTSelectionChanged 
			do: [ :ann | ('rows selected: ', (ann newSelectedRowIndexes asString)) crLog ];
		onAnnouncement: FTStrongSelectionChanged 
			do: [ :ann | ('double-click on row: ', (ann selectedRowIndex asString)) crLog ];
		beMultipleSelection;
		yourself.
		
	^ table
]