#include "platform.h"
#define INT_VALUE 0x73 //s in asci code

  int stop_counter;
  int chislo;
  int power;

int Fibanachi( int Number ) {
  int Sum   = 0;
  int Now   = 1;
  int Pre   = 0;
  int Cntr  = 1;

  if( Number == 0 ) {
    Sum = 0;
  }
  else if( Number == 1 ) {
    Sum = 1;
  }
  else {
    while( Cntr < Number ) {
      Sum = Now + Pre;
      Pre = Now;
      Now = Sum;
      Cntr++; 
    }
  }
  return ( Sum );
}


int main(int argc, char** argv)
{
  chislo = 0;
  power = 0;
  stop_counter = 0;
  int res = 0;
  rx_ptr->baudrate = 115200;
  tx_ptr->baudrate = 115200;
  for( ;; ) {
    if( stop_counter == 2 ) {
      stop_counter = 0;
      res = Fibanachi(chislo);
      chislo = 0;
      power   = 0;
      for(int i = 3; i != -1; i-- ){
        if(i == 3){
          tx_ptr->data ='0' + (int)(res / (1000));
        }
        if(i == 2){
          tx_ptr->data ='0' + (int)(res / (100));
        }
        if(i == 1){
          tx_ptr->data ='0' + (int)(res / (10));
        }
        if(i == 0){
          tx_ptr->data ='0' + res % 10 ;
        }
      }
    }
  }
}



void int_handler()
{
if(INT_VALUE == rx_ptr->data && rx_ptr->unread_data)
  {
    tx_ptr->data = rx_ptr->data;
    stop_counter++;
  }
else if(stop_counter == 1 && rx_ptr->unread_data )
{
  switch(power)
  {
    case 0:{ chislo += (rx_ptr->data - '0')*1000;
        tx_ptr->data = rx_ptr->data;
        power++;
        break;}
    case 1:{ chislo += (rx_ptr->data - '0')*100;
        tx_ptr->data = rx_ptr->data;
        power++;
        break;}
    case 2:{ chislo += (rx_ptr->data - '0')*10;
        tx_ptr->data = rx_ptr->data;
        power++;
        break;}
    case 3:{ chislo += (rx_ptr->data - '0');
        tx_ptr->data = rx_ptr->data;
        power++;
        break;}
  }
    
}

}