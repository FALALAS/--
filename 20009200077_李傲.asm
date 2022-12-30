;姓名：李傲
;学号：20009200077
;班级：2020039
DATA SEGMENT 
    ;定义字符串   
    welcome DB 'plase input the function number (1~5): $'
	scanf DB 'please input character: ','$'
    catchError DB 'Error: Invaild Input$'
    return0 DB 'What do you want to do next" Main Menu or Redo" [ESC/any other key]: $' 
    
    resultTask2info DB 'The maximum is: $'
    scanf3 DB 'please input the decimal numbers: ',0DH,0AH,'$'
    
    Task4info DB 'press anykey to display the time$'  
 
    info1 DB 'Now, we are doing function 1: $' 
    info2 DB 'Now, we are doing function 2: $' 
    info3 DB 'Now, we are doing function 3: $' 
    
    ;初始化变量
    inputTask1 DB 100 dup(0)
    resultTask1 DB 100 dup(0) 
    
    inputTask2 DB 100 dup(0)  
    resultTask2 DB 10 dup(0)
    	 
    inputTask3 DB 100 dup(0)
    inputTask3init DB 100 dup(0) 
    countTask3 DB 10 dup(0)
    resultTask3 DB 100 dup(0)
    	        
    hour DB 0
    minute DB 0
    second DB 0
    time DB "00:00:00$"  
    len equ $-time
    num DB 10   
DATA ENDS

STACK SEGMENT
STACK ENDS 

;输入  
getchar MACRO
    MOV AH,1
    INT 21H
ENDM

;输出  
puts MACRO string
    LEA DX,string
    MOV AH,09H
    INT 21H
ENDM 

;换行，用C中的\n来代表
\n MACRO
    MOV AH,2      
    MOV DL,0DH  ;回车
    INT 21h
    MOV AH,2
    MOV DL,0AH  ;换行
    INT 21h
ENDM       
          
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX     

main:           
    puts welcome
    getchar
    ;转入各function/非法输入
    CMP AL,31H
    JB invalid   ;比1小
    JE function1
     
    CMP AL,32H
    JE function2
     
    CMP AL,33H
    JE function3 
    
    CMP AL,34H
    JE function4
     
    CMP AL,35H
    JE function5 
    JA invalid   ;比5大

;非法输入
invalid:
    \n
    puts catchError
    \n
    \n
    JMP main
 
return_menu:
     \n
     JMP main     

;功能1：将字符串中的小写字母变换成大写字母
function1 PROC
    \n 
    \n 
    puts info1
    \n 
    puts scanf
    LEA SI,inputTask1          
    
streamInput1:    
    getchar
    CMP AL,0DH  ;回车
    JE store1
    CMP AL,20H  ;空格
    JE store1
      
    ;设置输入字符的范围     
    CMP AL,30H  ;0
    JB  errorInput1 ;比0小的不符合条件
    CMP AL,39H  ;9
    JBE store1
    
    CMP AL,41H  ;A
    JB errorInput1  ;(9,A)之间的不符合条件
    CMP AL,5AH  ;Z
    JBE store1
    
    CMP AL,61H  ;a
    JB errorInput1  ;(A,a)之间的不符合条件  
    CMP AL,7AH  ;z
    JBE store1  ;比z大的字符会直接进入errorInput1 
    
errorInput1:
    \n
    puts catchError
    \n
    \n
    puts scanf
    LEA SI,inputTask1
    JMP streamInput1
   
store1:     
    MOV [SI],AL ;将输入的字符传输至[SI]
    INC SI
    INC DI 
    
    CMP AL,0DH  ;检测是否是回车
    JE begin1   ;是则不再输入，并且开始处理字符
    
    JMP streamInput1
    
;相当于让指针重新指向第一位
begin1:    
    LEA SI,inputTask1
    LEA DI,resultTask1
    
deal1:     
    MOV AL,[SI] 
    
    CMP AL,0DH  ;检测是否是回车   
    JE output1  ;是回车则输出
    
    CMP AL,61H  ;由于字符串中只有数字及字母，因此只需比较与a的大小
    JB deal1Solve     
    SUB AL,20H  ;是小写字母则减去20H
    
deal1Solve:
    MOV [DI],AL
    INC SI
    INC DI 
    JMP deal1
    
output1:
    \n 
    MOV [SI],'$'    ;此时指针是指向字符串的后一位    
    MOV [DI],'$' 

    puts inputTask1
    \n           
    puts resultTask1
    \n
    
    \n
    puts return0    
    getchar
    CMP AL,1BH  ;检测是否是Esc 
    JE return_menu  
    JMP function1   

function1 ENDP

;功能二：在字符串中找最大值
function2 PROC   
    \n 
    \n 
    puts info2
    \n 
    puts scanf
    LEA SI,inputTask2
    
streamInput2:    
    getchar

    CMP AL,0DH
    JE store2
    ;设置输入字符的范围，判断条件与上个功能类似     
    CMP AL,30H ;0
    JB errorInput2
    CMP AL,39H ;9
    JBE store2 
    
    CMP AL,41H ;A
    JB errorInput2
    CMP AL,5AH ;Z
    JBE store2
    
    CMP AL,61H ;a
    JB errorInput2    
    CMP AL,7AH ;z
    JBE store2   
            
store2:
    MOV [SI],AL
    INC SI
    
    CMP AL,0DH  ;检测是否是回车
    JE begin2 
    JMP streamInput2 
  
errorInput2:
    \n
    puts catchError
    \n
    \n
    puts scanf 
    JMP function2
    
begin2:    
    LEA SI,inputTask2
    LEA DI,resultTask2
    ;初始化    
    MOV AL,[SI]
    MOV [DI],AL ;[DI]用来存储最大值
    INC SI
       
deal2:    
    MOV AL,[SI]  ;当前的值
    MOV AH,[DI]  ;当前的最大值
    
    CMP AL,0DH   ;检测是否是回车   
    JE output2
    
    CMP AL,AH
    JA deal2Solve   ;大于则修改最大值  
    INC SI
    JMP deal2
    
deal2Solve:
    MOV [DI],AL
    INC SI
    JMP deal2
    
output2:
    \n
    MOV [SI],'$'
    INC DI    
    MOV [DI],'$'

    \n   
    puts inputTask2
    
    MOV DL,20H  ;中间间隔一个空格
    MOV AH,2
    INT 21H
     
    puts resultTask2info
    puts resultTask2
    \n
    \n
    
    puts return0    
    getchar
    CMP AL,1BH  ;检测是否是Esc 
    JE return_menu 
    JMP function2  

function2 ENDP
 
;功能三：输入数据组的排序
function3 PROC 
    \n 
    \n 
    puts info3
    \n     
    puts scanf3 
    MOV    CL,0 ;用CL存储数组长度
    MOV    BH,0    
    MOV    DI,0    
    LEA SI,inputTask3
    LEA DI,inputTask3init  
    
streamInput3:
    getchar
    CMP AL,0DH  ;检测是否按下回车键 
    JE break3init
    
    CMP AL,20H ;检测是否按下空格键 
    JE store3init  

    CMP AL,30H ;0
    JB     errorInput3
    CMP    AL,39H ;9
    JA     errorInput3
    JMP store3init

store3init:
    MOV [DI],AL
    INC DI
    JMP streamInput3
    
;输出回车之后    
break3init:
    \n
    \n
    MOV [DI],'$'
    puts inputTask3init ;先输出原本的字符串
    LEA DI,inputTask3init
    
;保存用来进位的数
carry3:    
    MOV    DL,0 
    MOV    DH,10 
    
ACSIIto10:
    MOV AL,[DI]
    
    CMP AL,24H  ;检测是否按下回车键 
    JE break3   
    CMP AL,20H  ;检测是否按下空格键 
    JE save3  

    CMP AL,30H ;0
    JB errorInput3
    CMP AL,39H ;9
    JA errorInput3
    
    MOV BH,0      
    ;ASCII码转十进制数
    AND AL,0FH ;高4位清零 
    MOV BL,AL
    MOV AL,DL
    MUL DH ;每一个高位*10
    ADD AX,BX
    MOV DL,AL
    INC DI 
    JMP ACSIIto10 
    
errorInput3: 
    \n
    puts catchError   
    JMP function3

;检测到空格则进行一次数值保存 
save3:    
    CMP BH,0
    JNZ reStore3
    MOV [SI],DL
    INC DI
    INC SI
    INC CL  
    
reStore3:    
    MOV BH,1
    JMP carry3     
   
break3:    
    MOV [SI],DL 
    INC SI
    INC CL
    LEA DI,countTask3
    MOV [DI],CL

LEA DI,countTask3
MOV CL,[DI]         
LEA DI,inputTask3 
\n

;输出十六进制数
output3hexadecimal:   
    MOV BH,[DI]
    MOV DL,BH
    AND DL,0F0H ;低位清零
    SHR DL,4    ;逻辑右移，将DL右移4位    
    CMP DL,0AH
    JAE output3Highletter
    ADD DL,30H  ;数值0-9要进行显示需转换成ASCII码，需+30H
    JMP output3High  

;用来写当前十六进制数的高位    
output3Highletter:  ;输出A-F
    ADD DL,37H    
    
output3High:    ;输出0-9
    MOV AH,2
    INT 21H
    MOV DL,BH
    AND DL,00FH ;高位清零  
    CMP DL,0AH
    JGE output3Lowletter    ;JGE大于等于
    ADD DL,30H
    JMP output3Low 
    
;写当前十六进制数的低位    
output3Lowletter: ;输出A-F
    ADD    DL,37H     
      
output3Low: ;输出0-9 
    MOV    AH,2
    INT    21H   
    ;输出一个H
    MOV    DL,48H
    MOV    AH,2
    INT    21H
    ;输出空格
    MOV    DL,20h
    MOV    AH,2
    INT    21H

    INC    DI
    DEC    CL
    CMP    CL,0   ;CL记录剩余处理的字符数量，假如不为0，继续跳转运行
    JNE    output3hexadecimal
 
;选择排序
sort: 
    LEA    SI,countTask3
    MOV    CL,[SI]
    LEA    SI,inputTask3   
    
;外循环
fori:
    LEA    DI,countTask3 
    MOV    CH,CL
    MOV    DI,SI
    INC    DI  
;内循环 
forj:
    MOV    BL,[SI]    
    MOV    BH,[DI]
    CMP    BL,BH                                   
    JBE    afterswap
    MOV    [SI],BH
    MOV    [DI],BL    
    
afterswap:
    DEC    CH
    INC    DI
    CMP    CH,1
    JA     forj
    
    INC    SI
    DEC    CL
    CMP    CL,1                               
    JA     fori
             
LEA    DI,countTask3
MOV    CL,[DI]    
LEA    DI,inputTask3
\n
    
;输出排序后的结果    
output3Sorted:   
    MOV    BH,[DI]
    MOV    DL,BH
    AND    DL,0F0H ;低位清零
    SHR    DL,4    ;逻辑右移，将DL右移4位    
    CMP    DL,0AH
    JGE    output3Highletter2
    ADD    DL,30H  ;数值0-9要进行显示需转换成ASCII码，需+30H
    JMP    output3High2  

output3Highletter2:
    ADD    DL,37H  ;输出A-F  
    
output3High2:   ;输出0-9
    MOV AH,2
    INT 21H
    MOV DL,BH
    AND DL,00FH ;高位清零  
    CMP DL,0AH
    JAE output3Lowletter2 
    ADD DL,30H
    JMP output3Low2 
        
output3Lowletter2:  ;输出A-F
    ADD    DL,37H     
      
output3Low2:    ;输出0-9  
    MOV AH,2
    INT 21H    
    ;输出一个H
    MOV DL,48H
    MOV AH,02H
    INT 21H   
    ;输出空格
    MOV DL,20h
    MOV AH,2
    INT    21H        
    INC    DI
    DEC    CL
    CMP    CL,0             ;CL记录剩余处理的字符数量，假如不为0，继续跳转运行
    JNE    output3Sorted     
    \n
    \n 

    puts return0    
    getchar
    CMP AL,1BH  ;判断是否按下esc 
    JE return_menu 
    JMP function3 
             
function3 ENDP


;功能四：输出系统时间到屏幕右上角
function4 PROC   
    \n
    \n
    puts Task4info
    getchar
    \n     

getSystemtime: 

    MOV AH,2CH  ;获取时间
    INT 21H         
    MOV hour,CH ;时
    MOV minute,CL   ;分 
    MOV second,DH   ;秒

    ;输出时间
    MOV AX, 0      
    MOV AL, hour  
    DIV num
    ADD AL,30H
    MOV time[0], AL
    ADD AH,30H
    MOV time[1], AH 
    
    MOV AX,0
    MOV AL,minute
    DIV num
    ADD AL,30H
    MOV time[3],AL
    ADD AH,30H
    MOV time[4],AH
    
    MOV AX,0
    MOV AL,second
    DIV num
    ADD AL,30H
    MOV time[6],AL
    ADD AH,30H
    MOV time[7],AH
    
    LEA DX,time
    MOV AH,9   
    INT 21h  

output4:
    \n
    puts return0    
    getchar
    CMP AL, 1BH 
    JE return_menu
     
    JMP function4  

function4 ENDP
 
 
;功能五：退出 
function5 PROC
    MOV AH, 4CH
    INT 21h
function5 ENDP    
   	
CODE ENDS
    END START