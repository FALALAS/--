;���������
;ѧ�ţ�20009200077
;�༶��2020039
DATA SEGMENT 
    ;�����ַ���   
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
    
    ;��ʼ������
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

;����  
getchar MACRO
    MOV AH,1
    INT 21H
ENDM

;���  
puts MACRO string
    LEA DX,string
    MOV AH,09H
    INT 21H
ENDM 

;���У���C�е�\n������
\n MACRO
    MOV AH,2      
    MOV DL,0DH  ;�س�
    INT 21h
    MOV AH,2
    MOV DL,0AH  ;����
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
    ;ת���function/�Ƿ�����
    CMP AL,31H
    JB invalid   ;��1С
    JE function1
     
    CMP AL,32H
    JE function2
     
    CMP AL,33H
    JE function3 
    
    CMP AL,34H
    JE function4
     
    CMP AL,35H
    JE function5 
    JA invalid   ;��5��

;�Ƿ�����
invalid:
    \n
    puts catchError
    \n
    \n
    JMP main
 
return_menu:
     \n
     JMP main     

;����1�����ַ����е�Сд��ĸ�任�ɴ�д��ĸ
function1 PROC
    \n 
    \n 
    puts info1
    \n 
    puts scanf
    LEA SI,inputTask1          
    
streamInput1:    
    getchar
    CMP AL,0DH  ;�س�
    JE store1
    CMP AL,20H  ;�ո�
    JE store1
      
    ;���������ַ��ķ�Χ     
    CMP AL,30H  ;0
    JB  errorInput1 ;��0С�Ĳ���������
    CMP AL,39H  ;9
    JBE store1
    
    CMP AL,41H  ;A
    JB errorInput1  ;(9,A)֮��Ĳ���������
    CMP AL,5AH  ;Z
    JBE store1
    
    CMP AL,61H  ;a
    JB errorInput1  ;(A,a)֮��Ĳ���������  
    CMP AL,7AH  ;z
    JBE store1  ;��z����ַ���ֱ�ӽ���errorInput1 
    
errorInput1:
    \n
    puts catchError
    \n
    \n
    puts scanf
    LEA SI,inputTask1
    JMP streamInput1
   
store1:     
    MOV [SI],AL ;��������ַ�������[SI]
    INC SI
    INC DI 
    
    CMP AL,0DH  ;����Ƿ��ǻس�
    JE begin1   ;���������룬���ҿ�ʼ�����ַ�
    
    JMP streamInput1
    
;�൱����ָ������ָ���һλ
begin1:    
    LEA SI,inputTask1
    LEA DI,resultTask1
    
deal1:     
    MOV AL,[SI] 
    
    CMP AL,0DH  ;����Ƿ��ǻس�   
    JE output1  ;�ǻس������
    
    CMP AL,61H  ;�����ַ�����ֻ�����ּ���ĸ�����ֻ��Ƚ���a�Ĵ�С
    JB deal1Solve     
    SUB AL,20H  ;��Сд��ĸ���ȥ20H
    
deal1Solve:
    MOV [DI],AL
    INC SI
    INC DI 
    JMP deal1
    
output1:
    \n 
    MOV [SI],'$'    ;��ʱָ����ָ���ַ����ĺ�һλ    
    MOV [DI],'$' 

    puts inputTask1
    \n           
    puts resultTask1
    \n
    
    \n
    puts return0    
    getchar
    CMP AL,1BH  ;����Ƿ���Esc 
    JE return_menu  
    JMP function1   

function1 ENDP

;���ܶ������ַ����������ֵ
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
    ;���������ַ��ķ�Χ���ж��������ϸ���������     
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
    
    CMP AL,0DH  ;����Ƿ��ǻس�
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
    ;��ʼ��    
    MOV AL,[SI]
    MOV [DI],AL ;[DI]�����洢���ֵ
    INC SI
       
deal2:    
    MOV AL,[SI]  ;��ǰ��ֵ
    MOV AH,[DI]  ;��ǰ�����ֵ
    
    CMP AL,0DH   ;����Ƿ��ǻس�   
    JE output2
    
    CMP AL,AH
    JA deal2Solve   ;�������޸����ֵ  
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
    
    MOV DL,20H  ;�м���һ���ո�
    MOV AH,2
    INT 21H
     
    puts resultTask2info
    puts resultTask2
    \n
    \n
    
    puts return0    
    getchar
    CMP AL,1BH  ;����Ƿ���Esc 
    JE return_menu 
    JMP function2  

function2 ENDP
 
;�����������������������
function3 PROC 
    \n 
    \n 
    puts info3
    \n     
    puts scanf3 
    MOV    CL,0 ;��CL�洢���鳤��
    MOV    BH,0    
    MOV    DI,0    
    LEA SI,inputTask3
    LEA DI,inputTask3init  
    
streamInput3:
    getchar
    CMP AL,0DH  ;����Ƿ��»س��� 
    JE break3init
    
    CMP AL,20H ;����Ƿ��¿ո�� 
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
    
;����س�֮��    
break3init:
    \n
    \n
    MOV [DI],'$'
    puts inputTask3init ;�����ԭ�����ַ���
    LEA DI,inputTask3init
    
;����������λ����
carry3:    
    MOV    DL,0 
    MOV    DH,10 
    
ACSIIto10:
    MOV AL,[DI]
    
    CMP AL,24H  ;����Ƿ��»س��� 
    JE break3   
    CMP AL,20H  ;����Ƿ��¿ո�� 
    JE save3  

    CMP AL,30H ;0
    JB errorInput3
    CMP AL,39H ;9
    JA errorInput3
    
    MOV BH,0      
    ;ASCII��תʮ������
    AND AL,0FH ;��4λ���� 
    MOV BL,AL
    MOV AL,DL
    MUL DH ;ÿһ����λ*10
    ADD AX,BX
    MOV DL,AL
    INC DI 
    JMP ACSIIto10 
    
errorInput3: 
    \n
    puts catchError   
    JMP function3

;��⵽�ո������һ����ֵ���� 
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

;���ʮ��������
output3hexadecimal:   
    MOV BH,[DI]
    MOV DL,BH
    AND DL,0F0H ;��λ����
    SHR DL,4    ;�߼����ƣ���DL����4λ    
    CMP DL,0AH
    JAE output3Highletter
    ADD DL,30H  ;��ֵ0-9Ҫ������ʾ��ת����ASCII�룬��+30H
    JMP output3High  

;����д��ǰʮ���������ĸ�λ    
output3Highletter:  ;���A-F
    ADD DL,37H    
    
output3High:    ;���0-9
    MOV AH,2
    INT 21H
    MOV DL,BH
    AND DL,00FH ;��λ����  
    CMP DL,0AH
    JGE output3Lowletter    ;JGE���ڵ���
    ADD DL,30H
    JMP output3Low 
    
;д��ǰʮ���������ĵ�λ    
output3Lowletter: ;���A-F
    ADD    DL,37H     
      
output3Low: ;���0-9 
    MOV    AH,2
    INT    21H   
    ;���һ��H
    MOV    DL,48H
    MOV    AH,2
    INT    21H
    ;����ո�
    MOV    DL,20h
    MOV    AH,2
    INT    21H

    INC    DI
    DEC    CL
    CMP    CL,0   ;CL��¼ʣ�ദ����ַ����������粻Ϊ0��������ת����
    JNE    output3hexadecimal
 
;ѡ������
sort: 
    LEA    SI,countTask3
    MOV    CL,[SI]
    LEA    SI,inputTask3   
    
;��ѭ��
fori:
    LEA    DI,countTask3 
    MOV    CH,CL
    MOV    DI,SI
    INC    DI  
;��ѭ�� 
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
    
;��������Ľ��    
output3Sorted:   
    MOV    BH,[DI]
    MOV    DL,BH
    AND    DL,0F0H ;��λ����
    SHR    DL,4    ;�߼����ƣ���DL����4λ    
    CMP    DL,0AH
    JGE    output3Highletter2
    ADD    DL,30H  ;��ֵ0-9Ҫ������ʾ��ת����ASCII�룬��+30H
    JMP    output3High2  

output3Highletter2:
    ADD    DL,37H  ;���A-F  
    
output3High2:   ;���0-9
    MOV AH,2
    INT 21H
    MOV DL,BH
    AND DL,00FH ;��λ����  
    CMP DL,0AH
    JAE output3Lowletter2 
    ADD DL,30H
    JMP output3Low2 
        
output3Lowletter2:  ;���A-F
    ADD    DL,37H     
      
output3Low2:    ;���0-9  
    MOV AH,2
    INT 21H    
    ;���һ��H
    MOV DL,48H
    MOV AH,02H
    INT 21H   
    ;����ո�
    MOV DL,20h
    MOV AH,2
    INT    21H        
    INC    DI
    DEC    CL
    CMP    CL,0             ;CL��¼ʣ�ദ����ַ����������粻Ϊ0��������ת����
    JNE    output3Sorted     
    \n
    \n 

    puts return0    
    getchar
    CMP AL,1BH  ;�ж��Ƿ���esc 
    JE return_menu 
    JMP function3 
             
function3 ENDP


;�����ģ����ϵͳʱ�䵽��Ļ���Ͻ�
function4 PROC   
    \n
    \n
    puts Task4info
    getchar
    \n     

getSystemtime: 

    MOV AH,2CH  ;��ȡʱ��
    INT 21H         
    MOV hour,CH ;ʱ
    MOV minute,CL   ;�� 
    MOV second,DH   ;��

    ;���ʱ��
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
 
 
;�����壺�˳� 
function5 PROC
    MOV AH, 4CH
    INT 21h
function5 ENDP    
   	
CODE ENDS
    END START