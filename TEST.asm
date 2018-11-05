include MYLIB.inc
includelib MYLIB.lib

data segment
	mydata	dd	1283345h, 873426h, 432312h, 0123498h, 345425h, 873246h, 985247h, 45623425h, 345342h, 98235267h, 31456543h, 0233021h, 76352353h, 12234234h
	mydata_end	dd  45623425h
data ends

code segment
	assume	cs:code, ds:data
start:
	mov	ax, data
	mov	ds, ax
	mov	es, ax
	mov	dl, type mydata
	mov	cx, (mydata_end - mydata)/(type mydata)
	lea	si, mydata
	lea	di, mydata_end
	;call far ptr bisearch
	
	call far ptr qsort
	
	mov	ax, 4c00h
	int 21h
code ends
end start