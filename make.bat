cd .\tests\
for %%x in (*.c64f) do del "%%x" 
for %%x in (*.bin) do ..\tools\c64f.exe "%%x" "%%~nx.bin.c64f"

cd ..
cmd /c "BeebAsm.exe -v -i c64f_test.s.asm -do c64f_test.ssd -opt 3"