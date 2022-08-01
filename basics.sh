#!/bin/zsh

function fn_args(){
    echo "name of function: $0"
    echo "first argument: ${1}"
    echo "lower case: ${1:l}"

    dbl=$(( $2 * 2 ))
    echo "2 * $2 is $dbl"
}

#Calling a function with arguments
fn_args "arg0" 123

#Defining arrays - without commas
fruits=("Apple" "Banana" "Orange")

echo "The first element is: ${fruits[1]}" 
echo ${fruits[@]} # All elements, space-separated
echo "The length of array is: ${#fruits[@]}"  

#Looping an array
for f in $fruits 
do
    echo "$f" 
done     