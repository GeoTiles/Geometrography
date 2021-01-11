#!/bin/bash

#
# Calculates the coefficients of simplicity and freedom of a GCLC
# construction, available in TGTP.
#
# (C) 2018 Nuno Baeta <nmsbaeta@gmail.com>
#          Pedro Quaresma <pedro@mat.uc.pt>

fullfile=$1

filename=$(basename -- "$fullfile")
extension="${filename##*.}"
filename="${filename%.*}"

# Check if file with figures was supplied as a parameter
if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "use:  ./csGCLC.bash <GCLC file>"
    exit 1
fi

# Create CSV file (geometrography_results.csv) with results
# rm -rf $filename.csGCLC
# touch $filename.csGCLC

# Regular expressions to deal with 'intersec' and 'intersec2' constructions
intersec="^(intersec|intersection)" # Begin with intersec ou intersection
intersec2="^(intersec2$|intersection2$)" # Begin with intersec2 ou intersection2
spcid="[[:blank:]]+[0-1A-Z_\'a-z\{\}]+" # Spaces followed by an identifier

# Initialize the counters
point=0			# Nr. of 'point' constructions
line=0			# Nr. of 'line' construction
circle=0		# Nr. of 'circle' construction
intersec2l=0		# Nr. of 'intersec' (2 lines) constructions
intersec4p=0		# Nr. of 'intersec' (4 points) construction
intersec2=0		# Nr. of 'intersec2'basic constructions
midpoint=0		# Nr. of 'midpoint' construction
med=0			# Nr. of 'med' construction
bis=0			# Nr. of 'bis' construction
perp=0			# Nr. of 'perp' construction
foot=0			# Nr. of 'foot' construction
parallel=0		# Nr. of 'parallel' construction
onsegment=0		# Nr. of 'onsegment' construction
online=0		# Nr. of 'online' construction
oncircle=0		# Nr. of 'online' construction

while read in_line
do
    # Disregard the comment lines (do nothing)
    if [[ $in_line != %* ]] 
    then
	# Found a 'point' basic construction
	if [[ $in_line == point* ]]
	then
	    let point=point+1
	fi
	
	# Found a 'line' basic construction
	if [[ $in_line == line* ]]
	then
	    let line=line+1
	fi
	
	# Found a 'circle' basic construction
	if [[ $in_line == circle* ]]
	then
	    
	    let circle=circle+1
	fi
	
	# UGLY CODE - TO BE CORRECTED
	if [[ "$in_line" =~ ^(intersec2|intersection2)$spcid$spcid$spcid$spcid$ ]]
	then
	    let intersec2=intersec2+1
	fi
	
	# Found a 'intersec' (2 lines) basic construction
	if [[ $in_line =~ $intersec$spcid$spcid$spcid$ ]]
	then
	    let intersec2l=intersec2l+1
	fi
	
	# Found a 'intersec' (4 points) basic construction
	if [[ $in_line =~ $intersec$spcid$spcid$spcid$spcid$spcid$ ]]
	then
	    let intersec4p=intersec4p+1
	fi
	
	# # Found a 'intersec2' basic construction
	# if [[ $in_line =~ $intersec2$spcid$spcid$spcid$spcid$ ]]
	# then
	# 	echo "ENCONTREI UM INTERSEC2 : $in_line"
	# 	let intersec2=intersec2+1
	# fi
	
	if [[ $in_line == intersec2* ]]
	then
	    echo "still missing"
	fi
	
	# Found a 'midpoint' basic construction
	if [[ $in_line == midpoint* ]]
	then
	    let midpoint=midpoint+1
	fi
	
	# Found a 'med' basic construction
	if [[ $in_line == med* ]]
	then
	    let med=med+1
	fi
	
	# Found a 'bis' basic construction
	if [[ $in_line == bis* ]]
	then
	    let bis=bis+1
	fi
	
	# Found a 'perp' basic construction
	if [[ $in_line == perp* ]]
	then
	    let perp=perp+1
	fi
	
	# Found a 'foot' basic construction
	if [[ $in_line == foot* ]]
	then
	    let foot=foot+1
	fi

	# Found a 'parallel' basic construction
	if [[ $in_line == parallel* ]]
	then
	    let parallel=parallel+1
	fi

	# Found a 'onsegment' basic construction
	if [[ $in_line == onsegment* ]]
	then
	    let onsegment=onsegment+1
	fi

	# Found a 'online' basic construction
	if [[ $in_line == online* ]]
	then
	    let online=online+1
	fi

	# Found a 'oncircle' basic construction
	if [[ $in_line == oncircle* ]]
	then
	    let oncircle=oncircle+1
	fi
    fi
done < ./$fullfile


# Calculate and show the coefficient of simplicity
let simplicity=point
let simplicity=simplicity+2*line
let simplicity=simplicity+2*circle
let simplicity=simplicity+2*intersec2l
let simplicity=simplicity+4*intersec4p
let simplicity=simplicity+2*intersec2
let simplicity=simplicity+2*midpoint
let simplicity=simplicity+2*med
let simplicity=simplicity+3*bis
let simplicity=simplicity+2*perp
let simplicity=simplicity+2*foot
let simplicity=simplicity+2*parallel
let simplicity=simplicity+2*onsegment
let simplicity=simplicity+2*online
let simplicity=simplicity+2*oncircle

echo -n "$simplicity" > $filename.csConstruction

# Calculate and show the coefficient of freedom
let degree2=point
let degree1=onsegment
let degree1=degree1+online
let degree1=degree1+oncircle

#echo "  Degrees of freedom:     2 x $degree2 + $degree1"
let freedom=2*degree2+degree1
#echo "  Coefficient of freedom: $freedom"
#echo ""
#echo "Nr. of figures: $figures"

#echo "$freedom" >> $filename.csv

exit 0
