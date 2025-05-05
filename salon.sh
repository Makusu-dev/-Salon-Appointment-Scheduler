#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~Salon sheduler~~~\n"

#Get list of services



MAIN_MENU() {

if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

SERVICES=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")
echo -e "\nHow may I help you ?\n"
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo -e "$SERVICE_ID) $SERVICE_NAME\n"
done

read SERVICE_ID_SELECTED 

SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -z $SERVICE_NAME_SELECTED ]]
then 
  MAIN_MENU "Please enter the number assiocated to an existing service."
else
  SERVICE_MENU
fi

}

SERVICE_MENU() {

echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
 
 if [[ -z $CUSTOMER_NAME ]]
 then
   echo -e "\nPlease enter your name"
   read CUSTOMER_NAME
   #insert new customer
   INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')") 
 fi

echo -e "\nAt what time would you like to take the appointment?"
read SERVICE_TIME

#get customer id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

#enter the appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU