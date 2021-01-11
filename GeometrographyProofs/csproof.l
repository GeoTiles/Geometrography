%{
#define YYSTYPE long long int 
#include "csproof.tab.h"
#include <stdlib.h>   
#include <stdio.h>
#include <math.h>
%}


%%
[ \t]+      { ; }  /* elimina espaços e "tabs */

[0-9]+    {
              sscanf(yytext,"%lld",&yylval);
              //printf("%lld\n",yylval);
              return(NUMBER);
            }

"by fraction equal 0" {
                        //printf("by fraction equal 0\n");
                       return(ALGEBRAICSTEPS);
                      }
"by fraction with number denominator" { 
                        //printf("by fraction with number denominator\n");
                                       return(ALGEBRAICSTEPS);
                                      } 
"by multiplication of fractions" { 
                        //printf("by multiplication of fractions\n");
                                  return(ALGEBRAICSTEPS);
                                 }

"by multiple fraction simplification" { 
                        //printf("by multiple fraction simplification\n");
                                  return(ALGEBRAICSTEPS);
                                 }

"by multiplication by 0" { 
                        //printf("by multiplication by 0\n");
                          return(ALGEBRAICSTEPS);
                         }

"by multiplication by 1" { 
                        //printf("by multiplication by 1\n");
                          return(ALGEBRAICSTEPS);
                         }  

"by multiplication of constants" { 
                        //printf("by multiplication of constants\n");
                                  return(ALGEBRAICSTEPS);
                                 }  

"by addition with 0" { 
                        //printf("by addition with 0\n");
                      return(ALGEBRAICSTEPS);
                     }  

"by sum of fractions" { 
                        //printf("by sum of fractions\n");
                       return(ALGEBRAICSTEPS);
                      }  

"by distribution of multiplication over addition" { 
                                                   //printf("by distribution of multiplication over addition\n");
                                                   return(ALGEBRAICSTEPS);
                                                  }  

"by associativity and commutativity" { 
                        //printf("by associativity and commutativity\n");
                                      return(ALGEBRAICSTEPS);
                                     }  

"by right association" { 
                        //printf("by right association\n");
                        return(ALGEBRAICSTEPS);
                       }  

"by ratio cancellation" { 
                        //printf("by ratio cancellation\n");
                         return(ALGEBRAICSTEPS);
                        }  

"by cancellation rule" {
                        //printf("by cancellation rule\n");
                       return(ALGEBRAICSTEPS);
}

"by similar summands" {
                        //printf("by similar summands\n");
                       return(ALGEBRAICSTEPS);
                       }  

"by the statement" {
                        //printf("by the statement\n");
                 return(STATEMENT);
                }

"by Lemma" {
                        //printf("by Lemma\n");
            return(LEMMA);
           }


\n         {
            //printf("mudança de linha\n");
            return (yytext[0]);
           }

.        {
          ; //printf("ignores all the other words\n"); 
         }

%%

int yywrap()                  /* called by yylex()            */
{ return(1); }                /* 0: yylex() continues reading */
                              /* other: yylex() stops         */
