# 1 "gnulib.c"
 
 

# 1 "../../gcc1.36/config.h" 1
 



















 



 





 





 

# 1 "../../gcc1.36/tm.h" 1
 



















# 1 "../../gcc1.36/config/tm-i386.h" 1
 



















 


 

 




 

extern int target_flags;

 

 

 

  

 





 














 

 

 
 

 

 
 
 

 
 
 

 


 





 


 



 


 


 


 



 
 



 

 

 

 











 






 

 











 













 







 






 


 

 

 


 


 

 





 


 


 






 





 


















   

enum reg_class {
  NO_REGS, AREG, DREG, ADREG, CREG, BREG, Q_REGS,
  INDEX_REGS, GENERAL_REGS, FLOAT_REGS, ALL_REGS, LIM_REG_CLASSES };



 




 








 


















  
 




 






 




 









 











 





 








# 347 "../../gcc1.36/config/tm-i386.h"

 

 





 

 



 





 





 







 


 





















 





 





 










 








 








 













 







 











 










 







 



 





 












 






# 572 "../../gcc1.36/config/tm-i386.h"
 

 
 

 
 

 

 













 














 


 

   




# 630 "../../gcc1.36/config/tm-i386.h"


 











 










 










 









 














 


















# 738 "../../gcc1.36/config/tm-i386.h"

 






 



 


 

 




 


 


 



 
 

 


 




 



 




 




 




 




 





 





# 830 "../../gcc1.36/config/tm-i386.h"

 

 





 


 



 







 















 







 


 







 


 




 







 









 

 



 





 





 









 









 






 
 






 














 




 





 





 





 







 





 








 




















 






 





 





 




# 21 "../../gcc1.36/tm.h" 2

 
 














# 1 "../../gcc1.36/config/tm-bsd386.h" 1
 




















 



 













 





 


 


 


 


 



 


 


 



 




  
 



 











 

 






 



 





 


 




 




 

 





 



 



 

 







 







 






 







 





 




 


 

 
 





 




# 38 "../../gcc1.36/tm.h" 2


 



 



 



 



 



 



 



 



 





 




 

 







 






# 39 "../../gcc1.36/config.h" 2









# 4 "gnulib.c" 2


 





 












union flt_or_int { int i; float f; };


# 39 "gnulib.c"









































































































































# 187 "gnulib.c"





























# 224 "gnulib.c"


# 234 "gnulib.c"


# 244 "gnulib.c"


# 257 "gnulib.c"


# 267 "gnulib.c"


# 277 "gnulib.c"


# 287 "gnulib.c"


# 297 "gnulib.c"


# 316 "gnulib.c"


# 342 "gnulib.c"


 


typedef void (*vfp)();

extern vfp __new_handler;

char *
__builtin_new (sz)
     long sz;
{
  char *p;

  p = (char *)malloc (sz);
  if (p == 0)
    (*__new_handler) ();
  return p;
}


# 423 "gnulib.c"


# 458 "gnulib.c"
