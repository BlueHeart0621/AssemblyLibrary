;库文件准则：
;1. 凡是不涉及输出的寄存器均保持为原数据

public	compare, swap, qsort

code segment
	assume cs:code
;子程序：比较
;功能：比较指定数据类型的两个无符号数的大小
;输入参数：ds:[si],es:[di]分别指向两个无符号数
;		   的首地址，dl存储的为数据类型大小
;输出参数：dh=1,前者大于后者
;		   dh=0,两者相等
;		   dh=-1,后者大于前者
compare	proc far	
	push ax
	push cx
	push si
	push di
	
	push dx
	and	dx, 00ffh
	mov	cx, dx
	pop	dx
	
	add	si, cx
	dec si
	add	di, cx
	dec	di
	mov	dh, 0
	compare_circle:
		mov	ah, ds:[si]
		mov	al, es:[di]
		cmp	ah, al
		ja	above
		jz	equal
		
		less:
		mov	dh, -1
		jmp	compare_circle_end
		above:
		mov	dh, 1
		jmp compare_circle_end
		
		equal:		;相等则继续比较
		dec	si
		dec	di
	loop	compare_circle
	compare_circle_end:
	
	pop	di
	pop	si
	pop	cx
	pop	ax
	ret
compare endp


;子程序：交换
;功能：交换一对指定类型大小的数据的空间位置
;输入参数:ds:[si],es:[di]分别指向两个无符号数的首地址，
;		   dl存储的为数据类型大小
;输出参数：无
swap proc far
	push	ax
	push	cx
	push	dx
	push	si
	push	di
	
	and	dx, 00ffh
	mov	cx, dx
	swap_circle:
		mov	ah, ds:[si]
		mov	al, es:[di]
		mov	ds:[si], al
		mov	es:[di], ah
		inc	si
		inc	di
	loop	swap_circle
	
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	ax
	ret
swap endp

		
;子程序：快排
;功能：对一组无符号数据进行排序
;输入参数:ds:[si]指向原数组，cx储存的为数组长度，
;		   dl存储的为数据类型大小
;输出参数：无
qsort proc far stdcall dataseg:word, sireg:word, addseg:word, direg:word
	push ax
	push bx
	push cx
	push dx
	push es
	push di
	push si
	
	cmp	cx, 1
	jbe	return
	
	mov	ax, ds
	mov	es, ax
	
	;取得数组尾地址
	mov	dh, 0
	mov	ax, cx
	mul	dl
	mov	di, ax
	add	di, si
	sub	di, dx

	push	di
	push	si
	this_sort_circle:
		cmp	si, di
		jz	this_sort_circle_end
		

		mov	ax, di
		sub	ax, si
		div	dl
		mov	cx, ax
		left_swap_circle:
			call far ptr compare
			cmp	dh, 0
			jle	left_next_compare
			call far ptr swap
			jmp	left_swap_circle_end
			
			left_next_compare:
			mov	dh, 0
			add	si, dx
		loop	left_swap_circle
		left_swap_circle_end:
		
		cmp	si, di
		jz	this_sort_circle_end
		
		mov	ax, di
		sub	ax, si
		div	dl
		mov	cx, ax
		right_swap_circle:
			call far ptr compare
			cmp	dh, 0
			jle	right_next_compare
			call far ptr swap
			jmp	right_swap_circle_end
			
			right_next_compare:
			mov	dh, 0
			sub	di, dx
		loop	right_swap_circle
		right_swap_circle_end:

	jmp	this_sort_circle
	this_sort_circle_end:
	
	pop	si
	mov	ax, di
	sub	ax, si
	div	dl
	mov	cx, ax
	call far ptr qsort
	
	mov	si, di
	pop	di
	mov	ax, di
	sub	ax, si
	div	dl
	mov	cx, ax
	and	dx, 00ffh
	add	si, dx
	call far ptr qsort
	
	return:
	pop	si
	pop	di
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
qsort endp
code ends
end
	
	
	
	
	
	