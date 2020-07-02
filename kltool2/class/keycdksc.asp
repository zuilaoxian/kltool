<%
public function Generate_Key()
 Randomize
 do
 num  =  Int((75  *  Rnd)+48)
 found  =  false
 if  num  >=  58  and  num  <=  64  then 
 found  =  true
 else
 if  num  >=91  and  num  <=96  then
 found  =  true
 end  if
 end  if
 if  found  =  false  then
 RSKey  =  RSKey+Chr(num)
 end  if
 loop  until  len(RSKey)=16
 Generate_Key=RSKey
 end  function
%>