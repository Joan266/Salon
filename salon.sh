#!/bin/bash
 echo -e "\n~~~~~ MY SALON ~~~~~\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
 AVAILABLE_SERVICES_FUNCTION(){
AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
 echo "$AVAILABLE_SERVICES" | while IFS=" |" read SERVICE_ID SERVICE_NAME
      do
         echo "$SERVICE_ID) $SERVICE_NAME"
      done
      read SERVICE_ID_SELECTED
      AVAILABLE_SERVICES_ID=$($PSQL "SELECT service_id FROM services WHERE $SERVICE_ID_SELECTED=service_id")
 }
 
MAIN_MENU() {
  echo -e 'Welcome to My Salon, how can I help you?\n'
  AVAILABLE_SERVICES_FUNCTION
    if [[ -z $AVAILABLE_SERVICES_ID ]]
    then
    echo -e '\nI could not find that service. What would you like today?\n'
    AVAILABLE_SERVICES_FUNCTION
    fi
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE '$CUSTOMER_PHONE'= phone")
   if [[ -z $CUSTOMER_ID ]]
    then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMERS_INFO=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")21
     CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE '$CUSTOMER_PHONE'=phone")
    fi
    SELECT_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE '$CUSTOMER_PHONE' = phone")
    echo -e "\nWhat time would you like your cut,$SELECT_CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_CUSTOMERS_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
    if [[ $INSERT_CUSTOMERS_INFO == "INSERT 0 1" ]]
then
SELECT_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE '$CUSTOMER_PHONE' = phone")
NAME_SERVICE=$($PSQL "SELECT name FROM services WHERE $SERVICE_ID_SELECTED = service_id")
  echo -e "\nI have put you down for a$NAME_SERVICE at $SERVICE_TIME,$SELECT_CUSTOMER_NAME."
fi
}
 MAIN_MENU
