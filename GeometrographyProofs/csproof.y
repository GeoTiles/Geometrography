%{
#define YYSTYPE long long int 
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
  // csStatement + csAS + csGS + 40 Lemmas = 43 (0..42)
#define NUMCS 43
  // define the (initial) maximun number of steps
#define MAXNUMSTEPS 100000
  // define the Maximum value of the coeficients of simplicity of the steps
#define MAXVALUECSSTEPS 150
  // The thresold for difficult steps in proofs
  
  int yylex();
  
  int yyerror(char *s);
  // Steps
  int steps=0;
  // Coefficent of Simplicity
  long long int csTotal = 0;
  // number of consecutive algebraic steps
  int consecutiveAlgSteps=0;
  
  // number of occurrences of the different elements(43 elementos)
  int numberOcurrences[NUMCS] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  
  /* 
   * Coeficients of Simplicity 
   * 0 - Statement, 
   * 1 - csAS, 
   * 2 - csGS,
   * i+2 - csLemma_i = cs
   *
   * lemma i (1st time,2nd time)
   *  l1=(10,9);   l2=(16,11); l3a=(21,15);  l3b=(33,15);  l4=(25,10);  
   *  l5=(18,11);  l6=(14,10);  l7=(22,16);  l8a=(84,14);  l8b=(94,14);
   * l8c=(97,10);  l9=(74,22); l10=(13,11);  l11=(10,6);   l12=(14,11);
   * l13=(21,15); l14=(8,5);   l15=(138,30); l16=(142,39); l17=(18,4)
   * l18=(31,9);  l19=(15,4);  l20=(23,6);   l21=(59,12);  l22=(228,9);
   * l23=(46,10); l24a=(58,7); l24b=(32,7); l24c=(32,7);  l25a=(326,20);
   * l25b=(370,20); l25c=(370,20); l26a=(745,36); l26b=(1646,36);
   * l27a=(539,19); l27b=(740,44); l28a=(118,14); l28b=(852,14);
   * l28c=(206,14); l28d=(1781,14); l29a=(287,14); l29b=(1418,14);
   * l30=(321,10); l31=(942,10); l32a=(1743,7); l32b=(1848,10);
   * l33=(2807,16); l34=(404,13); l35=(359,13); l36=(566,9);
   * l37a=(379,24); l37b=(284,25); l38a=(647,23); l38b=(196,15);
   * l39a=(37,24); l39b=(259,24); l40a=(761,17); l40b=(927,17)
   *
   * GCLC prover Area Method
   *
   * Lemma 1, 
   * Lemma 2 (equal), Lemma 2 (collinearity), (S_ABC = 0 if A,B,C are collinear)
   * --- lemma 3 PQ||AB sse S_PAB = S_QAB
   * Lemma 4, 
   * --- lemma 5 S_PCD/S_PAB = CD/AB
   * --- lemma 6 S_ABCD = S_ABD + S_BCD
   * --- lemma 7 S_ABCD = diferentes combinações
   * Lemma 8, EL1 ... três casos / quase de certeza é o 1º, os outros S_ABCD
   * --- lemma 9 S_RAB = PR/PQ S_QAB + RQ/PQ S_PAB
   * Lemma 10, 
   * Lemma 11, 
   * --- lemma 12 PQ/AB AB/PQ = 1
   * --- lemma 13 AP/AB + PB/AB = 1
   * --- lemma 14 r = AP/AB
   * --- lemma 15 ABCD parallelogram ...
   * --- lemma 16 ABCD parallelogram ...
   * Lemma 17, 
   * Lemma 18, 
   * Lemma 19, 
   * --- lemma 20 A,B,C collinear P_ABC = 2AB BC
   * --- lemma 21 ABCD
   * --- lemma 22 AB _|_ BC P_ABC = 0
   * --- lemma 23 AB _|_ CD sse P_ABC = P_BCD or P_ABCD = 0
   * --- lemma 24 D foot of P to AB. AD/DB = P_PAB/P_PBA
   * --- lemma 25 AB ~_|_ PQ PY/QY = P_PAB/P_QAB
   * --- lemma 26 r_1 = PR/PQ ...
   * --- lemma 27 ABCD parallelogram
   * --- lemma 28 G(Y) = UY/UV G(V) + YV/UV(GU)
   * Lemma 29, EL2, Pratio Y W (Line U V) r)
   * Lemma 30, EL3, Inter Y (Line U V) (Line P Q)
   * Lemma 31, EL4, Foot Y P (Line U V)
   * Lemma 32, EL5, Foot Y P (Line U V) or Inter Y (Line U V) (Line P Q)
   * Lemma 33, EL6, Pratio Y W (Line U V) r
   * Lemma 34, EL7, Tratio Y (Line P Q) r
   * Lemma 35, EL8, Tratio Y (Line P Q) r
   * Lemma 36, EL9, Tratio Y (Line P Q) r
   * Lemma 37, Lemma 37 (reciprocial, EL10, Inter Y (Line U V) (Line P Q)
   * Lemma 38, EL11, Foot Y P (Line U V)
   * Lemma 39, Lemma 39 (reciprocial), EL12, Pratio Y R (Line P Q) r
   * Lemma 40, EL13, Tratio Y (Line P Q) r
   */

  // 0 - Statement
  // 1 - csAS (algebraic steps)
  // 2 - csGS (geometric steps)
  // 3-41 - Lemmas
  
  //                                     1 2 3  1  2 3a  4  5  6  7 8a  9 10 11 12 13 14 15  16 17 18 19 20 21 22  23 24a 25a 26a 27a 28a 29a  30  31  32b   33  34  35  36 37b 38 39 40  
  int coefficientSimplicity1st[NUMCS] = {1,1,1,10,16,21,25,18,14,22,84,74,13,10,14,21,8,138,142,18,31,15,23,59,228,46, 58,326,745,539,118,287,321,942,1848,2807,404,359,566,284,38,39,40};
  //                                     1 2 3  1  2 3a  4  5  6  7 8a  9 10 11 12 13 14 15  16 17 18 19 20 21 22  23 24a 25a 26a 27a 28a 29a  30  31  32b   33  34  35  36 37b 38 39 40
  int coefficientSimplicity2nd[NUMCS] = {1,1,1, 9,11,15,10,11,10,16,14,22,11, 6,11,15,5, 30, 39, 4, 9, 4, 6,12,  9,10,  7, 20, 36, 19, 14, 14, 10, 10,  10,  16, 13, 13,  9, 25,38,39,40};
  // The Coefficient of Simplicity of the construction
  int csConstruction;
  // Coefficient of Simplicity for the proof steps
  typedef struct cssteps {
    int step;
    int csStep;
  } CsSteps;
  CsSteps *listOfCsSteps;

%}

%token STATEMENT ALGEBRAICSTEPS GEOMETRICSTEPS LEMMA NUMBER


%%

entrada: 
	| entrada  linha
	;

linha:   '\n'
        | NUMBER { }
        | STATEMENT { steps++;
                      listOfCsSteps[steps-1].step = steps;
	              numberOcurrences[0]++;
		      if (steps==1) {
			listOfCsSteps[steps-1].csStep = csConstruction;
			csTotal+=csConstruction;
		      }
		      else {
			listOfCsSteps[steps-1].csStep = coefficientSimplicity1st[0];
			csTotal+=coefficientSimplicity1st[0];
		      }
		      // brake the (possible) alg. steps strike
		      consecutiveAlgSteps=0;
	            }
        | ALGEBRAICSTEPS { numberOcurrences[1]++;
			   if (consecutiveAlgSteps==0) {
			     steps++;
			     listOfCsSteps[steps-1].step = steps;
			     listOfCsSteps[steps-1].csStep = coefficientSimplicity1st[1];
			   }
			   else {
			     listOfCsSteps[steps-1].csStep += coefficientSimplicity1st[1];			     
			   }			   
			   consecutiveAlgSteps++;
			   csTotal+=coefficientSimplicity1st[1];
	                 }
        | GEOMETRICSTEPS { steps++;
	                   numberOcurrences[2]++; 
                           listOfCsSteps[steps-1].step = steps;
                           listOfCsSteps[steps-1].csStep = coefficientSimplicity1st[2];
			   csTotal+=coefficientSimplicity1st[2];
                           // brake the (possible) alg. steps strike
		           consecutiveAlgSteps=0;
	                 }
        | LEMMA NUMBER { steps++;
                         numberOcurrences[$2+2]++;
                         if (numberOcurrences[$2+2]==1) {
                           listOfCsSteps[steps-1].step = steps;
                           listOfCsSteps[steps-1].csStep = coefficientSimplicity1st[$2+2];
			   csTotal+=coefficientSimplicity1st[$2+2];
			 }
			 else {
                           listOfCsSteps[steps-1].step = steps;
                           listOfCsSteps[steps-1].csStep = coefficientSimplicity2nd[$2+2];
			   csTotal+=coefficientSimplicity2nd[$2+2];
			 }
                         // brake the (possible) alg. steps strike
		         consecutiveAlgSteps=0;
                       }
        | error '\n' { yyerrok;}
	;


%%


/*
 * The average value of the Coefficient of Simplicity for the Area Method Lemmas
 */
float avrgCoefficientSimplicityLemmas(int coefficientSimplicity[]) {
  float avrg=0;

  for (int i=3;i<NUMCS;i++) {
    avrg += coefficientSimplicity[i];
  }
  avrg = avrg/(NUMCS-3);
  return avrg;
}



/*
 * Number of different steps of high difficulty in the proof
 */
int numberOfDifStepsHighDifficulty(float highDifficulty,CsSteps listOfCsSteps[]){
  int numDSHD=0;
  
  for (int j=0;j<steps;j++){
    if (listOfCsSteps[j].csStep > highDifficulty) {
      numDSHD++;
    }
  }  
  return numDSHD;
}


/*
 * Highest simplicity coefficient of the lemmas applications
 */
int highestSimplicityCoefficient(CsSteps listOfCsSteps[]){
  int highest=0;

  for (int j=0;j<steps;j++){
    if (listOfCsSteps[j].csStep > highest) {
      highest=listOfCsSteps[j].csStep;
    }
  }
  return highest;
}


/*
 * Number of different Lemmas
 */
int numberOfDifferentLemmas(int numberOcurrences[]){
  int numDL=0;
  
  for (int j=3;j<NUMCS;j++) {
    if (numberOcurrences[j] != 0) numDL++;
  }
  return numDL;
}

/* 
 * Total number of steps in the proof (without the aggregations of AS e GS)
 */
int totalNumberSteps(int numberOcurrences[]){
  int tns=0;
  for (int j=1;j<NUMCS;j++) {
    tns += numberOcurrences[j];
  }
  return tns;
}

int main(int argc, char *argv[]){

  /*
   * Program to calculate the Geometrography Coeficient of Simplicity,
   * CS_proof, for a GCLC AM proof and also the Geometrography trace
   * of the same proof
   *
   * It also append to a CSV file the values of the Strong Readability
   * Coefficient of Proof. For that use the file "srcf.csv" should be
   * deleted previous to the running of the commands in a serie of
   * examples.
   */

  if (argc < 2) {
      printf("\nUsage: ./csproof cevaGEO0001.gcl\n\n");
      return 1;
  }

  int i;
  int compFileFullName, compFileName, compFileExtension, compFileCsConstructionExtension;

  FILE *fpGCLC,*fpLaTeX,*fpTraceLaTeX,*fpSRCP;

  listOfCsSteps = (CsSteps*) malloc(MAXNUMSTEPS*sizeof(CsSteps));

  compFileFullName = strlen(argv[1]);

  char *fileExt = strrchr(argv[1], '.');
  if (!fileExt) {
    //    printf("no extension\n");
  } else {
    fileExt++;
    //    printf("extension is %s\n", fileExt);
  }
  
  compFileFullName = strlen(argv[1]);
  compFileExtension = strlen(fileExt);
  compFileName = compFileFullName - (compFileExtension+1);

  char line[10000];
  
  char *fileName,*fileAux,*command,*teoName,*fileLaTeX,*fileTraceLaTeX,*nameTraceLaTeX,*fileNameSRCP;
  fileName = (char*) malloc((compFileName+1)*sizeof(char));
  fileName = strncpy(fileName,argv[1],compFileName);

  fileAux = (char*) malloc((compFileName+1)*sizeof(char));
  fileAux = strncpy(fileAux,argv[1],compFileName);

  // Name of the Theorem
  teoName = (char*) malloc((compFileName+1)*sizeof(char));
  teoName = strncpy(teoName,argv[1],compFileName);

  // Name of the LaTeX file (=name+.tex)
  fileLaTeX = (char*) malloc((compFileName+5)*sizeof(char));
  fileLaTeX = strncpy(fileLaTeX,argv[1],compFileName);
  fileLaTeX = strcat(fileLaTeX,".tex");
  
  // Name of the LaTeX trace file with extension (=name+trace.tex)
  fileTraceLaTeX = (char*) malloc((compFileName+10)*sizeof(char));
  fileTraceLaTeX = strncpy(fileTraceLaTeX,argv[1],compFileName);
  fileTraceLaTeX = strcat(fileTraceLaTeX,"trace.tex");
  
  // Name of the LaTeX trace file without extension (=name+trace)
  nameTraceLaTeX = (char*) malloc((compFileName+6)*sizeof(char));
  nameTraceLaTeX = strncpy(nameTraceLaTeX,argv[1],compFileName);
  nameTraceLaTeX = strcat(nameTraceLaTeX,"trace");
  
  // Name of the file with the SRCP values
  fileNameSRCP = (char*) malloc((11)*sizeof(char));
  fileNameSRCP = strncpy(fileNameSRCP,"srcf.csv",8);
  
  // build the command (bash) string
  command = (char*) malloc((22+compFileName+1)*sizeof(char));

  command = strcpy(command,"./csConstruction.bash ");
  command = strcat(command,argv[1]);
    
  // get the cs of the construction
  system(command); 

  compFileCsConstructionExtension = strlen(".csConstruction");
  
  char *fileNameCsConstruction;
  fileNameCsConstruction = (char*) malloc((compFileCsConstructionExtension+1)*sizeof(char));

  fileNameCsConstruction=strcat(fileName,".csConstruction");

  // Open the files to read and write respectively
  fpGCLC = fopen(fileNameCsConstruction,"r");
  //  fp = fopen("cevaGEO0001.csConstruction","r");

  fscanf(fpGCLC,"%d",&csConstruction);
  
  fpLaTeX = fopen(fileLaTeX,"w");

  fclose(fpGCLC);
  
  fpTraceLaTeX = fopen(fileTraceLaTeX,"w");

  // re-open the file with the GCLC code 
  fpGCLC = fopen(argv[1],"r");

  fscanf(fpGCLC,"%[^\n]",line);

  for (int i=0;i<strlen(line)-2;i++) {
    line[i] = line[i+2];
  }

  line[strlen(line)-2]='\0';
  
  // 0 - Statement
  // 1 - Algebraic Simplification
  // 2 - Geometric Simplification (Area Method Definitions, etc.)
  // 3 - Application of the Area Method Lemma 1
  // n+1 - Application of the Area Method Lemma n

  int compFileProofExtension = strlen("_proof.tex");
  
  char *fileNameProof;
  fileNameProof = (char*) malloc((compFileProofExtension+1)*sizeof(char));

  fileNameProof = strcat(fileAux,"_proof.tex");

  // To make the parsing from a file
  extern FILE * yyin;
  yyin = fopen(fileNameProof,"r");

  yyparse();
  
  coefficientSimplicity1st[0] = csConstruction;

  /*
   * The subproofs treatment it is still missing
   */
  // Building of the LaTeX file (subsection only) with the Proof line chart
  fprintf(fpLaTeX,"\\subsection{%s's Geometrography Proof Trace}\n",teoName);
  fprintf(fpLaTeX,"\\label{sec:%s}\n\n",teoName);
  fprintf(fpLaTeX,"%s --- %s\n\n",teoName,line);
  fprintf(fpLaTeX,"\\paragraph{Coeficient of simplicity} $cs_{\\mathrm{proof}} = %lld$\n\n",csTotal);
  fprintf(fpLaTeX,"\\paragraph{Geometrography Proof Trace} see figure~\\ref{fig:%s}\n",teoName); 
  fprintf(fpLaTeX,"\\begin{landscape}\n");
  fprintf(fpLaTeX,"\\begin{figure}[htbp!]\n");
  fprintf(fpLaTeX,"\\begin{center}\n");
  fprintf(fpLaTeX,"\\includestandalone[mode=buildnew,width=\\linewidth]{%s}\n",nameTraceLaTeX);
  fprintf(fpLaTeX,"\\end{center}\n");
  fprintf(fpLaTeX,"\\caption{%s's Geometrography Proof Trace}\n",teoName);
  fprintf(fpLaTeX,"\\label{fig:%s}\n",teoName);
  fprintf(fpLaTeX,"\\end{figure}\n");
  fprintf(fpLaTeX,"\\end{landscape}\n");
  fprintf(fpLaTeX,"\n");

  fclose(fpLaTeX);

  // Building of the TikZ picture (line chart)
  fprintf(fpTraceLaTeX,"\\begin{tikzpicture}\n");

  fprintf(fpTraceLaTeX,"\\begin{axis}[xmin=0,ymin=0,ymax=%d,enlargelimits=false]\n\\addplot[\nblack,\nxlabel=Proof Steps,\nylabel=Coefficients of Simplicity,\nthick,\nmark=*,\nmark options={fill=blue},\nvisualization depends on=\\thisrow{alignment} \\as \\alignment,\nnodes near coords,\npoint meta=explicit symbolic,\nevery node near coord/.style={anchor=\\alignment}\n] table [meta index=2] {\n",MAXVALUECSSTEPS);
  
  fprintf(fpTraceLaTeX,"x\ty\tlabel\talignment\n");
  for (int i=0;i<steps;i++) {
    fprintf(fpTraceLaTeX,"%d\t%d\t{}\t-40\n",listOfCsSteps[i].step,listOfCsSteps[i].csStep);
  }
  fprintf(fpTraceLaTeX,"};\n");
  fprintf(fpTraceLaTeX,"\\end{axis}\n");
  fprintf(fpTraceLaTeX,"\\end{tikzpicture}\n");

  fclose(fpTraceLaTeX);

  // Building of the CSV file
  fpSRCP = fopen(fileNameSRCP,"a");
  
  float W,Y,K, M, avrgSteps, highDifficulty, SRCP;
  W = totalNumberSteps(numberOcurrences);
  // Average value, coefficient of simplicity of GCLC AM Lemmas
  avrgSteps = avrgCoefficientSimplicityLemmas(coefficientSimplicity1st);
  // the high difficulty threshold must be validated 
  highDifficulty = avrgSteps*1.7;
  Y = numberOfDifStepsHighDifficulty(highDifficulty,listOfCsSteps);
  K = numberOfDifferentLemmas(numberOcurrences);
  M = highestSimplicityCoefficient(listOfCsSteps);
  SRCP = (Y/W) + (K/W);

  // Name of the GCLC Theorem
  fprintf(fpSRCP,"%s ; ",teoName);
  
  // CS_GCL
  fprintf(fpSRCP,"%d ; ",csConstruction);
  
  // CS_proof
  fprintf(fpSRCP,"%d ; ",csTotal);
  
  // Number of steps in the proof
  fprintf(fpSRCP,"%.0f ; ",W);
  
  // Number of different steps of high difficulty in the proof
  fprintf(fpSRCP,"%.0f ; ",Y);

  // Number of different Lemmas applied
  fprintf(fpSRCP,"%.0f ; ",K);
  // The highest simplicity coefficient of the lemmas application
  fprintf(fpSRCP,"%.0f ; ",M);  
  // Strong Readability Coefficient of Proof 
  fprintf(fpSRCP,"%.3f\n",SRCP);

  fclose(fpSRCP);

  return(0);
}



int yyerror(s)
char *s; {
}
