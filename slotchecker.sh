#!/bin/zsh

URL="https://www.google.com"
MAX_ATTEMPTS=30

#Waiting time between retries, in seconds.
MIN_WAIT_TIME=120
MAX_WAIT_TIME=180

#Loading animation phases
NUMBER_OF_PHASES=10


#$1: NUMBER_OF_PHASES ie. 5
### Modify global array named loadingIndicators
### i.e. loadingIndicators=('▮▯▯▯▯▯ ' '▮▮▯▯▯▯ ' '▮▮▮▯▯▯ ' '▮▮▮▮▯▯ ' '▮▮▮▮▮▯ ')
function createProgressIndicators() {

  currentIndicator='' # i.e '▮▯▯▯▯'

  for i in {1..$1}
  do
    # A string composed of 2 parts, completed and remaining, i.e ▮▯▯▯▯
    for completed in {1..$i}
    do
      currentIndicator+=▮
    done

    for remaining in {$i..$1}
    do
        currentIndicator+=▯
    done

    # echo $currentIndicator #debugPrint
    loadingIndicators[$i]=$currentIndicator
    currentIndicator=''
  done
}

function wait_and_inform(){

    #total sleep duration
    timeBetweenRetries=$(( $RANDOM % $variable_time_limit + $MIN_WAIT_TIME ))

    notificationInterval=$(( $timeBetweenRetries / $NUMBER_OF_PHASES ))
    echo "Shot $attempt/$MAX_ATTEMPTS - The next round is due $timeBetweenRetries seconds."

    # for i in {1..5}
    timeSpent=0
    for i in $loadingIndicators
    do
        remainingTime=$(( $timeBetweenRetries - $timeSpent))
        echo -ne "$i $remainingTime seconds left \r"
        sleep $notificationInterval
        (( timeSpent += notificationInterval ))    
    done 

    remainingSleepTime=$(( $timeBetweenRetries - ($NUMBER_OF_PHASES * $notificationInterval) ))
    sleep $remainingSleepTime

}

#Global array for indicator list
#loadingIndicators=('▮▯▯▯▯▯ ' '▮▮▯▯▯▯ ' '▮▮▮▯▯▯ ' '▮▮▮▮▯▯ ' '▮▮▮▮▮▯ ')
loadingIndicators=()
createProgressIndicators $NUMBER_OF_PHASES #call function with the argument

variable_time_limit=$(( $MAX_WAIT_TIME - $MIN_WAIT_TIME ))

attempt=0
while [[ $attempt -lt $MAX_ATTEMPTS ]]
do 
    (( attempt += 1 ))
   
    open -a "Google Chrome" $URL

    #sleep 10; echo "will try again in 10 seconds"
    wait_and_inform

done  # while

echo -ne "Thats it for this time.. \r"
# A non-zero (1-255) exit status indicates failure.
exit 0

